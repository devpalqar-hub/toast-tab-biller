class BatchItemModel {
  String? menuItemId;
  int? quantity;
  String? notes;
  String? status;

  BatchItemModel({this.menuItemId, this.quantity, this.notes, this.status});

  BatchItemModel.fromJson(Map<String, dynamic> json) {
    menuItemId = json['menuItemId'];
    quantity = json['quantity'];
    notes = json['notes'];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuItemId'] = this.menuItemId;
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    return data;
  }
}
