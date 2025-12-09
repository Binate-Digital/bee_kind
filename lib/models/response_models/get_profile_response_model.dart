class GetProfileResponseModel {
  bool? status;
  dynamic message;
  ProfileData? data;

  GetProfileResponseModel({this.status, this.message, this.data});

  GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {"status": status, "message": message, "data": data?.toJson()};
  }
}

class ProfileData {
  VendorAddress? vendorAddress;

  dynamic id;
  dynamic email;
  bool? isProfileCompleted;
  bool? isVerified;
  dynamic role;
  dynamic profilePicture;
  dynamic firstName;
  dynamic lastName;
  dynamic phoneNumber;
  dynamic gender;
  dynamic dateOfBirth;
  bool? ageVerified;

  dynamic businessName;
  dynamic openTime;
  dynamic closeTime;
  List<dynamic>? offDays;

  double? deliveryRadius;
  List<dynamic>? documents;

  bool? isDeleted;

  List<UserAddress>? userAddress;

  dynamic createdAt;
  dynamic updatedAt;
  int? v;

  /// The new backend fields (based on your response)
  bool? isNotificationEnabled;
  dynamic socialType;
  dynamic deviceType;
  dynamic stripeAccountId;
  dynamic addressName;
  dynamic defaultPaymentMethod;
  dynamic stripeCustomerId;
  bool? hideProfile;
  dynamic veriffStatus;
  dynamic veriffSessionId;
  dynamic verifiedAge;

  ProfileData({
    this.vendorAddress,
    this.id,
    this.email,
    this.isProfileCompleted,
    this.isVerified,
    this.role,
    this.profilePicture,
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
    this.deliveryRadius,
    this.documents,
    this.isDeleted,
    this.userAddress,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.deviceType,
    this.isNotificationEnabled,
    this.socialType,
    this.stripeAccountId,
    this.addressName,
    this.defaultPaymentMethod,
    this.stripeCustomerId,
    this.hideProfile,
    this.veriffStatus,
    this.veriffSessionId,
    this.verifiedAge,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    vendorAddress = json['vendorAddress'] != null
        ? VendorAddress.fromJson(json['vendorAddress'])
        : null;

    id = json['_id'];
    email = json['email'];
    isProfileCompleted = json['isProfileCompleted'];
    isVerified = json['isVerified'];
    role = json['role'];
    profilePicture = json['profilePicture'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    ageVerified = json['ageVerified'];

    businessName = json['businessName'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];

    offDays = json['offDays']?.cast<dynamic>();
    // deliveryRadius may come as int or double
    if (json['deliveryRadius'] != null) {
      final dr = json['deliveryRadius'];
      if (dr is num) {
        deliveryRadius = dr.toDouble();
      } else {
        deliveryRadius = double.tryParse(dr.toString());
      }
    } else {
      deliveryRadius = null;
    }
    documents = json['documents']?.cast<dynamic>();
    isDeleted = json['isDeleted'];

    /// userAddress is always a List
    if (json['userAddress'] != null) {
      userAddress = [];
      json['userAddress'].forEach((v) {
        userAddress!.add(UserAddress.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // __v may be int or double; ensure int
    if (json['__v'] != null) {
      final vv = json['__v'];
      if (vv is num) {
        v = vv.toInt();
      } else {
        v = int.tryParse(vv.toString());
      }
    } else {
      v = null;
    }

    /// Newly included backend fields
    deviceType = json['deviceType'];
    isNotificationEnabled = json['isNotificationEnabled'];
    socialType = json['socialType'];
    stripeAccountId = json['stripeAccountId'];
    addressName = json['addressName'];
    defaultPaymentMethod = json['defaultPaymentMethod'];
    stripeCustomerId = json['stripeCustomerId'];
    hideProfile = json['hideProfile'];
    veriffStatus = json['veriffStatus'];
    veriffSessionId = json['veriffSessionId'];
    verifiedAge = json['verifiedAge'];
  }

  Map<String, dynamic> toJson() {
    return {
      "vendorAddress": vendorAddress?.toJson(),
      "_id": id,
      "email": email,
      "isProfileCompleted": isProfileCompleted,
      "isVerified": isVerified,
      "role": role,
      "profilePicture": profilePicture,
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

      "deliveryRadius": deliveryRadius,
      "documents": documents,
      "isDeleted": isDeleted,

      "userAddress": userAddress?.map((e) => e.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,

      "deviceType": deviceType,
      "isNotificationEnabled": isNotificationEnabled,
      "socialType": socialType,

      "stripeAccountId": stripeAccountId,
      "addressName": addressName,
      "defaultPaymentMethod": defaultPaymentMethod,
      "stripeCustomerId": stripeCustomerId,
      "hideProfile": hideProfile,
      "veriffStatus": veriffStatus,
      "veriffSessionId": veriffSessionId,
      "verifiedAge": verifiedAge,
    };
  }
}

class VendorAddress {
  dynamic type;
  List<dynamic>? coordinates;

  VendorAddress({this.type, this.coordinates});

  VendorAddress.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates']?.cast<dynamic>();
  }

  Map<String, dynamic> toJson() {
    return {"type": type, "coordinates": coordinates};
  }
}

class UserAddress {
  dynamic type;
  List<dynamic>? coordinates;
  dynamic address;
  dynamic floorNumber;
  dynamic apartmentNumber;
  dynamic suiteNumber;
  bool? isDefault;
  dynamic id;

  UserAddress({
    this.type,
    this.coordinates,
    this.address,
    this.floorNumber,
    this.apartmentNumber,
    this.suiteNumber,
    this.isDefault,
    this.id,
  });

  UserAddress.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates']?.cast<dynamic>();
    address = json['address'];
    floorNumber = json['floorNumber'];
    apartmentNumber = json['apartmentNumber'];
    suiteNumber = json['suiteNumber'];
    isDefault = json['isDefault'];
    id = json['_id'];
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
      "_id": id,
    };
  }
}
