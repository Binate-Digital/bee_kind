class VendorOrdersResponseModel {
  bool? status;
  String? message;
  List<VendorOrder>? data;

  VendorOrdersResponseModel({this.status, this.message, this.data});

  VendorOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VendorOrder>[];
      json['data'].forEach((v) {
        data!.add(VendorOrder.fromJson(v));
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

class VendorOrder {
  String? sId;
  String? orderId;
  String? userId;
  String? storeId;
  String? vendorId;
  String? status; // pending, accepted, completed, cancelled
  List<OrderItem>? items;
  double? totalPrice;
  double? totalAmount;
  String? paymentStatus;
  String? deliveryAddress;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  UserInfo? user;

  VendorOrder({
    this.sId,
    this.orderId,
    this.userId,
    this.storeId,
    this.vendorId,
    this.status,
    this.items,
    this.totalPrice,
    this.totalAmount,
    this.paymentStatus,
    this.deliveryAddress,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  VendorOrder.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderId = json['orderId'];
    userId = json['userId'];
    storeId = json['storeId'];
    vendorId = json['vendorId'];
    status = json['status'];
    totalPrice = json['totalPrice'] != null
        ? (json['totalPrice'] is num
              ? (json['totalPrice'] as num).toDouble()
              : double.tryParse(json['totalPrice'].toString()))
        : null;
    totalAmount = json['totalAmount'] != null
        ? (json['totalAmount'] is num
              ? (json['totalAmount'] as num).toDouble()
              : double.tryParse(json['totalAmount'].toString()))
        : null;
    paymentStatus = json['paymentStatus'];
    deliveryAddress = json['deliveryAddress'];
    phoneNumber = json['phoneNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) {
        items!.add(OrderItem.fromJson(v));
      });
    }

    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['orderId'] = orderId;
    data['userId'] = userId;
    data['storeId'] = storeId;
    data['vendorId'] = vendorId;
    data['status'] = status;
    data['totalPrice'] = totalPrice;
    data['totalAmount'] = totalAmount;
    data['paymentStatus'] = paymentStatus;
    data['deliveryAddress'] = deliveryAddress;
    data['phoneNumber'] = phoneNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }

    if (user != null) {
      data['user'] = user!.toJson();
    }

    return data;
  }
}

class OrderItem {
  String? productId;
  String? productName;
  String? productImage;
  int? quantity;
  double? price;
  double? totalPrice;

  OrderItem({
    this.productId,
    this.productName,
    this.productImage,
    this.quantity,
    this.price,
    this.totalPrice,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productImage = json['productImage'];
    quantity = json['quantity'];
    price = json['price'] != null
        ? (json['price'] is num
              ? (json['price'] as num).toDouble()
              : double.tryParse(json['price'].toString()))
        : null;
    totalPrice = json['totalPrice'] != null
        ? (json['totalPrice'] is num
              ? (json['totalPrice'] as num).toDouble()
              : double.tryParse(json['totalPrice'].toString()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['productImage'] = productImage;
    data['quantity'] = quantity;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    return data;
  }
}

class UserInfo {
  String? name;
  String? email;
  String? phoneNumber;

  UserInfo({this.name, this.email, this.phoneNumber});

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phoneNumber': phoneNumber};
  }
}
