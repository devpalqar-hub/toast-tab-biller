import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:toasttab/main.dart'; // baseUrl, restaurantId, authToken
import 'package:toasttab/Screens/Kitchen/Models/KitchenBatch.dart';

enum KitchenFilter { all, pending, ready }

class KitchenController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  List<KitchenBatch> batches = [];
  KitchenFilter activeFilter = KitchenFilter.all;
  bool isConnected = false;
  bool isLoading = true;
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

  // ── Socket Setup ───────────────────────────────────────────────────────────
  void _connectSocket() {
    print("connection " + "${baseUrl.replaceAll("api/v1/", "")}/orders");
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
      print("connected");

      // Join kitchen room to receive batch events
      _socket.emit('join:restaurant', {'restaurantId': restaurantId});

      _socket.emit('join:kitchen', {'restaurantId': restaurantId});

      update();
    });

    _socket.onDisconnect((_) {
      isConnected = false;
      update();
    });

    _socket.onConnectError((err) {
      isConnected = false;
      print(err);
      errorMessage = 'Connection failed';
      update();
    });

    // ── Event Listeners ──────────────────────────────────────────────────────

    // New batch arrives from kitchen room
    _socket.on('batch:created', (data) {
      final batch = KitchenBatch.fromJson(
        data is String ? json.decode(data) : data,
      );
      batches.insert(0, batch); // newest first
      update();
    });

    // Batch-level status change (e.g. READY)
    _socket.on('batch:status:changed', (data) {
      final map = data is String ? json.decode(data) : data;
      final idx = batches.indexWhere((b) => b.batchId == map['batchId']);
      if (idx != -1) {
        batches[idx].overallStatus = map['status'] ?? '';
        update();
      }
    });

    // Individual item status change
    _socket.on('item:status:changed', (data) {
      final map = data is String ? json.decode(data) : data;
      for (final batch in batches) {
        for (final item in batch.items) {
          if (item.itemId == map['itemId']) {
            item.status = map['status'] ?? item.status;
            update();
            return;
          }
        }
      }
    });

    _socket.on('error', (data) {
      final map = data is String ? json.decode(data) : data;
      errorMessage = map['message'];
      update();
    });
  }

  // ── REST: Update item status ───────────────────────────────────────────────
  Future<void> updateItemStatus({
    required String batchId,
    required String itemId,
    required String newStatus,
  }) async {
    // Optimistic update
    for (final batch in batches) {
      if (batch.batchId == batchId) {
        for (final item in batch.items) {
          if (item.itemId == itemId) {
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
          '/batches/$batchId/items/$itemId/status',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'status': newStatus}),
      );
    } catch (_) {
      // Revert on failure — re-fetch or show error as needed
      update();
    }
  }

  // ── Filter helpers ─────────────────────────────────────────────────────────
  void setFilter(KitchenFilter f) {
    activeFilter = f;
    update();
  }

  List<KitchenBatch> get filteredBatches {
    switch (activeFilter) {
      case KitchenFilter.pending:
        return batches.where((b) => b.hasPending).toList();
      case KitchenFilter.ready:
        return batches.where((b) => b.isReady).toList();
      case KitchenFilter.all:
      default:
        return batches;
    }
  }

  int get pendingCount => batches.where((b) => b.hasPending).length;
  int get readyCount => batches.where((b) => b.isReady).length;

  // ── Next status logic ──────────────────────────────────────────────────────
  String? nextStatus(String current) {
    const flow = {
      'PENDING': 'PREPARING',
      'PREPARING': 'PREPARED',
      'PREPARED': 'SERVED',
    };
    return flow[current];
  }
}
