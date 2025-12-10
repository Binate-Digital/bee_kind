class SingleOrderResponseModel {
  bool? status;
  String? message;
  SingleOrderData? data;

  SingleOrderResponseModel({this.status, this.message, this.data});

  SingleOrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message']?.toString();
    data = (json['data'] is Map)
        ? SingleOrderData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {"status": status, "message": message, "data": data?.toJson()};
  }
}

class SingleOrderData {
  Order? order;
  List<dynamic>? statusTimeline;

  SingleOrderData({this.order, this.statusTimeline});

  SingleOrderData.fromJson(Map<String, dynamic> json) {
    order = (json['order'] is Map) ? Order.fromJson(json['order']) : null;

    statusTimeline = (json['statusTimeline'] is List)
        ? List<dynamic>.from(json['statusTimeline'])
        : [];
  }

  Map<String, dynamic> toJson() {
    return {"order": order?.toJson(), "statusTimeline": statusTimeline};
  }
}

class Order {
  UserAddress? userAddress;
  String? sId;
  String? userId;
  String? storeId;
  List<Items>? items;
  int? totalAmount;
  int? deliverCharges;
  String? status;
  bool? isDeleted;
  dynamic additionalNotes;
  int? storeRevenue;
  int? platformRevenue;
  List<dynamic>? statusHistory;
  String? createdAt;
  String? updatedAt;
  int? iV;
  StoreAddress? storeAddress;
  String? distance;
  String? eta;

  Order({
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
    this.storeAddress,
    this.distance,
    this.eta,
  });

  Order.fromJson(Map<String, dynamic> json) {
    userAddress = (json['userAddress'] is Map)
        ? UserAddress.fromJson(json['userAddress'])
        : null;

    sId = json['_id']?.toString();
    userId = json['userId']?.toString();
    storeId = json['storeId']?.toString();

    items = (json['items'] is List)
        ? (json['items'] as List).map((e) => Items.fromJson(e)).toList()
        : [];

    totalAmount = _parseInt(json['totalAmount']);
    deliverCharges = _parseInt(json['deliverCharges']);

    status = json['status']?.toString();
    isDeleted = json['isDeleted'] as bool?;
    additionalNotes = json['additionalNotes'];

    storeRevenue = _parseInt(json['storeRevenue']);
    platformRevenue = _parseInt(json['platformRevenue']);

    statusHistory = (json['statusHistory'] is List)
        ? List<dynamic>.from(json['statusHistory'])
        : [];

    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();

    iV = _parseInt(json['__v']);

    storeAddress = (json['storeAddress'] is Map)
        ? StoreAddress.fromJson(json['storeAddress'])
        : null;

    distance = json["distance"];
    eta = json["eta"];
  }

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
      "storeAddress": storeAddress?.toJson(),
      "distance": distance,
      "eta": eta,
    };
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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

    coordinates = (json['coordinates'] is List)
        ? (json['coordinates'] as List)
              .map((e) => (e as num?)?.toDouble() ?? 0.0)
              .toList()
        : [];

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
  int? price;
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

    quantity = _parseInt(json['quantity']);
    price = _parseInt(json['price']);

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

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class StoreAddress {
  String? type;
  List<double>? coordinates;
  String? address;

  StoreAddress({this.type, this.coordinates, this.address});

  StoreAddress.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();

    coordinates = (json['coordinates'] is List)
        ? (json['coordinates'] as List)
              .map((e) => (e as num?)?.toDouble() ?? 0.0)
              .toList()
        : [];

    address = json['address']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {"type": type, "coordinates": coordinates, "address": address};
  }
}
