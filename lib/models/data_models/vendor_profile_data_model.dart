import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'dart:convert';

class VendorProfileDataModel {
  String? businessName;
  String? businessDescription;

  String? openTime;
  String? closeTime;

  String? phoneNumber;

  List<String>? offDays;

  double? deliveryRadius;

  File? businessLicense;
  File? profilePicture;

  String? address;
  Map<String, dynamic>? location;

  VendorProfileDataModel({
    this.businessName,
    this.businessDescription,
    this.openTime,
    this.closeTime,
    this.phoneNumber,
    this.offDays,
    this.deliveryRadius,
    this.businessLicense,
    this.profilePicture,
    this.address,
    this.location,
  });

  Map<String, dynamic> toFormDataMap() {
    log("LOCATION IN VENDOR PROFILE MODEL: $location");
    return {
      "businessName": businessName,
      "businessDescription": businessDescription,
      "openTime": openTime,
      "closeTime": closeTime,
      "phoneNumber": phoneNumber,

      "offDays": offDays,

      "radius": deliveryRadius,

      "address": address,

      "location": location,
      if (businessLicense != null)
        "businessLicense": MultipartFile.fromFile(
          businessLicense!.path,
          filename: businessLicense!.path.split('/').last,
        ),
      if (profilePicture != null)
        "profilePicture": MultipartFile.fromFile(
          profilePicture!.path,
          filename: profilePicture!.path.split('/').last,
        ),
    };
  }
}
