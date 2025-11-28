class CreateOrderDataModel {
  String? storeId;
  List<OrderItem>? items;
  String? additionalNotes;
  UserAddress? userAddress;
  dynamic totalAmount;
  dynamic deliveryCharges;
  String? paymentMethodId;

  CreateOrderDataModel({
    this.storeId,
    this.items,
    this.additionalNotes,
    this.userAddress,
    this.totalAmount,
    this.deliveryCharges,
    this.paymentMethodId,
  });

  factory CreateOrderDataModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderDataModel(
      storeId: json["storeId"],
      items: json["items"] != null
          ? List<OrderItem>.from(
              json["items"].map((x) => OrderItem.fromJson(x)),
            )
          : [],
      additionalNotes: json["additionalNotes"],
      userAddress: json["userAddress"] != null
          ? UserAddress.fromJson(json["userAddress"])
          : null,
      totalAmount: json["totalAmount"],
      deliveryCharges: json["deliveryCharges"],
      paymentMethodId: json["paymentMethodId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "storeId": storeId,
      "items": items?.map((x) => x.toJson()).toList(),
      "additionalNotes": additionalNotes,
      "userAddress": userAddress?.toJson(),
      "totalAmount": totalAmount,
      "deliveryCharges": deliveryCharges,
      "paymentMethodId": paymentMethodId,
    };
  }
}

class OrderItem {
  String? productId;
  String? productName;
  int? quantity;
  dynamic unitPrice;
  String? productImage;

  OrderItem({
    this.productId,
    this.productName,
    this.quantity,
    this.unitPrice,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json["productId"],
      productName: json["productName"],
      quantity: json["quantity"],
      unitPrice: json["price"],
      productImage: json["productImage"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "quantity": quantity,
      "price": unitPrice,
      "productImage": productImage,
    };
  }
}

class UserAddress {
  String? type;
  List<double>? coordinates;
  String? address;
  String? floorNumber;
  String? apartmentNumber;
  String? suiteNumber;
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

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      type: json["type"],
      coordinates: json["coordinates"] != null
          ? List<double>.from(
              json["coordinates"].map((x) => (x as num).toDouble()),
            )
          : [],
      address: json["address"],
      floorNumber: json["floorNumber"],
      apartmentNumber: json["apartmentNumber"],
      suiteNumber: json["suiteNumber"],
      isDefault: json["isDefault"],
    );
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
