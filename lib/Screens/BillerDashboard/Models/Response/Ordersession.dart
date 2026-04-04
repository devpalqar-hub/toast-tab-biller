class BillSummaryModel {
  String? sessionId;
  String? restaurantId;
  String? status;
  String? subtotal;
  String? taxRate;
  String? taxAmount;
  String? discountAmount;
  String? totalAmount;
  String? loyalityPointDiscountAmount;
  String? notes;
  List<Items>? items;
  Session? session;
  Coupon? coupon;
  Loyalty? loyalty;

  BillSummaryModel({
    this.sessionId,
    this.restaurantId,
    this.status,
    this.subtotal,
    this.taxRate,
    this.taxAmount,
    this.discountAmount,
    this.totalAmount,
    this.notes,
    this.items,
    this.session,
    this.coupon,
    this.loyalty,
    this.loyalityPointDiscountAmount,
  });

  BillSummaryModel.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    restaurantId = json['restaurantId'];
    status = json['status'];
    subtotal = json['subtotal'];
    taxRate = json['taxRate'];
    taxAmount = json['taxAmount'];
    discountAmount = json['discountAmount'];
    totalAmount = json['totalAmount'];
    loyalityPointDiscountAmount = json["loyalityPointDiscountAmount"];
    notes = json['notes'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    session = json['session'] != null
        ? new Session.fromJson(json['session'])
        : null;
    coupon = json['coupon'] != null
        ? new Coupon.fromJson(json['coupon'])
        : null;
    loyalty = json['loyalty'] != null
        ? new Loyalty.fromJson(json['loyalty'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionId'] = this.sessionId;
    data['restaurantId'] = this.restaurantId;
    data['status'] = this.status;
    data['subtotal'] = this.subtotal;
    data['taxRate'] = this.taxRate;
    data['taxAmount'] = this.taxAmount;
    data['discountAmount'] = this.discountAmount;
    data['totalAmount'] = this.totalAmount;
    data['notes'] = this.notes;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.session != null) {
      data['session'] = this.session!.toJson();
    }
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.toJson();
    }
    if (this.loyalty != null) {
      data['loyalty'] = this.loyalty!.toJson();
    }
    return data;
  }
}

class Items {
  String? id;
  String? menuItemId;
  String? name;
  int? quantity;
  String? unitPrice;
  String? totalPrice;
  String? status;
  String? batchId;
  MenuItem? menuItem;

  Items({
    this.id,
    this.menuItemId,
    this.name,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.menuItem,
    this.batchId,
    this.status,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    menuItemId = json['menuItemId'];
    name = json['name'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    status = json["status"];
    batchId = json["batchId"];
    menuItem = json['menuItem'] != null
        ? new MenuItem.fromJson(json['menuItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuItemId'] = this.menuItemId;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['totalPrice'] = this.totalPrice;
    data["status"] = this.status;
    if (this.menuItem != null) {
      data['menuItem'] = this.menuItem!.toJson();
    }
    return data;
  }
}

class MenuItem {
  String? id;
  String? name;

  MenuItem({this.id, this.name});

  MenuItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Session {
  String? id;
  String? sessionNumber;
  String? channel;
  String? customerName;
  String? customerPhone;
  MenuItem? table;

  Session({
    this.id,
    this.sessionNumber,
    this.channel,
    this.customerName,
    this.customerPhone,
    this.table,
  });

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionNumber = json['sessionNumber'];
    channel = json['channel'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    table = json['table'] != null ? new MenuItem.fromJson(json['table']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sessionNumber'] = this.sessionNumber;
    data['channel'] = this.channel;
    data['customerName'] = this.customerName;
    data['customerPhone'] = this.customerPhone;
    if (this.table != null) {
      data['table'] = this.table!.toJson();
    }
    return data;
  }
}

class Coupon {
  String? id;
  String? code;
  String? name;
  String? discountType;
  String? appliedDiscount;

  Coupon({
    this.id,
    this.code,
    this.name,
    this.discountType,
    this.appliedDiscount,
  });

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    discountType = json['discountType'];
    appliedDiscount = json['appliedDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['discountType'] = this.discountType;
    data['appliedDiscount'] = this.appliedDiscount;
    return data;
  }
}

class Loyalty {
  String? customerId;
  String? customerName;
  String? totalPoints;

  Loyalty({this.customerId, this.customerName, this.totalPoints});

  Loyalty.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    customerName = json['customerName'];
    totalPoints = json['totalPoints'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['totalPoints'] = this.totalPoints;
    return data;
  }
}
