class BillSummaryModel {
  String? sessionId;
  String? restaurantId;
  String? status;
  String? subtotal;
  String? taxRate;
  String? taxAmount;
  String? grossAmount;
  String? discountAmount;
  String? coupounDiscountAmount;
  String? loyalityPointDiscountAmount;
  String? totalAmount;
  String? notes;

  List<Items>? items;
  Session? session;
  Coupon? coupon;
  Loyalty? loyalty;

  List<ApplicableLoyaltyOffers>? applicableLoyaltyOffers;

  BillSummaryModel({
    this.sessionId,
    this.restaurantId,
    this.status,
    this.subtotal,
    this.taxRate,
    this.taxAmount,
    this.grossAmount,
    this.discountAmount,
    this.coupounDiscountAmount,
    this.loyalityPointDiscountAmount,
    this.totalAmount,
    this.notes,
    this.items,
    this.session,
    this.coupon,
    this.loyalty,
    this.applicableLoyaltyOffers,
  });

  BillSummaryModel.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    restaurantId = json['restaurantId'];
    status = json['status'];
    subtotal = json['subtotal']?.toString();
    taxRate = json['taxRate']?.toString();
    taxAmount = json['taxAmount']?.toString();
    grossAmount = json['grossAmount']?.toString();
    discountAmount = json['discountAmount']?.toString();
    coupounDiscountAmount =
        json['coupounDiscountAmount']?.toString();
    loyalityPointDiscountAmount =
        json['loyalityPointDiscountAmount']?.toString();
    totalAmount = json['totalAmount']?.toString();
    notes = json['notes'];

    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }

    session =
        json['session'] != null
            ? Session.fromJson(json['session'])
            : null;

    coupon =
        json['coupon'] != null
            ? Coupon.fromJson(json['coupon'])
            : null;

    loyalty =
        json['loyalty'] != null
            ? Loyalty.fromJson(json['loyalty'])
            : null;

    if (json['applicableLoyaltyOffers'] != null) {
      applicableLoyaltyOffers = <ApplicableLoyaltyOffers>[];

      json['applicableLoyaltyOffers'].forEach((v) {
        applicableLoyaltyOffers!
            .add(ApplicableLoyaltyOffers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['sessionId'] = sessionId;
    data['restaurantId'] = restaurantId;
    data['status'] = status;
    data['subtotal'] = subtotal;
    data['taxRate'] = taxRate;
    data['taxAmount'] = taxAmount;
    data['grossAmount'] = grossAmount;
    data['discountAmount'] = discountAmount;
    data['coupounDiscountAmount'] =
        coupounDiscountAmount;
    data['loyalityPointDiscountAmount'] =
        loyalityPointDiscountAmount;
    data['totalAmount'] = totalAmount;
    data['notes'] = notes;

    if (items != null) {
      data['items'] =
          items!.map((v) => v.toJson()).toList();
    }

    if (session != null) {
      data['session'] = session!.toJson();
    }

    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }

    if (loyalty != null) {
      data['loyalty'] = loyalty!.toJson();
    }

    if (applicableLoyaltyOffers != null) {
      data['applicableLoyaltyOffers'] =
          applicableLoyaltyOffers!
              .map((v) => v.toJson())
              .toList();
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
class ApplicableLoyaltyOffers {
  String? id;
  String? name;
  String? type;

  int? pointsRequired;
  int? redeemAmount;

  String? validFrom;
  String? validTo;

  List<dynamic>? menuItems;

  bool? customerCanRedeem;

  int? customerWallet;
  int? pointsShortfall;

  ApplicableLoyaltyOffers({
    this.id,
    this.name,
    this.type,
    this.pointsRequired,
    this.redeemAmount,
    this.validFrom,
    this.validTo,
    this.menuItems,
    this.customerCanRedeem,
    this.customerWallet,
    this.pointsShortfall,
  });

  ApplicableLoyaltyOffers.fromJson(
      Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];

    pointsRequired = json['pointsRequired'];
    redeemAmount = json['redeemAmount'];

    validFrom = json['validFrom'];
    validTo = json['validTo'];

    menuItems = json['menuItems'];

    customerCanRedeem =
        json['customerCanRedeem'];

    customerWallet = json['customerWallet'];

    pointsShortfall = json['pointsShortfall'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['pointsRequired'] = pointsRequired;
    data['redeemAmount'] = redeemAmount;
    data['validFrom'] = validFrom;
    data['validTo'] = validTo;
    data['menuItems'] = menuItems;
    data['customerCanRedeem'] =
        customerCanRedeem;
    data['customerWallet'] = customerWallet;
    data['pointsShortfall'] =
        pointsShortfall;

    return data;
  }
}
