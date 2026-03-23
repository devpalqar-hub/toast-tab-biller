class MenuItemRequest {
  String? menuItemId;
  int? quantity;

  MenuItemRequest({this.menuItemId, this.quantity});

  MenuItemRequest.fromJson(Map<String, dynamic> json) {
    menuItemId = json['menuItemId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuItemId'] = this.menuItemId;
    data['quantity'] = this.quantity;
    return data;
  }
}
