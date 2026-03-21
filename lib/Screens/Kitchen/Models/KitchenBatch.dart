class KitchenBatchItem {
  final String itemId;
  final String name;
  final int quantity;
  final double unitPrice;
  String status; // PENDING | PREPARING | PREPARED | SERVED | CANCELLED

  KitchenBatchItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.status = 'PENDING',
  });

  factory KitchenBatchItem.fromJson(Map<String, dynamic> json) =>
      KitchenBatchItem(
        itemId: json['menuItem']['id'] ?? '',
        name: json['menuItem']['name'] ?? '',
        quantity: json['quantity'] ?? 1,
        unitPrice: (json['unitPrice'] ?? 0).toDouble(),
        status: json['status'] ?? 'PENDING',
      );
}

class KitchenBatch {
  final String batchId;
  final String batchNumber;
  final String sessionId;
  final String sessionNumber;
  final String tableId;
  final String createdByName;
  final DateTime createdAt;
  List<KitchenBatchItem> items;
  String overallStatus; // derived: PENDING | PREPARING | READY | DONE

  KitchenBatch({
    required this.batchId,
    required this.batchNumber,
    required this.sessionId,
    required this.sessionNumber,
    required this.tableId,
    required this.createdByName,
    required this.createdAt,
    required this.items,
    this.overallStatus = 'PENDING',
  });

  factory KitchenBatch.fromJson(Map<String, dynamic> json) => KitchenBatch(
        batchId: json['id'] ?? '',
        batchNumber: json['batchNumber'] ?? '',
        sessionId: json['session']?['id'] ?? '',
        sessionNumber: json['session']?['sessionNumber'] ?? '',
        tableId: json['session']?['tableId'] ?? '',
        createdByName: json['createdBy']?['name'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        items: (json['items'] as List? ?? [])
            .map((i) => KitchenBatchItem.fromJson(i))
            .toList(),
      );

  /// Returns elapsed minutes since batch was created
  int get elapsedMinutes =>
      DateTime.now().difference(createdAt).inMinutes;

  /// True if any item is still PENDING or PREPARING
  bool get hasPending => items.any(
      (i) => i.status == 'PENDING' || i.status == 'PREPARING');

  /// True if all items are PREPARED or SERVED
  bool get isReady =>
      items.isNotEmpty &&
      items.every((i) => i.status == 'PREPARED' || i.status == 'SERVED');
}
