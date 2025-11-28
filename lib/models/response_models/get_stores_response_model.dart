class GetStoresResponseModel {
  bool? status;
  String? message;
  List<StoreInformation>? data;

  GetStoresResponseModel({this.status, this.message, this.data});

  GetStoresResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['data'] != null && json['data'] is List) {
      data = [];
      json['data'].forEach((v) {
        data!.add(StoreInformation.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class StoreInformation {
  VendorAddress? vendorAddress;
  String? sId;
  String? profilePicture;
  String? businessName;
  String? openTime;
  String? closeTime;
  List<String>? offDays;
  dynamic deliveryRadius;
  String? businessDescription;

  StoreInformation({
    this.vendorAddress,
    this.sId,
    this.profilePicture,
    this.businessName,
    this.openTime,
    this.closeTime,
    this.offDays,
    this.deliveryRadius,
    this.businessDescription,
  });

  StoreInformation.fromJson(Map<String, dynamic> json) {
    vendorAddress = json['vendorAddress'] != null
        ? VendorAddress.fromJson(json['vendorAddress'])
        : null;

    sId = json['_id'];
    profilePicture = json['profilePicture'];
    businessName = json['businessName'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];

    /// SAFE PARSING FOR offDays
    offDays = [];
    if (json['offDays'] != null && json['offDays'] is List) {
      for (var item in json['offDays']) {
        if (item is String) {
          offDays!.add(item);
        }
      }
    }

    deliveryRadius = json['deliveryRadius'];
    businessDescription = json['businessDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};

    if (vendorAddress != null) {
      map['vendorAddress'] = vendorAddress!.toJson();
    }

    map['_id'] = sId;
    map['profilePicture'] = profilePicture;
    map['businessName'] = businessName;
    map['openTime'] = openTime;
    map['closeTime'] = closeTime;
    map['offDays'] = offDays;
    map['deliveryRadius'] = deliveryRadius;
    map['businessDescription'] = businessDescription;

    return map;
  }
}

class VendorAddress {
  String? type;
  List<double>? coordinates;
  String? address;

  VendorAddress({this.type, this.coordinates, this.address});

  VendorAddress.fromJson(Map<String, dynamic> json) {
    type = json['type'];

    // ---- SAFE COORDINATES PARSING ----
    if (json['coordinates'] != null && json['coordinates'] is List) {
      coordinates = [];

      for (var c in json['coordinates']) {
        if (c is int) {
          coordinates!.add(c.toDouble());
        } else if (c is double) {
          coordinates!.add(c);
        } else if (c is String) {
          // Try parsing string → double
          coordinates!.add(double.tryParse(c) ?? 0.0);
        } else {
          // fallback for unexpected types
          coordinates!.add(0.0);
        }
      }
    } else {
      coordinates = [];
    }

    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};

    map['type'] = type;
    map['coordinates'] = coordinates;
    map['address'] = address;

    return map;
  }
}
