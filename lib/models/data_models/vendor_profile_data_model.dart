import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

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

  // Add floor and apartment number fields for vendors
  String? floorNumber;
  String? apartmentNumber;

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
    this.floorNumber,
    this.apartmentNumber,
  });

  Map<String, dynamic> toFormDataMap() {
    log("LOCATION IN VENDOR PROFILE MODEL: $location");

    // Convert location Map to JSON string for FormData
    String? locationJson;
    if (location != null) {
      try {
        locationJson = jsonEncode(location);
        log("LOCATION JSON STRING: $locationJson");
      } catch (e) {
        log("Error encoding location to JSON: $e");
      }
    }

    return {
      "businessName": businessName,
      "businessDescription": businessDescription,
      "openTime": openTime,
      "closeTime": closeTime,
      "phoneNumber": phoneNumber,

      "offDays": offDays,

      "deliveryRadius": deliveryRadius,

      "address": address,

      // Send floor and apartment numbers as separate fields for proper backend storage
      "floorNumber": floorNumber,
      "apartmentNumber": apartmentNumber,

      // Send location as JSON string for FormData compatibility
      if (locationJson != null) "location": locationJson,

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
