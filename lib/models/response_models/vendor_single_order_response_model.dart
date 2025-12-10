class VendorSingleOrderResponseModel {
  bool? status;
  String? message;
  VendorOrderData? data;

  VendorSingleOrderResponseModel({this.status, this.message, this.data});

  VendorSingleOrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? VendorOrderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data?.toJson();
    return data;
  }
}

/// Wrapping object for { order, user }
class VendorOrderData {
  VendorOrder? order;
  VendorUser? user;

  VendorOrderData({this.order, this.user});

  VendorOrderData.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? VendorOrder.fromJson(json['order']) : null;
    user = json['user'] != null ? VendorUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "order": order?.toJson(),
      "user": user?.toJson(),
    };
  }
}

class VendorOrder {
  VendorUserAddress? userAddress;

  String? id;
  String? userId;
  String? storeId;

  List<OrderItemData>? items;

  double? totalAmount;
  double? deliverCharges;
  String? status;
  bool? isDeleted;
  String? additionalNotes;

  double? storeRevenue;
  double? platformRevenue;

  List<dynamic>? statusHistory;

  String? createdAt;
  String? updatedAt;

  VendorOrder({
    this.userAddress,
    this.id,
    this.userId,
    this.storeId,
    this.items,
    this.totalAmount,
    this.deliverCharges,
    this.status,
    this.isDeleted,
    this.additionalNotes,
    this.storeRevenue,
    this.platformRevenue,
    this.statusHistory,
    this.createdAt,
    this.updatedAt,
  });

  VendorOrder.fromJson(Map<String, dynamic> json) {
    userAddress = json["userAddress"] != null
        ? VendorUserAddress.fromJson(json["userAddress"])
        : null;

    id = json["_id"];
    userId = json["userId"];
    storeId = json["storeId"];

    if (json["items"] != null) {
      items = [];
      json["items"].forEach((v) => items!.add(OrderItemData.fromJson(v)));
    }

    totalAmount = _toDouble(json["totalAmount"]);
    deliverCharges = _toDouble(json["deliverCharges"]);

    status = json["status"];
    isDeleted = json["isDeleted"];
    additionalNotes = json["additionalNotes"];

    storeRevenue = _toDouble(json["storeRevenue"]);
    platformRevenue = _toDouble(json["platformRevenue"]);

    statusHistory = json["statusHistory"] ?? [];

    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    return {
      "userAddress": userAddress?.toJson(),
      "_id": id,
      "userId": userId,
      "storeId": storeId,
      "items": items?.map((e) => e.toJson()).toList(),
      "totalAmount": totalAmount,
      "deliverCharges": deliverCharges,
      "status": status,
      "isDeleted": isDeleted,
      "additionalNotes": additionalNotes,
      "storeRevenue": storeRevenue,
      "platformRevenue": platformRevenue,
      "statusHistory": statusHistory,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

class OrderItemData {
  String? productId;
  String? productName;
  int? quantity;
  double? price;
  String? productImage;
  String? id;

  OrderItemData({
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.productImage,
    this.id,
  });

  OrderItemData.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    price = _toDouble(json['price']);
    productImage = json['productImage'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "price": price,
      "productImage": productImage,
      "_id": id,
    };
  }
}

class VendorUser {
  VendorAddress? vendorAddress;

  String? id;
  String? email;

  bool? isProfileCompleted;
  bool? isVerified;
  String? role;

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? gender;
  String? dateOfBirth;

  bool? ageVerified;

  String? businessName;
  String? openTime;
  String? closeTime;
  List<dynamic>? offDays;

  List<VendorUserAddress>? userAddress;

  String? profilePicture;

  String? stripeCustomerId;
  String? veriffStatus;
  String? veriffSessionId;

  VendorUser({
    this.vendorAddress,
    this.id,
    this.email,
    this.isProfileCompleted,
    this.isVerified,
    this.role,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.ageVerified,
    this.businessName,
    this.openTime,
    this.closeTime,
    this.offDays,
    this.userAddress,
    this.profilePicture,
    this.stripeCustomerId,
    this.veriffStatus,
    this.veriffSessionId,
  });

  VendorUser.fromJson(Map<String, dynamic> json) {
    vendorAddress = json["vendorAddress"] != null
        ? VendorAddress.fromJson(json["vendorAddress"])
        : null;

    id = json["_id"];
    email = json["email"];
    isProfileCompleted = json["isProfileCompleted"];
    isVerified = json["isVerified"];
    role = json["role"];

    firstName = json["firstName"];
    lastName = json["lastName"];
    phoneNumber = json["phoneNumber"];
    gender = json["gender"];
    dateOfBirth = json["dateOfBirth"];

    ageVerified = json["ageVerified"];

    businessName = json["businessName"];
    openTime = json["openTime"];
    closeTime = json["closeTime"];
    offDays = json["offDays"] ?? [];

    profilePicture = json["profilePicture"];

    stripeCustomerId = json["stripeCustomerId"];
    veriffStatus = json["veriffStatus"];
    veriffSessionId = json["veriffSessionId"];

    if (json["userAddress"] != null) {
      userAddress = [];
      json["userAddress"].forEach((v) {
        userAddress!.add(VendorUserAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "vendorAddress": vendorAddress?.toJson(),
      "_id": id,
      "email": email,
      "isProfileCompleted": isProfileCompleted,
      "isVerified": isVerified,
      "role": role,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "ageVerified": ageVerified,
      "businessName": businessName,
      "openTime": openTime,
      "closeTime": closeTime,
      "offDays": offDays,
      "userAddress": userAddress?.map((e) => e.toJson()).toList(),
      "profilePicture": profilePicture,
      "stripeCustomerId": stripeCustomerId,
      "veriffStatus": veriffStatus,
      "veriffSessionId": veriffSessionId,
    };
  }
}

class VendorAddress {
  String? type;

  VendorAddress({this.type});

  VendorAddress.fromJson(Map<String, dynamic> json) {
    type = json["type"];
  }

  Map<String, dynamic> toJson() => {"type": type};
}

class VendorUserAddress {
  String? type;
  List<dynamic>? coordinates;
  String? address;
  String? floorNumber;
  String? apartmentNumber;
  String? suiteNumber;
  bool? isDefault;
  String? addressName;
  String? id;

  VendorUserAddress({
    this.type,
    this.coordinates,
    this.address,
    this.floorNumber,
    this.apartmentNumber,
    this.suiteNumber,
    this.isDefault,
    this.addressName,
    this.id,
  });

  VendorUserAddress.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    coordinates = json["coordinates"] ?? [];
    address = json["address"];
    floorNumber = json["floorNumber"];
    apartmentNumber = json["apartmentNumber"];
    suiteNumber = json["suiteNumber"];
    isDefault = json["isDefault"];
    addressName = json["addressName"];
    id = json["_id"];
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "coordinates": coordinates,
      "address": address,
      "floorNumber": floorNumber,
      "apartmentNumber": apartmentNumber,
      "suiteNumber": suiteNumber,
      "isDefault": isDefault,
      "addressName": addressName,
      "_id": id,
    };
  }
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
