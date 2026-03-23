class CustomerModel {
  String? id;
  String? restaurantId;
  String? phone;
  String? name;
  String? email;
  String? wallet;
  bool? isActive;

  CustomerModel(
      {this.id,
      this.restaurantId,
      this.phone,
      this.name,
      this.email,
      this.wallet,
      this.isActive});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurantId'];
    phone = json['phone'];
    name = json['name'];
    email = json['email'];
    wallet = json['wallet'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantId'] = this.restaurantId;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['email'] = this.email;
    data['wallet'] = this.wallet;
    data['isActive'] = this.isActive;
    return data;
  }
}
