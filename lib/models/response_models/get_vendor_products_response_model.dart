class GetVendorProductsResponseModel {
  bool? status;
  String? message;
  List<VendorProductData>? data;

  GetVendorProductsResponseModel({this.status, this.message, this.data});

  GetVendorProductsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VendorProductData>[];
      json['data'].forEach((v) {
        data!.add(VendorProductData.fromJson(v));
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

class VendorProductData {
  String? sId;
  List<String>? productImages;
  String? productName;
  String? categoryId;
  int? quantity;
  int? price;
  int? afterDiscountPrice;
  bool? isDiscountAvailable;
  String? effects;
  String? ingredients;
  String? description;
  String? dosage;
  String? user;
  bool? isDeleted;
  bool? isAvailable;
  String? inventoryStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;

  VendorProductData({
    this.sId,
    this.productImages,
    this.productName,
    this.categoryId,
    this.quantity,
    this.price,
    this.afterDiscountPrice,
    this.isDiscountAvailable,
    this.effects,
    this.ingredients,
    this.description,
    this.dosage,
    this.user,
    this.isDeleted,
    this.isAvailable,
    this.inventoryStatus,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  VendorProductData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productImages = json['productImages'] != null
        ? List<String>.from(json['productImages'])
        : null;
    productName = json['productName'];
    categoryId = json['categoryId'];
    quantity = json['quantity'] != null
        ? (json['quantity'] is int
              ? json['quantity']
              : (json['quantity'] as num).toInt())
        : null;
    price = json['price'] != null
        ? (json['price'] is int
              ? json['price']
              : (json['price'] as num).toInt())
        : null;
    afterDiscountPrice = json['afterDiscountPrice'] != null
        ? (json['afterDiscountPrice'] is int
              ? json['afterDiscountPrice']
              : (json['afterDiscountPrice'] as num).toInt())
        : null;
    isDiscountAvailable = json['isDiscountAvailable'];
    effects = json['effects'];
    ingredients = json['ingredients'];
    description = json['description'];
    dosage = json['dosage'];
    user = json['user'];
    isDeleted = json['isDeleted'];
    isAvailable = json['isAvailable'];
    inventoryStatus = json['inventoryStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'] != null
        ? (json['__v'] is int ? json['__v'] : (json['__v'] as num).toInt())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['productImages'] = productImages;
    data['productName'] = productName;
    data['categoryId'] = categoryId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['afterDiscountPrice'] = afterDiscountPrice;
    data['isDiscountAvailable'] = isDiscountAvailable;
    data['effects'] = effects;
    data['ingredients'] = ingredients;
    data['description'] = description;
    data['dosage'] = dosage;
    data['user'] = user;
    data['isDeleted'] = isDeleted;
    data['isAvailable'] = isAvailable;
    data['inventoryStatus'] = inventoryStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
