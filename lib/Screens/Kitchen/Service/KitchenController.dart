import 'dart:convert';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:toasttab/main.dart';
import 'package:toasttab/Screens/Kitchen/Models/KitchenBatch.dart';

class KitchenController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  /// Keyed by sessionId for O(1) lookup
  final Map<String, KitchenSession> _sessionMap = {};

  bool isConnected = false;
  String? errorMessage;

  late IO.Socket _socket;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _connectSocket();
  }

  @override
  void onClose() {
    _socket.dispose();
    super.onClose();
  }

  // ── Column accessors ───────────────────────────────────────────────────────
  List<KitchenSession> _col(String col) =>
      _sessionMap.values.where((s) => s.column == col).toList()
        ..sort((a, b) => b.oldestElapsed.compareTo(a.oldestElapsed));

  List<KitchenSession> get pendingSessions => _col('PENDING');
  List<KitchenSession> get preparingSessions => _col('PREPARING');
  List<KitchenSession> get readySessions => _col('READY');
  // BILLED sessions are never shown

  // ── Socket ─────────────────────────────────────────────────────────────────
  void _connectSocket() {
    _socket = IO.io(
      'https://api.pos.palqar.cloud/orders',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'authorization': 'Bearer $authToken'})
          .setAuth({'token': 'Bearer $authToken'})
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      isConnected = true;
      _socket.emit('join:restaurant', {'restaurantId': restaurantId});
      _socket.emit('join:kitchen', {'restaurantId': restaurantId});
      _socket.emit('join:billing', {'restaurantId': restaurantId});
      update();
    });

    _socket.onDisconnect((_) {
      isConnected = false;
      update();
    });

    _socket.onConnectError((_) {
      isConnected = false;
      errorMessage = 'Connection failed';
      update();
    });

    // ── batch:created → add batch to its session (create session if new) ─────
    _socket.on('batch:created', (raw) {
      print(raw);
      final data = raw is String ? json.decode(raw) : raw;
      final batch = KitchenBatch.fromJson(data);

      // Guard: skip if this batchId was already received (duplicate room emit)
      final existingSession = _sessionMap[batch.sessionId];
      if (existingSession != null) {
        final alreadyExists = existingSession.batches.any(
          (b) => b.batchId == batch.batchId,
        );
        if (alreadyExists) return; // deduplicate
        existingSession.batches.add(batch);
      } else {
        _sessionMap[batch.sessionId] = KitchenSession(
          sessionId: batch.sessionId,
          sessionNumber: batch.sessionNumber,
          tableName: batch.tableName,
          batches: [batch],
        );
      }
      update();
    });

    // ── item:status:changed → find item across all sessions/batches ──────────
    _socket.on('item:status:changed', (raw) {
      final data = raw is String ? json.decode(raw) : raw;
      final itemId = data['itemId'] as String?;
      final newStatus = data['status'] as String?;
      if (itemId == null || newStatus == null) return;

      for (final session in _sessionMap.values) {
        for (final batch in session.batches) {
          for (final item in batch.items) {
            if (item.itemId == itemId) {
              item.status = newStatus;
              update();
              return;
            }
          }
        }
      }
    });

    // ── bill:paid / session:status:changed → mark session billed → remove ────
    _socket.on('bill:generated', (raw) {
      print("bill generated");
      final data = raw is String ? json.decode(raw) : raw;
      final sid = data['sessionId'] as String?;
      if (sid != null && _sessionMap.containsKey(sid)) {
        _sessionMap[sid]!.isBilled = true;
        // Remove after brief delay so chef sees it disappear
        Future.delayed(const Duration(seconds: 2), () {
          _sessionMap.remove(sid);
          update();
        });
        update();
      }
    });

    _socket.on('session:status:changed', (raw) {
      final data = raw is String ? json.decode(raw) : raw;
      if ((data['status'] as String?)?.toUpperCase() == 'PAID') {
        final sid = data['sessionId'] as String?;
        if (sid != null) {
          _sessionMap[sid]?.isBilled = true;
          Future.delayed(const Duration(seconds: 2), () {
            _sessionMap.remove(sid);
            update();
          });
          update();
        }
      }
    });

    _socket.on('error', (raw) {
      final data = raw is String ? json.decode(raw) : raw;
      errorMessage = data['message'] as String?;
      update();
    });
  }

  // ── REST: advance item status ──────────────────────────────────────────────
  Future<void> updateItemStatus({
    required String sessionId,
    required String batchId,
    required String batchItemId,
    required String newStatus,
  }) async {
    // Optimistic
    final session = _sessionMap[sessionId];
    if (session == null) return;
    for (final b in session.batches) {
      if (b.batchId == batchId) {
        for (final item in b.items) {
          if (item.batchItemId == batchItemId) {
            item.status = newStatus;
            break;
          }
        }
      }
    }
    update();

    try {
      await http.patch(
        Uri.parse(
          '$baseUrl/orders/restaurants/$restaurantId'
          '/batches/$batchId/items/$batchItemId/status',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'status': newStatus}),
      );
    } catch (_) {
      update();
    }
  }

  String? nextStatus(String current) => const {
    'PENDING': 'PREPARING',
    'PREPARING': 'PREPARED',
    'PREPARED': 'SERVED',
  }[current];
}
