class MenuModel {
  String? id;
  String? restaurantId;
  String? categoryId;
  String? name;
  String? description;
  String? price;
  String? discountedPrice;
  String? imageUrl;
  String? itemType;
  int? stockCount;
  bool? isAvailable;
  bool? isOutOfStock;
  String? outOfStockAt;
  bool? isActive;
  int? sortOrder;
  Category? category;
  String? effectivePrice;

  MenuModel({
    this.id,
    this.restaurantId,
    this.categoryId,
    this.name,
    this.description,
    this.price,
    this.discountedPrice,
    this.imageUrl,
    this.itemType,
    this.stockCount,
    this.isAvailable,
    this.isOutOfStock,
    this.outOfStockAt,
    this.isActive,
    this.sortOrder,
    this.category,
    this.effectivePrice,
  });

  MenuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurantId'];
    categoryId = json['categoryId'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    discountedPrice = json['discountedPrice'];
    imageUrl = json['imageUrl'];
    itemType = json['itemType'];
    stockCount = json['stockCount'];
    isAvailable = json['isAvailable'];
    isOutOfStock = json['isOutOfStock'];
    outOfStockAt = json['outOfStockAt'];
    isActive = json['isActive'];
    sortOrder = json['sortOrder'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    effectivePrice = json['effectivePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantId'] = this.restaurantId;
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discountedPrice'] = this.discountedPrice;
    data['imageUrl'] = this.imageUrl;
    data['itemType'] = this.itemType;
    data['stockCount'] = this.stockCount;
    data['isAvailable'] = this.isAvailable;
    data['isOutOfStock'] = this.isOutOfStock;
    data['outOfStockAt'] = this.outOfStockAt;
    data['isActive'] = this.isActive;
    data['sortOrder'] = this.sortOrder;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['effectivePrice'] = this.effectivePrice;
    return data;
  }
}

class Category {
  String? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
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
