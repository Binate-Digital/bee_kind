// class SingleProductResponseModel {
//   bool? status;
//   String? message;
//   ProductData? data;
//
//   SingleProductResponseModel({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory SingleProductResponseModel.fromJson(Map<String, dynamic> json) {
//     return SingleProductResponseModel(
//       status: json["status"],
//       message: json["message"],
//       data: json["data"] != null ? ProductData.fromJson(json["data"]) : null,
//     );
//   }
// }
//
// class ProductData {
//   String? sId;
//   String? productName;
//   String? categoryId;
//   int? quantity;
//   double? price;
//   dynamic? afterDiscountPrice;
//   bool? isDiscountAvailable;
//   String? effects;
//   String? ingredients;
//   String? description;
//   String? dosage;
//   bool? isDeleted;
//   bool? isAvailable;
//   String? inventoryStatus;
//   List<String>? productImages;
//   RatingDetail? ratingDetail;
//   List<Review>? reviews;
//
//   ProductData({
//     this.sId,
//     this.productName,
//     this.categoryId,
//     this.quantity,
//     this.price,
//     this.afterDiscountPrice,
//     this.isDiscountAvailable,
//     this.effects,
//     this.ingredients,
//     this.description,
//     this.dosage,
//     this.isDeleted,
//     this.isAvailable,
//     this.inventoryStatus,
//     this.productImages,
//     this.ratingDetail,
//     this.reviews,
//   });
//
//   factory ProductData.fromJson(Map<String, dynamic> json) {
//     // Check if the 'reviews' field is an object with averageRating, totalReviews, and an array of reviews
//     var reviewsData = json["reviews"];
//     List<Review> reviews = [];
//
//     // If 'reviews' is an object, parse the nested reviews field and RatingDetail
//     if (reviewsData is Map<String, dynamic>) {
//       // Parse the RatingDetail
//       RatingDetail? ratingDetail;
//       if (reviewsData["averageRating"] != null || reviewsData["totalReviews"] != null) {
//         ratingDetail = RatingDetail.fromJson(reviewsData);
//       }
//       // If 'reviews' array exists, parse it into a list of Review objects
//       if (reviewsData["reviews"] != null) {
//         reviews = List<Review>.from(reviewsData["reviews"].map((x) => Review.fromJson(x)));
//       }
//
//       // Create ProductData with parsed reviews
//       return ProductData(
//         sId: json["_id"],
//         productName: json["productName"],
//         categoryId: json["categoryId"],
//         quantity: json["quantity"],
//         price: json["price"]?.toDouble(),
//         afterDiscountPrice: json["afterDiscountPrice"]?.toDouble(),
//         isDiscountAvailable: json["isDiscountAvailable"],
//         effects: json["effects"],
//         ingredients: json["ingredients"],
//         description: json["description"],
//         dosage: json["dosage"],
//         isDeleted: json["isDeleted"],
//         isAvailable: json["isAvailable"],
//         inventoryStatus: json["inventoryStatus"],
//         productImages: List<String>.from(json["productImages"] ?? []),
//         ratingDetail: ratingDetail,
//         reviews: reviews,
//       );
//     } else if (reviewsData is List) {
//       // If 'reviews' is a direct list, map it to Review objects
//       return ProductData(
//         sId: json["_id"],
//         productName: json["productName"],
//         categoryId: json["categoryId"],
//         quantity: json["quantity"],
//         price: json["price"]?.toDouble(),
//         afterDiscountPrice: json["afterDiscountPrice"]?.toDouble(),
//         isDiscountAvailable: json["isDiscountAvailable"],
//         effects: json["effects"],
//         ingredients: json["ingredients"],
//         description: json["description"],
//         dosage: json["dosage"],
//         isDeleted: json["isDeleted"],
//         isAvailable: json["isAvailable"],
//         inventoryStatus: json["inventoryStatus"],
//         productImages: List<String>.from(json["productImages"] ?? []),
//         ratingDetail: json["ratingDetail"] != null
//             ? RatingDetail.fromJson(json["ratingDetail"])
//             : null,
//         reviews: List<Review>.from(reviewsData.map((x) => Review.fromJson(x))),
//       );
//     } else {
//       // Default case where reviews field is missing or not matching expected structure
//       return ProductData(
//         sId: json["_id"],
//         productName: json["productName"],
//         categoryId: json["categoryId"],
//         quantity: json["quantity"],
//         price: json["price"]?.toDouble(),
//         afterDiscountPrice: json["afterDiscountPrice"]?.toDouble(),
//         isDiscountAvailable: json["isDiscountAvailable"],
//         effects: json["effects"],
//         ingredients: json["ingredients"],
//         description: json["description"],
//         dosage: json["dosage"],
//         isDeleted: json["isDeleted"],
//         isAvailable: json["isAvailable"],
//         inventoryStatus: json["inventoryStatus"],
//         productImages: List<String>.from(json["productImages"] ?? []),
//         ratingDetail: json["ratingDetail"] != null
//             ? RatingDetail.fromJson(json["ratingDetail"])
//             : null,
//         reviews: [],
//       );
//     }
//   }
// }
//
// class RatingDetail {
//   double? averageRating;
//   int? totalReviews;
//
//   RatingDetail({this.averageRating, this.totalReviews});
//
//   factory RatingDetail.fromJson(Map<String, dynamic> json) {
//     return RatingDetail(
//       averageRating: json["averageRating"]?.toDouble(),
//       totalReviews: json["totalReviews"],
//     );
//   }
// }
//
// class Review {
//   String? id;
//   String? orderId;
//   String? productId;
//   User? user;
//   int? rating;
//   String? review;
//   String? reply;
//   String? repliedBy;
//   bool? isDeleted;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   Review({
//     this.id,
//     this.orderId,
//     this.productId,
//     this.user,
//     this.rating,
//     this.review,
//     this.reply,
//     this.repliedBy,
//     this.isDeleted,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Review.fromJson(Map<String, dynamic> json) {
//     return Review(
//       id: json["_id"],
//       orderId: json["orderId"],
//       productId: json["productId"],
//       user: json["user"] != null ? User.fromJson(json["user"]) : null,
//       rating: json["rating"],
//       review: json["review"],
//       reply: json["reply"],
//       repliedBy: json["repliedBy"],
//       isDeleted: json["isDeleted"],
//       createdAt: json["createdAt"] != null
//           ? DateTime.parse(json["createdAt"])
//           : null,
//       updatedAt: json["updatedAt"] != null
//           ? DateTime.parse(json["updatedAt"])
//           : null,
//     );
//   }
// }
//
// class User {
//   String? id;
//   String? profilePicture;
//   String? firstName;
//   String? lastName;
//
//   User({
//     this.id,
//     this.profilePicture,
//     this.firstName,
//     this.lastName,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json["_id"],
//       profilePicture: json["profilePicture"],
//       firstName: json["firstName"],
//       lastName: json["lastName"],
//     );
//   }
// }



class SingleProductResponseModel {
  bool? status;
  String? message;
  ProductData? data;

  SingleProductResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory SingleProductResponseModel.fromJson(Map<String, dynamic> json) {
    return SingleProductResponseModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] != null ? ProductData.fromJson(json["data"]) : null,
    );
  }
}

class ProductData {
  String? sId;
  String? productName;
  String? categoryId;
  int? quantity;
  double? price;
  double? afterDiscountPrice;
  bool? isDiscountAvailable;
  String? effects;
  String? ingredients;
  String? description;
  String? dosage;
  String? user;
  bool? isDeleted;
  bool? isAvailable;
  String? inventoryStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<String>? productImages;
  RatingDetail? ratingDetail;
  List<Review>? reviews;

  ProductData({
    this.sId,
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
    this.v,
    this.productImages,
    this.ratingDetail,
    this.reviews,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    final reviewsData = json["reviews"];

    return ProductData(
      sId: json["_id"],
      productName: json["productName"],
      categoryId: json["categoryId"],
      quantity: json["quantity"],
      price: (json["price"] as num?)?.toDouble(),
      afterDiscountPrice: (json["afterDiscountPrice"] as num?)?.toDouble(),
      isDiscountAvailable: json["isDiscountAvailable"],
      effects: json["effects"],
      ingredients: json["ingredients"],
      description: json["description"],
      dosage: json["dosage"],
      user: json["user"],
      isDeleted: json["isDeleted"],
      isAvailable: json["isAvailable"],
      inventoryStatus: json["inventoryStatus"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"])
          : null,
      v: json["__v"],
      productImages: json["productImages"] != null
          ? List<String>.from(json["productImages"])
          : [],
      ratingDetail: json["ratingDetail"] != null
          ? RatingDetail.fromJson(json["ratingDetail"])
          : null,
      reviews: reviewsData != null && reviewsData is List
          ? List<Review>.from(reviewsData.map((x) => Review.fromJson(x)))
          : [],
    );
  }
}

class RatingDetail {
  double? averageRating;
  int? totalReviews;

  RatingDetail({this.averageRating, this.totalReviews});

  factory RatingDetail.fromJson(Map<String, dynamic> json) {
    return RatingDetail(
      averageRating: (json["averageRating"] as num?)?.toDouble(),
      totalReviews: json["totalReviews"],
    );
  }
}

class Review {
  String? id;
  String? orderId;
  String? productId;
  User? user;
  int? rating;
  String? review;
  List<String>? reply;
  List<String>? repliedBy;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Review({
    this.id,
    this.orderId,
    this.productId,
    this.user,
    this.rating,
    this.review,
    this.reply,
    this.repliedBy,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["_id"],
      orderId: json["orderId"],
      productId: json["productId"],

      /// api sends user object in userId
      user: json["userId"] != null ? User.fromJson(json["userId"]) : null,

      rating: json["rating"],
      review: json["review"],
      reply: _parseStringList(json["reply"]),
      repliedBy: _parseStringList(json["repliedBy"]),
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"])
          : null,
      v: json["__v"],
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
    }

    if (value is String) {
      return value.trim().isEmpty ? [] : [value];
    }

    return [];
  }
}

class User {
  String? id;
  String? profilePicture;
  String? firstName;
  String? lastName;

  User({
    this.id,
    this.profilePicture,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      profilePicture: json["profilePicture"],
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    return '$first $last'.trim();
  }
}