class TableModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<TableData> data;
  final Meta meta;
  final String timestamp;

  TableModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
    required this.timestamp,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => TableData.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class TableData {
  final String id;
  final String restaurantId;
  final String groupId;
  final String name;
  final int seatCount;
  final String status;
  final bool isActive;
  final String createdById;
  final String createdAt;
  final String updatedAt;
  final Group group;

  TableData({
    required this.id,
    required this.restaurantId,
    required this.groupId,
    required this.name,
    required this.seatCount,
    required this.status,
    required this.isActive,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    required this.group,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      groupId: json['groupId'] ?? '',
      name: json['name'] ?? '',
      seatCount: json['seatCount'] ?? 0,
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
      createdById: json['createdById'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      group: Group.fromJson(json['group'] ?? {}),
    );
  }
}

class Group {
  final String id;
  final String name;
  final String color;

  Group({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}