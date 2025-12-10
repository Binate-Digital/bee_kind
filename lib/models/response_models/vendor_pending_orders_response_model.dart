class PendingOrdersResponseModel {
  bool? status;
  String? message;
  List<PendingOrder>? data;

  PendingOrdersResponseModel({this.status, this.message, this.data});

  PendingOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PendingOrder>[];
      json['data'].forEach((v) {
        data!.add(PendingOrder.fromJson(v));
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

class PendingOrder {
  String? sId;
  double? totalAmount;
  String? status;
  String? createdAt;
  UserAddress? userAddress;
  List<PendingOrderItem>? items;

  PendingOrder({
    this.sId,
    this.totalAmount,
    this.status,
    this.createdAt,
    this.userAddress,
    this.items,
  });

  PendingOrder.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    totalAmount = json['totalAmount'] != null
        ? (json['totalAmount'] is num
              ? (json['totalAmount'] as num).toDouble()
              : double.tryParse(json['totalAmount'].toString()))
        : null;
    status = json['status'];
    createdAt = json['createdAt'];
    userAddress = json['userAddress'] != null
        ? UserAddress.fromJson(json['userAddress'])
        : null;
    if (json['items'] != null) {
      items = <PendingOrderItem>[];
      json['items'].forEach((v) {
        items!.add(PendingOrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['totalAmount'] = totalAmount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    if (userAddress != null) {
      data['userAddress'] = userAddress!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddress {
  String? address;
  List<double>? coordinates;

  UserAddress({this.address, this.coordinates});

  UserAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    if (json['coordinates'] != null) {
      coordinates = List<double>.from(
        json['coordinates'].map((e) => (e as num).toDouble()),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'coordinates': coordinates};
  }
}

class PendingOrderItem {
  String? productName;
  int? quantity;
  double? price;
  String? productImage;

  PendingOrderItem({
    this.productName,
    this.quantity,
    this.price,
    this.productImage,
  });

  PendingOrderItem.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    quantity = json['quantity'];
    price = json['price'] != null
        ? (json['price'] is num
              ? (json['price'] as num).toDouble()
              : double.tryParse(json['price'].toString()))
        : null;
    productImage = json['productImage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'productImage': productImage,
    };
  }
}
