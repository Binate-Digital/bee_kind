double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

class OrdersResponseModel {
  bool? status;
  String? message;
  List<OrderData>? data;

  OrdersResponseModel({this.status, this.message, this.data});

  OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message']?.toString();

    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List).map((e) => OrderData.fromJson(e)).toList();
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderData {
  UserAddress? userAddress;
  String? sId;
  String? userId;
  String? storeId;
  List<Items>? items;
  double? totalAmount;
  double? deliverCharges;
  String? status;
  bool? isDeleted;
  dynamic additionalNotes;
  int? storeRevenue;
  int? platformRevenue;
  List<dynamic>? statusHistory; // dynamic list
  String? createdAt;
  String? updatedAt;
  int? iV;

  OrderData({
    this.userAddress,
    this.sId,
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
    this.iV,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    userAddress = json['userAddress'] != null && json['userAddress'] is Map
        ? UserAddress.fromJson(json['userAddress'])
        : null;

    sId = json['_id']?.toString();
    userId = json['userId']?.toString();
    storeId = json['storeId']?.toString();

    // Items
    if (json['items'] != null && json['items'] is List) {
      items = (json['items'] as List).map((e) => Items.fromJson(e)).toList();
    } else {
      items = [];
    }

    totalAmount = _parseDouble(json['totalAmount']);

    deliverCharges = _parseDouble(json['deliverCharges']);

    status = json['status']?.toString();
    isDeleted = json['isDeleted'] as bool?;
    additionalNotes = json['additionalNotes'];

    storeRevenue = _parseInt(json['storeRevenue']);

    platformRevenue = _parseInt(json['platformRevenue']);

    // SAFE STATUS HISTORY
    statusHistory = json['statusHistory'] is List
        ? List<dynamic>.from(json['statusHistory'])
        : [];

    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();

    iV = _parseInt(json['__v']);
  }

  // removed instance helper; using module-level helpers above

  Map<String, dynamic> toJson() {
    return {
      "userAddress": userAddress?.toJson(),
      "_id": sId,
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
      "__v": iV,
    };
  }
}

class UserAddress {
  String? type;
  List<double>? coordinates;
  String? address;
  String? floorNumber;
  String? apartmentNumber;
  dynamic suiteNumber;
  bool? isDefault;

  UserAddress({
    this.type,
    this.coordinates,
    this.address,
    this.floorNumber,
    this.apartmentNumber,
    this.suiteNumber,
    this.isDefault,
  });

  UserAddress.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();

    // Safe coordinates parsing
    if (json['coordinates'] != null && json['coordinates'] is List) {
      coordinates = (json['coordinates'] as List)
          .map((e) => (e as num?)?.toDouble() ?? 0.0)
          .toList();
    } else {
      coordinates = [];
    }

    address = json['address']?.toString();
    floorNumber = json['floorNumber']?.toString();
    apartmentNumber = json['apartmentNumber']?.toString();
    suiteNumber = json['suiteNumber'];
    isDefault = json['isDefault'] as bool?;
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
    };
  }
}

class Items {
  String? productId;
  String? productName;
  int? quantity;
  double? price;
  String? productImage;
  String? sId;

  Items({
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.productImage,
    this.sId,
  });

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId']?.toString();
    productName = json['productName']?.toString();

    quantity = json['quantity'] is int
        ? json['quantity']
        : int.tryParse(json['quantity']?.toString() ?? "");

    price = _parseDouble(json['price']);

    productImage = json['productImage']?.toString();
    sId = json['_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "price": price,
      "productImage": productImage,
      "_id": sId,
    };
  }
}
