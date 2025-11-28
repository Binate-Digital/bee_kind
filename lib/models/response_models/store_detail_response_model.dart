import 'dart:developer';

class StoreDetailResponseModel {
  bool? status;
  String? message;
  StoreDetail? data;

  StoreDetailResponseModel({this.status, this.message, this.data});

  StoreDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? StoreDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class StoreDetail {
  Store? store;
  List<Categories>? categories;
  List<Products>? products;
  List<PopularProducts>? popularProducts;

  StoreDetail({
    this.store,
    this.categories,
    this.products,
    this.popularProducts,
  });

  StoreDetail.fromJson(Map<String, dynamic> json) {
    store = json['store'] != null ? Store.fromJson(json['store']) : null;

    categories = json['categories'] != null
        ? List<Categories>.from(
            json['categories'].map((v) => Categories.fromJson(v)),
          )
        : [];

    products = json['products'] != null
        ? List<Products>.from(json['products'].map((v) => Products.fromJson(v)))
        : [];

    popularProducts = json['popularProducts'] != null
        ? List<PopularProducts>.from(
            json['popularProducts'].map((v) => PopularProducts.fromJson(v)),
          )
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (popularProducts != null) {
      data['popularProducts'] = popularProducts!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class Store {
  VendorAddress? vendorAddress;
  String? authProvideP;
  dynamic firebaseUid;
  dynamic transferId;
  dynamic refundId;
  bool? isRefund;
  bool? verificationProcessStarted;
  String? sId;
  String? email;
  String? password;
  bool? isProfileCompleted;
  bool? isVerified;
  String? role;
  dynamic firstName;
  dynamic lastName;
  dynamic phoneNumber;
  String? gender;
  dynamic dateOfBirth;
  bool? ageVerified;
  String? businessName;
  String? openTime;
  String? closeTime;
  List<String>? offDays;
  dynamic deliveryRadius;
  List<String>? documents;
  String? otp;
  bool? isDeleted;
  bool? isNotificationEnabled;
  String? socialType;
  String? deviceType;
  String? stripeAccountId;
  dynamic addressName;
  dynamic defaultPaymentMethod;
  String? stripeCustomerId;
  bool? hideProfile;
  String? veriffStatus;
  dynamic veriffSessionId;
  dynamic verifiedAge;
  List<dynamic>? userAddress;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? businessDescription;
  String? profilePicture;

  Store.fromJson(Map<String, dynamic> json) {
    vendorAddress = json['vendorAddress'] != null
        ? VendorAddress.fromJson(json['vendorAddress'])
        : null;

    authProvideP = json['authProvideP'];
    firebaseUid = json['firebaseUid'];
    transferId = json['transferId'];
    refundId = json['refundId'];
    isRefund = json['isRefund'];
    verificationProcessStarted = json['verificationProcessStarted'];
    sId = json['_id'];
    email = json['email'];
    password = json['password'];
    isProfileCompleted = json['isProfileCompleted'];
    isVerified = json['isVerified'];
    role = json['role'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    ageVerified = json['ageVerified'];
    businessName = json['businessName'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];

    // backend sends weird string list
    offDays = json['offDays'] != null ? List<String>.from(json['offDays']) : [];

    deliveryRadius = json['deliveryRadius'];
    documents = json['documents'] != null
        ? List<String>.from(json['documents'])
        : [];

    otp = json['otp'];
    isDeleted = json['isDeleted'];
    isNotificationEnabled = json['isNotificationEnabled'];
    socialType = json['socialType'];
    deviceType = json['deviceType'];
    stripeAccountId = json['stripeAccountId'];
    addressName = json['addressName'];
    defaultPaymentMethod = json['defaultPaymentMethod'];
    stripeCustomerId = json['stripeCustomerId'];
    hideProfile = json['hideProfile'];
    veriffStatus = json['veriffStatus'];
    veriffSessionId = json['veriffSessionId'];
    verifiedAge = json['verifiedAge'];

    userAddress = json['userAddress'] != null
        ? List<dynamic>.from(json['userAddress'])
        : [];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    businessDescription = json['businessDescription'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    return {
      if (vendorAddress != null) 'vendorAddress': vendorAddress!.toJson(),
      'authProvideP': authProvideP,
      'firebaseUid': firebaseUid,
      'transferId': transferId,
      'refundId': refundId,
      'isRefund': isRefund,
      'verificationProcessStarted': verificationProcessStarted,
      '_id': sId,
      'email': email,
      'password': password,
      'isProfileCompleted': isProfileCompleted,
      'isVerified': isVerified,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'ageVerified': ageVerified,
      'businessName': businessName,
      'openTime': openTime,
      'closeTime': closeTime,
      'offDays': offDays,
      'deliveryRadius': deliveryRadius,
      'documents': documents,
      'otp': otp,
      'isDeleted': isDeleted,
      'isNotificationEnabled': isNotificationEnabled,
      'socialType': socialType,
      'deviceType': deviceType,
      'stripeAccountId': stripeAccountId,
      'addressName': addressName,
      'defaultPaymentMethod': defaultPaymentMethod,
      'stripeCustomerId': stripeCustomerId,
      'hideProfile': hideProfile,
      'veriffStatus': veriffStatus,
      'veriffSessionId': veriffSessionId,
      'verifiedAge': verifiedAge,
      'userAddress': userAddress,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'businessDescription': businessDescription,
      'profilePicture': profilePicture,
    };
  }
}

class VendorAddress {
  String? type;
  List<dynamic>? coordinates;
  String? address;

  VendorAddress({this.type, this.coordinates, this.address});

  VendorAddress.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<dynamic>.from(json['coordinates'])
        : [];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates, 'address': address};
  }
}

class Categories {
  String? sId;
  String? categoryName;
  String? categoryImage;
  String? description;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Categories.fromJson(Map<String, dynamic> json) {
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
    return {
      '_id': sId,
      'categoryName': categoryName,
      'categoryImage': categoryImage,
      'description': description,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }
}

class Products {
  String? sId;
  List<String>? productImages;
  String? productName;
  Categories? categoryId;
  int? quantity;
  int? price;
  int? afterDiscountPrice;
  bool? isDiscountAvailable;
  String? effects;
  String? ingredients;
  String? description;
  String? user;
  bool? isDeleted;
  bool? isAvailable;
  String? inventoryStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productImages = json['productImages'] != null
        ? List<String>.from(json['productImages'])
        : [];

    productName = json['productName'];
    categoryId = json['categoryId'] != null
        ? Categories.fromJson(json['categoryId'])
        : null;

    quantity = json['quantity'];
    price = json['price'];
    log("Parsed Prices (Products): $price");
    afterDiscountPrice = json['afterDiscountPrice'];
    isDiscountAvailable = json['isDiscountAvailable'];
    effects = json['effects'];
    ingredients = json['ingredients'];
    description = json['description'];
    user = json['user'];
    isDeleted = json['isDeleted'];
    isAvailable = json['isAvailable'];
    inventoryStatus = json['inventoryStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['productImages'] = productImages;
    data['productName'] = productName;
    if (categoryId != null) {
      data['categoryId'] = categoryId!.toJson();
    }
    data['quantity'] = quantity;
    data['price'] = price;
    data['afterDiscountPrice'] = afterDiscountPrice;
    data['isDiscountAvailable'] = isDiscountAvailable;
    data['effects'] = effects;
    data['ingredients'] = ingredients;
    data['description'] = description;
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

class PopularProducts {
  bool? isDiscountAvailable;
  String? sId;
  List<String>? productImages;
  String? productName;
  Categories? categoryId;
  int? quantity;
  int? price;
  int? afterDiscountPrice;
  String? effects;
  String? ingredients;
  String? description;
  String? user;
  int? iV;
  bool? isDeleted;
  String? updatedAt;
  bool? isAvailable;
  String? inventoryStatus;
  int? salesCount;
  String? createdAt;

  PopularProducts.fromJson(Map<String, dynamic> json) {
    isDiscountAvailable = json['isDiscountAvailable'];
    sId = json['_id'];
    productImages = json['productImages'] != null
        ? List<String>.from(json['productImages'])
        : [];

    productName = json['productName'];
    categoryId = json['categoryId'] != null
        ? Categories.fromJson(json['categoryId'])
        : null;

    quantity = json['quantity'];
    price = json['price'];
    log("Parsed Prices (PopularProducts): $price");
    afterDiscountPrice = json['afterDiscountPrice'];
    effects = json['effects'];
    ingredients = json['ingredients'];
    description = json['description'];
    user = json['user'];
    iV = json['__v'];
    isDeleted = json['isDeleted'];
    updatedAt = json['updatedAt'];
    isAvailable = json['isAvailable'];
    inventoryStatus = json['inventoryStatus'];
    salesCount = json['salesCount'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDiscountAvailable'] = isDiscountAvailable;
    data['_id'] = sId;
    data['productImages'] = productImages;
    data['productName'] = productName;
    if (categoryId != null) {
      data['categoryId'] = categoryId!.toJson();
    }
    data['quantity'] = quantity;
    data['price'] = price;
    data['afterDiscountPrice'] = afterDiscountPrice;
    data['effects'] = effects;
    data['ingredients'] = ingredients;
    data['description'] = description;
    data['user'] = user;
    data['__v'] = iV;
    data['isDeleted'] = isDeleted;
    data['updatedAt'] = updatedAt;
    data['isAvailable'] = isAvailable;
    data['inventoryStatus'] = inventoryStatus;
    data['salesCount'] = salesCount;
    data['createdAt'] = createdAt;
    return data;
  }
}
