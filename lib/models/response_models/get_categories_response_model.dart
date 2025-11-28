class GetCategoriesResponseModel {
  bool? status;
  String? message;
  List<CategoryData>? data;

  GetCategoriesResponseModel({this.status, this.message, this.data});

  GetCategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
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

class CategoryData {
  String? sId;
  String? categoryName;
  String? categoryImage;
  String? description;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CategoryData({
    this.sId,
    this.categoryName,
    this.categoryImage,
    this.description,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
    categoryImage = json['categoryImage'];
    description = json['description'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['categoryName'] = categoryName;
    data['categoryImage'] = categoryImage;
    data['description'] = description;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
