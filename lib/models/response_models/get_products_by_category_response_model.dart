class GetProductsByCategoriesResponseModel {
  bool? status;
  String? message;
  List<ProductByCategoryData>? data;

  GetProductsByCategoriesResponseModel({this.status, this.message, this.data});

  GetProductsByCategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductByCategoryData>[];
      json['data'].forEach((v) {
        data!.add(ProductByCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductByCategoryData {
  bool? isDiscountAvailable;
  String? sId;
  List<String>? productImages;
  String? productName;
  String? categoryId;
  dynamic quantity;
  dynamic price;
  dynamic afterDiscountPrice;
  String? effects;
  String? ingredients;
  String? description;
  String? user;
  dynamic iV;
  bool? isDeleted;
  String? businessName;
  String? businessId;
  dynamic deliveryRadius;
  String? updatedAt;
  bool? isAvailable;
  String? inventoryStatus;
  String? createdAt;

  ProductByCategoryData({
    this.isDiscountAvailable,
    this.sId,
    this.productImages,
    this.productName,
    this.categoryId,
    this.quantity,
    this.price,
    this.afterDiscountPrice,
    this.effects,
    this.ingredients,
    this.description,
    this.user,
    this.iV,
    this.isDeleted,
    this.businessName,
    this.businessId,
    this.deliveryRadius,
    this.updatedAt,
    this.isAvailable,
    this.inventoryStatus,
    this.createdAt,
  });

  ProductByCategoryData.fromJson(Map<String, dynamic> json) {
    isDiscountAvailable = json['isDiscountAvailable'];
    sId = json['_id'];
    productImages = json['productImages'].cast<String>();
    productName = json['productName'];
    categoryId = json['categoryId'];
    quantity = json['quantity'];
    price = json['price'];
    afterDiscountPrice = json['afterDiscountPrice'];
    effects = json['effects'];
    ingredients = json['ingredients'];
    description = json['description'];
    user = json['user'];
    iV = json['__v'];
    isDeleted = json['isDeleted'];
    businessName = json["businessName"];
    businessId = json["businessId"];
    deliveryRadius = json["deliveryRadius"];
    updatedAt = json['updatedAt'];
    isAvailable = json['isAvailable'];
    inventoryStatus = json['inventoryStatus'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDiscountAvailable'] = isDiscountAvailable;
    data['_id'] = sId;
    data['productImages'] = productImages;
    data['productName'] = productName;
    data['categoryId'] = categoryId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['afterDiscountPrice'] = afterDiscountPrice;
    data['effects'] = effects;
    data['ingredients'] = ingredients;
    data['description'] = description;
    data['user'] = user;
    data['__v'] = iV;
    data['isDeleted'] = isDeleted;
    data["businessName"] = businessName;
    data["businessId"] = businessId;
    data["deliveryRadius"] = deliveryRadius;
    data['updatedAt'] = updatedAt;
    data['isAvailable'] = isAvailable;
    data['inventoryStatus'] = inventoryStatus;
    data['createdAt'] = createdAt;
    return data;
  }
}
