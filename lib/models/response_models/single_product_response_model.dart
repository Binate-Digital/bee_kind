class SingleProductResponseModel {
  bool? status;
  String? message;
  ProductDetail? data;

  SingleProductResponseModel({this.status, this.message, this.data});

  SingleProductResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProductDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductDetail {
  bool? isDiscountAvailable;
  String? sId;
  List<String>? productImages;
  String? productName;
  String? categoryId;
  int? quantity;
  int? price;
  int? afterDiscountPrice;
  String? effects;
  String? ingredients;
  String? dosage;
  String? description;
  String? user;
  int? iV;
  bool? isDeleted;
  String? updatedAt;
  bool? isAvailable;
  String? inventoryStatus;
  ProductReviews? reviews;

  ProductDetail({
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
    this.updatedAt,
    this.isAvailable,
    this.inventoryStatus,
    this.reviews,
  });

  ProductDetail.fromJson(Map<String, dynamic> json) {
    isDiscountAvailable = json['isDiscountAvailable'];
    sId = json['_id'];
    productImages = json['productImages'] != null
        ? List<String>.from(json['productImages'])
        : [];
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
    effects = json['effects'];
    ingredients = json['ingredients'];
    dosage = json['dosage'];
    description = json['description'];
    user = json['user'];
    iV = json['__v'] != null
        ? (json['__v'] is int ? json['__v'] : (json['__v'] as num).toInt())
        : null;
    isDeleted = json['isDeleted'];
    updatedAt = json['updatedAt'];
    isAvailable = json['isAvailable'];
    inventoryStatus = json['inventoryStatus'];
    reviews = json['reviews'] != null
        ? ProductReviews.fromJson(json['reviews'])
        : null;
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
    data['dosage'] = dosage;
    data['description'] = description;
    data['user'] = user;
    data['__v'] = iV;
    data['isDeleted'] = isDeleted;
    data['updatedAt'] = updatedAt;
    data['isAvailable'] = isAvailable;
    data['inventoryStatus'] = inventoryStatus;
    if (reviews != null) {
      data['reviews'] = reviews!.toJson();
    }
    return data;
  }
}

class ProductReviews {
  int? averageRating;
  int? totalReviews;
  List<ProductReviews>? reviews;

  ProductReviews({this.averageRating, this.totalReviews, this.reviews});

  ProductReviews.fromJson(Map<String, dynamic> json) {
    averageRating = json['averageRating'];
    totalReviews = json['totalReviews'];
    if (json['reviews'] != null) {
      reviews = <ProductReviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(ProductReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['averageRating'] = averageRating;
    data['totalReviews'] = totalReviews;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  String? sId;
  String? orderId;
  String? userId;
  int? rating;
  String? review;
  String? reply;
  String? repliedBy;
  String? createdAt;

  Reviews({
    this.sId,
    this.orderId,
    this.userId,
    this.rating,
    this.review,
    this.reply,
    this.repliedBy,
    this.createdAt,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderId = json['orderId'];
    userId = json['userId'];
    rating = json['rating'];
    review = json['review'];
    reply = json['reply'];
    repliedBy = json['repliedBy'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['orderId'] = orderId;
    data['userId'] = userId;
    data['rating'] = rating;
    data['review'] = review;
    data['reply'] = reply;
    data['repliedBy'] = repliedBy;
    data['createdAt'] = createdAt;
    return data;
  }
}
