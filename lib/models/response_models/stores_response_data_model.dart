// class StoresResponseModel {
//   bool? status;
//   String? message;
//   List<StoreInfo>? data;

//   StoresResponseModel({this.status, this.message, this.data});

//   StoresResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <StoreInfo>[];
//       json['data'].forEach((v) {
//         data!.add(StoreInfo.fromJson(v));
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

// class StoreInfo {
//   VendorAddress? vendorAddress;
//   String? sId;
//   String? profilePicture;
//   String? businessName;
//   String? openTime;
//   String? closeTime;
//   List<String>? offDays;
//   int? deliveryRadius;
//   String? businessDescription;

//   StoreInfo({
//     this.vendorAddress,
//     this.sId,
//     this.profilePicture,
//     this.businessName,
//     this.openTime,
//     this.closeTime,
//     this.offDays,
//     this.deliveryRadius,
//     this.businessDescription,
//   });

//   StoreInfo.fromJson(Map<String, dynamic> json) {
//     vendorAddress = json['vendorAddress'] != null
//         ? VendorAddress.fromJson(json['vendorAddress'])
//         : null;
//     sId = json['_id'];
//     profilePicture = json['profilePicture'];
//     businessName = json['businessName'];
//     openTime = json['openTime'];
//     closeTime = json['closeTime'];
//     offDays = json['offDays'].cast<String>();
//     deliveryRadius = json['deliveryRadius'];
//     businessDescription = json['businessDescription'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (vendorAddress != null) {
//       data['vendorAddress'] = vendorAddress!.toJson();
//     }
//     data['_id'] = sId;
//     data['profilePicture'] = profilePicture;
//     data['businessName'] = businessName;
//     data['openTime'] = openTime;
//     data['closeTime'] = closeTime;
//     data['offDays'] = offDays;
//     data['deliveryRadius'] = deliveryRadius;
//     data['businessDescription'] = businessDescription;
//     return data;
//   }
// }

// class VendorAddress {
//   String? type;
//   List<double>? coordinates;
//   String? address;

//   VendorAddress({this.type, this.coordinates, this.address});

//   VendorAddress.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     coordinates = json['coordinates'].cast<double>();
//     address = json['address'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = type;
//     data['coordinates'] = coordinates;
//     data['address'] = address;
//     return data;
//   }
// }
