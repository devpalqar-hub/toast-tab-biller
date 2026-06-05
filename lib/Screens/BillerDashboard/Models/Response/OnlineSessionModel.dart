class OnlineSessionResponse {
  final bool success;
  final List<OnlineSession> data;

  OnlineSessionResponse({
    required this.success,
    required this.data,
  });

  factory OnlineSessionResponse.fromJson(Map<String, dynamic> json) {
    return OnlineSessionResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List?)
              ?.map((e) => OnlineSession.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OnlineSession {
  final String? id;
  final String? sessionNumber;
  final String? channel;
  final String? status;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? totalAmount;
  final String? subtotal;
  final String? deliveryAddress;
  final String? createdAt;
  final String? externalOrderId;

  OnlineSession({
    this.id,
    this.sessionNumber,
    this.channel,
    this.status,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.totalAmount,
    this.subtotal,
    this.deliveryAddress,
    this.createdAt,
    this.externalOrderId,
  });

  factory OnlineSession.fromJson(Map<String, dynamic> json) {
    return OnlineSession(
      id: json["id"],
      sessionNumber: json["sessionNumber"],
      channel: json["channel"],
      status: json["status"],
      customerName: json["customerName"],
      customerPhone: json["customerPhone"],
      customerEmail: json["customerEmail"],
      totalAmount: json["totalAmount"]?.toString(),
      subtotal: json["subtotal"]?.toString(),
      deliveryAddress: json["deliveryAddress"],
      createdAt: json["createdAt"],
      externalOrderId: json["externalOrderId"],
    );
  }
}