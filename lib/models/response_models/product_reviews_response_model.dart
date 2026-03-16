class ProductReviewsResponseModel {
  bool? status;
  String? message;
  ProductReviews? data;

  ProductReviewsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  ProductReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProductReviews.fromJson(json['data']) : null;
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

class ProductReviews {
  String? sId;
  double? averageRating;
  int? totalReviews;
  List<Reviews>? reviews;

  ProductReviews({
    this.sId,
    this.averageRating,
    this.totalReviews,
    this.reviews,
  });

  ProductReviews.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    averageRating = (json['averageRating'] as num?)?.toDouble();
    totalReviews = json['totalReviews'] is int
        ? json['totalReviews']
        : int.tryParse(json['totalReviews']?.toString() ?? '');

    if (json['reviews'] != null && json['reviews'] is List) {
      reviews = (json['reviews'] as List)
          .map((v) => Reviews.fromJson(v))
          .toList();
    } else {
      reviews = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
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
  List<String>? reply;
  List<String>? repliedBy;
  String? createdAt;
  UserModel? user;

  Reviews({
    this.sId,
    this.orderId,
    this.userId,
    this.rating,
    this.review,
    this.reply,
    this.repliedBy,
    this.createdAt,
    this.user,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    orderId = json['orderId']?.toString();
    userId = json['userId']?.toString();
    rating = json['rating'] is int
        ? json['rating']
        : int.tryParse(json['rating']?.toString() ?? '');
    review = json['review']?.toString();
    reply = _parseStringList(json['reply']);
    repliedBy = _parseStringList(json['repliedBy']);
    createdAt = json['createdAt']?.toString();
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is String) {
      return value.trim().isEmpty ? [] : [value];
    }

    if (value is List) {
      return value
          .where((e) => e != null)
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['orderId'] = orderId;
    data['userId'] = userId;
    data['rating'] = rating;
    data['review'] = review;
    data['reply'] = reply ?? [];
    data['repliedBy'] = repliedBy ?? [];
    data['createdAt'] = createdAt;

    if (user != null) {
      data['user'] = user!.toJson();
    }

    return data;
  }
}

class UserModel {
  String? fullName;
  String? profileImage;

  UserModel({
    this.fullName,
    this.profileImage,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['name']?.toString() ??
        json['fullName']?.toString() ??
        json['userName']?.toString() ??
        json['username']?.toString() ??
        _buildFullName(json['firstName'], json['lastName']);

    profileImage = json['profilePicture']?.toString() ??
        json['profileImage']?.toString() ??
        json['avatar']?.toString() ??
        json['image']?.toString();
  }

  static String? _buildFullName(dynamic firstName, dynamic lastName) {
    if (firstName == null && lastName == null) return null;

    final first = firstName?.toString() ?? '';
    final last = lastName?.toString() ?? '';
    final combined = '$first $last'.trim();

    return combined.isEmpty ? null : combined;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": fullName,
      "profilePicture": profileImage,
    };
  }
}