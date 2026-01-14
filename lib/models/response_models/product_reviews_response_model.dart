class ProductReviewsResponseModel {
  bool? status;
  String? message;
  ProductReviews? data;

  ProductReviewsResponseModel({this.status, this.message, this.data});

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
  dynamic averageRating;
  dynamic totalReviews;
  List<Reviews>? reviews;

  ProductReviews({
    this.sId,
    this.averageRating,
    this.totalReviews,
    this.reviews,
  });

  ProductReviews.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    averageRating = json['averageRating'];
    totalReviews = json['totalReviews'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
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
  String? reply;
  String? repliedBy;
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
    sId = json['_id'];
    orderId = json['orderId'];
    userId = json['userId'];
    rating = json['rating'];
    review = json['review'];
    reply = json['reply'];
    repliedBy = json['repliedBy'];
    createdAt = json['createdAt'];

    /// ⭐ Parse user object
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
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

    /// ⭐ Add user to JSON
    if (user != null) {
      data['user'] = user!.toJson();
    }

    return data;
  }
}

class UserModel {
  String? fullName;
  String? profileImage;

  UserModel({this.fullName, this.profileImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    // Handle different possible field names for user name
    fullName = json['name'] ?? 
               json['fullName'] ?? 
               json['userName'] ?? 
               json['username'] ??
               _buildFullName(json['firstName'], json['lastName']);

    // Handle different possible field names for profile image
    profileImage = json['profilePicture'] ?? 
                   json['profileImage'] ?? 
                   json['avatar'] ??
                   json['image'];
  }

  // Helper to combine firstName and lastName
  String? _buildFullName(dynamic firstName, dynamic lastName) {
    if (firstName == null && lastName == null) return null;
    final first = firstName?.toString() ?? '';
    final last = lastName?.toString() ?? '';
    final combined = '$first $last'.trim();
    return combined.isEmpty ? null : combined;
  }

  Map<String, dynamic> toJson() {
    return {"name": fullName, "profilePicture": profileImage};
  }
}
