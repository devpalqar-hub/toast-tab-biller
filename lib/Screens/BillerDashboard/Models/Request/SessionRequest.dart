class SessionRequest {
  String? restaurantId;
  String? tableId;
  String? channel;
  int? guestCount;

  SessionRequest({
    this.restaurantId,
    this.tableId,
    this.channel,
    this.guestCount,
  });

  SessionRequest.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    tableId = json['tableId'];
    channel = json['channel'];
    guestCount = json['guestCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['tableId'] = this.tableId;
    data['channel'] = this.channel;
    data['guestCount'] = this.guestCount;
    return data;
  }
}
