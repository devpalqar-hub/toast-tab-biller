class SessionModel {
  String? id;
  String? restaurantId;
  String? tableId;
  String? sessionNumber;
  String? channel;
  String? status;
  String? customerName;
  String? customerPhone;
  String? customerEmail;
  int? guestCount;
  String? totalAmount;
  String? openedById;
  String? createdAt;
  String? updatedAt;
  Table? table;
  OpenedBy? openedBy;
  Count? cCount;

  SessionModel({
    this.id,
    this.restaurantId,
    this.tableId,
    this.sessionNumber,
    this.channel,
    this.status,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.guestCount,
    this.totalAmount,
    this.openedById,
    this.createdAt,
    this.updatedAt,
    this.table,
    this.openedBy,
    this.cCount,
  });

  SessionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurantId'];
    tableId = json['tableId'];
    sessionNumber = json['sessionNumber'];
    channel = json['channel'];
    status = json['status'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    customerEmail = json['customerEmail'];
    guestCount = json['guestCount'];
    totalAmount = json['totalAmount'];
    openedById = json['openedById'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    table = json['table'] != null ? new Table.fromJson(json['table']) : null;
    openedBy = json['openedBy'] != null
        ? new OpenedBy.fromJson(json['openedBy'])
        : null;
    cCount = json['_count'] != null ? new Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantId'] = this.restaurantId;
    data['tableId'] = this.tableId;
    data['sessionNumber'] = this.sessionNumber;
    data['channel'] = this.channel;
    data['status'] = this.status;
    data['customerName'] = this.customerName;
    data['customerPhone'] = this.customerPhone;
    data['customerEmail'] = this.customerEmail;
    data['guestCount'] = this.guestCount;
    data['totalAmount'] = this.totalAmount;
    data['openedById'] = this.openedById;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.table != null) {
      data['table'] = this.table!.toJson();
    }
    if (this.openedBy != null) {
      data['openedBy'] = this.openedBy!.toJson();
    }
    if (this.cCount != null) {
      data['_count'] = this.cCount!.toJson();
    }
    return data;
  }
}

class Table {
  String? id;
  String? name;
  int? seatCount;
  String? status;

  Table({this.id, this.name, this.seatCount, this.status});

  Table.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    seatCount = json['seatCount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['seatCount'] = this.seatCount;
    data['status'] = this.status;
    return data;
  }
}

class OpenedBy {
  String? id;
  String? name;
  String? role;

  OpenedBy({this.id, this.name, this.role});

  OpenedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    return data;
  }
}

class Count {
  int? batches;

  Count({this.batches});

  Count.fromJson(Map<String, dynamic> json) {
    batches = json['batches'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batches'] = this.batches;
    return data;
  }
}
