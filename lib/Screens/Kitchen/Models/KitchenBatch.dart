class KitchenBatchItem {
  final String itemId;
  final String batchItemId; // id of the batch-item record for PATCH
  final String name;
  final int quantity;
  String status; // PENDING | PREPARING | PREPARED | SERVED | CANCELLED

  KitchenBatchItem({
    required this.itemId,
    required this.batchItemId,
    required this.name,
    required this.quantity,
    this.status = 'PENDING',
  });

  factory KitchenBatchItem.fromJson(Map<String, dynamic> json) =>
      KitchenBatchItem(
        itemId: json['id'] ?? '', // batch-item record id (unique)
        batchItemId: json['id'] ?? '',
        name: json['menuItem']?['name'] ?? '',
        quantity: json['quantity'] ?? 1,
        status: json['status'] ?? 'PENDING',
      );
}

class KitchenBatch {
  final String batchId;
  final String batchNumber;
  final String sessionId;
  final String sessionNumber;
  final String tableId;
  final String tableName;
  final String createdByName;
  final DateTime createdAt;
  List<KitchenBatchItem> items;

  KitchenBatch({
    required this.batchId,
    required this.batchNumber,
    required this.sessionId,
    required this.sessionNumber,
    required this.tableId,
    required this.tableName,
    required this.createdByName,
    required this.createdAt,
    required this.items,
  });

  factory KitchenBatch.fromJson(Map<String, dynamic> json) => KitchenBatch(
    batchId: json['id'] ?? '',
    batchNumber: json['batchNumber'] ?? '',
    sessionId: json['session']?['id'] ?? '',
    sessionNumber: json['session']?['sessionNumber'] ?? '',
    tableId: json['session']?['tableId'] ?? '',
    tableName:
        json['session']?['table']?['name'] ?? json['session']?['tableId'] ?? '',
    createdByName: json['createdBy']?['name'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    items: (json['items'] as List? ?? [])
        .map((i) => KitchenBatchItem.fromJson(i))
        .toList(),
  );

  int get elapsedMinutes => DateTime.now().difference(createdAt).inMinutes;
}

// Groups all batches under one session for the Kanban card
class KitchenSession {
  final String sessionId;
  final String sessionNumber;
  final String tableName;
  bool isBilled; // removed from "Ready" column when true
  List<KitchenBatch> batches;

  KitchenSession({
    required this.sessionId,
    required this.sessionNumber,
    required this.tableName,
    this.isBilled = false,
    required this.batches,
  });

  // ── Derived column placement ───────────────────────────────────────────────

  /// All items across all batches
  List<KitchenBatchItem> get allItems =>
      batches.expand((b) => b.items).toList();

  bool get allPrepared =>
      allItems.isNotEmpty &&
      allItems.every(
        (i) =>
            i.status == 'PREPARED' ||
            i.status == 'SERVED' ||
            i.status == 'CANCELLED',
      );

  bool get allLeftPending =>
      allItems.isNotEmpty && allItems.every((i) => i.status == 'PENDING');

  /// Column placement — only advances when EVERY item has cleared that stage:
  ///   PENDING   → every item is still PENDING
  ///   PREPARING → at least one item is PREPARING/PREPARED but not all done
  ///   READY     → every item is PREPARED / SERVED / CANCELLED
  ///   BILLED    → removed
  String get column {
    if (isBilled) return 'BILLED';
    if (allPrepared) return 'READY';
    if (allLeftPending) return 'PENDING';
    return 'PREPARING';
  }

  int get oldestElapsed => batches.isEmpty
      ? 0
      : batches.map((b) => b.elapsedMinutes).reduce((a, b) => a > b ? a : b);
}
