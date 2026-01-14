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
<<<<<<< Updated upstream
      json['data'].forEach((v) {
        data!.add(VendorOrder.fromJson(v));
      });
=======
      var dataField = json['data'];
      if (dataField is List) {
        // Handle array response
        dataField.forEach((v) {
          data!.add(VendorOrder.fromJson(v));
        });
      } else if (dataField is Map && dataField['orders'] is List) {
        // Handle object with orders array
        dataField['orders'].forEach((v) {
          data!.add(VendorOrder.fromJson(v));
        });
      } else if (dataField is Map && dataField['data'] is List) {
        // Handle nested data array
        dataField['data'].forEach((v) {
          data!.add(VendorOrder.fromJson(v));
        });
      }
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
  String? deliveryAddress;
  String? phoneNumber;
=======
  // userAddress comes as an object from API, but we might want to store it as string or keep object
  // For now, let's map the address string to deliveryAddress for UI compatibility
  String? deliveryAddress;
  UserAddress? userAddress;
  String? phoneNumber;
  // properties that might come from API
  DriverDetail? driverDetail;
>>>>>>> Stashed changes
  String? createdAt;
  String? updatedAt;
  UserInfo? user;

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    this.phoneNumber,
=======
    this.userAddress,
    this.phoneNumber,
    this.driverDetail,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    deliveryAddress = json['userAddress']['address'];
=======

    // Handle both direct string and nested object for address
    if (json['userAddress'] != null && json['userAddress'] is Map) {
      userAddress = UserAddress.fromJson(json['userAddress']);
      deliveryAddress = userAddress?.address;
    } else {
      deliveryAddress = json['deliveryAddress'];
    }

    if (json['driverDetail'] != null) {
      driverDetail = DriverDetail.fromJson(json['driverDetail']);
    }

>>>>>>> Stashed changes
    phoneNumber = json['phoneNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) {
        items!.add(OrderItem.fromJson(v));
      });
    }

<<<<<<< Updated upstream
    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
=======
    // Parse user from different possible locations
    if (json['user'] != null) {
      user = UserInfo.fromJson(json['user']);
    } else if (json['data'] != null && json['data']['user'] != null) {
      // Handle nested structure from vendor/get-order API
      user = UserInfo.fromJson(json['data']['user']);
    } else {
      user = null;
    }
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
    if (userAddress != null) {
      data['userAddress'] = userAddress!.toJson();
    }
    if (driverDetail != null) {
      data['driverDetail'] = driverDetail!.toJson();
    }
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
=======
class DriverDetail {
  String? driverName;
  String? phoneNumber;
  String? color;
  String? make;
  String? numberPlate;

  DriverDetail({
    this.driverName,
    this.phoneNumber,
    this.color,
    this.make,
    this.numberPlate,
  });

  DriverDetail.fromJson(Map<String, dynamic> json) {
    driverName = json['driverName'];
    phoneNumber = json['phoneNumber'];
    color = json['color'];
    make = json['make'];
    numberPlate = json['numberPlate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverName'] = driverName;
    data['phoneNumber'] = phoneNumber;
    data['color'] = color;
    data['make'] = make;
    data['numberPlate'] = numberPlate;
    return data;
  }
}

class UserAddress {
  String? type;
  List<double>? coordinates;
  String? address;
  String? floorNumber;
  String? apartmentNumber;
  String? suiteNumber;

  UserAddress({
    this.type,
    this.coordinates,
    this.address,
    this.floorNumber,
    this.apartmentNumber,
    this.suiteNumber,
  });

  UserAddress.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = List<double>.from(
        json['coordinates'].map(
          (x) => x is num ? x.toDouble() : double.parse(x.toString()),
        ),
      );
    }
    address = json['address'];
    floorNumber = json['floorNumber'];
    apartmentNumber = json['apartmentNumber'];
    suiteNumber = json['suiteNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    data['address'] = address;
    data['floorNumber'] = floorNumber;
    data['apartmentNumber'] = apartmentNumber;
    data['suiteNumber'] = suiteNumber;
    return data;
  }
}

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

  UserInfo({this.name, this.email, this.phoneNumber});
=======
  String? firstName;
  String? lastName;
  String? profilePicture;

  UserInfo({
    this.name,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });
>>>>>>> Stashed changes

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
<<<<<<< Updated upstream
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phoneNumber': phoneNumber};
  }
}
=======
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}

// class VendorOrdersResponseModel {
//   bool? status;
//   String? message;
//   List<VendorOrder>? data;

//   VendorOrdersResponseModel({this.status, this.message, this.data});

//   VendorOrdersResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <VendorOrder>[];
//       json['data'].forEach((v) {
//         data!.add(VendorOrder.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class VendorOrder {
//   String? sId;
//   String? orderId;
//   String? userId;
//   String? storeId;
//   String? vendorId;
//   String? status; // pending, accepted, completed, cancelled
//   List<OrderItem>? items;
//   double? totalPrice;
//   double? totalAmount;
//   String? paymentStatus;
//   String? deliveryAddress;
//   String? phoneNumber;
//   String? createdAt;
//   String? updatedAt;
//   UserInfo? user;

//   VendorOrder({
//     this.sId,
//     this.orderId,
//     this.userId,
//     this.storeId,
//     this.vendorId,
//     this.status,
//     this.items,
//     this.totalPrice,
//     this.totalAmount,
//     this.paymentStatus,
//     this.deliveryAddress,
//     this.phoneNumber,
//     this.createdAt,
//     this.updatedAt,
//     this.user,
//   });

//   VendorOrder.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     orderId = json['orderId'];
//     userId = json['userId'];
//     storeId = json['storeId'];
//     vendorId = json['vendorId'];
//     status = json['status'];
//     totalPrice = json['totalPrice'] != null
//         ? (json['totalPrice'] is num
//               ? (json['totalPrice'] as num).toDouble()
//               : double.tryParse(json['totalPrice'].toString()))
//         : null;
//     totalAmount = json['totalAmount'] != null
//         ? (json['totalAmount'] is num
//               ? (json['totalAmount'] as num).toDouble()
//               : double.tryParse(json['totalAmount'].toString()))
//         : null;
//     paymentStatus = json['paymentStatus'];
//     deliveryAddress = json['userAddress']['address'];
//     phoneNumber = json['phoneNumber'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];

//     if (json['items'] != null) {
//       items = <OrderItem>[];
//       json['items'].forEach((v) {
//         items!.add(OrderItem.fromJson(v));
//       });
//     }

//     user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['orderId'] = orderId;
//     data['userId'] = userId;
//     data['storeId'] = storeId;
//     data['vendorId'] = vendorId;
//     data['status'] = status;
//     data['totalPrice'] = totalPrice;
//     data['totalAmount'] = totalAmount;
//     data['paymentStatus'] = paymentStatus;
//     data['deliveryAddress'] = deliveryAddress;
//     data['phoneNumber'] = phoneNumber;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;

//     if (items != null) {
//       data['items'] = items!.map((v) => v.toJson()).toList();
//     }

//     if (user != null) {
//       data['user'] = user!.toJson();
//     }

//     return data;
//   }
// }

// class OrderItem {
//   String? productId;
//   String? productName;
//   String? productImage;
//   int? quantity;
//   double? price;
//   double? totalPrice;

//   OrderItem({
//     this.productId,
//     this.productName,
//     this.productImage,
//     this.quantity,
//     this.price,
//     this.totalPrice,
//   });

//   OrderItem.fromJson(Map<String, dynamic> json) {
//     productId = json['productId'];
//     productName = json['productName'];
//     productImage = json['productImage'];
//     quantity = json['quantity'];
//     price = json['price'] != null
//         ? (json['price'] is num
//               ? (json['price'] as num).toDouble()
//               : double.tryParse(json['price'].toString()))
//         : null;
//     totalPrice = json['totalPrice'] != null
//         ? (json['totalPrice'] is num
//               ? (json['totalPrice'] as num).toDouble()
//               : double.tryParse(json['totalPrice'].toString()))
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['productId'] = productId;
//     data['productName'] = productName;
//     data['productImage'] = productImage;
//     data['quantity'] = quantity;
//     data['price'] = price;
//     data['totalPrice'] = totalPrice;
//     return data;
//   }
// }

// class UserInfo {
//   String? name;
//   String? email;
//   String? phoneNumber;

//   UserInfo({this.name, this.email, this.phoneNumber});

//   UserInfo.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     email = json['email'];
//     phoneNumber = json['phoneNumber'];
//   }

//   Map<String, dynamic> toJson() {
//     return {'name': name, 'email': email, 'phoneNumber': phoneNumber};
//   }
// }
>>>>>>> Stashed changes
