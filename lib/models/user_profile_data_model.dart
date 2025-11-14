import 'dart:io';

import 'package:dio/dio.dart';

class UserProfileDataModel {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? dateOfBirth;
  String? gender;

  String? flatNumber;
  String? suiteNumber;
  String? appartmentNumber;
  String? floorNumber;

  String? address;
  Map<String, dynamic>? location;

  File? profilePicture;

  UserProfileDataModel({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.flatNumber,
    this.suiteNumber,
    this.appartmentNumber,
    this.floorNumber,
    this.address,
    this.location,
    this.profilePicture,
  });

  Map<String, dynamic> toFormDataMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "flatNumber": flatNumber,
      "suiteNumber": suiteNumber,
      "appartmentNumber": appartmentNumber,
      "floorNumber": floorNumber,

      "address": address,

      "location": location,
      if (profilePicture != null)
        "profilePicture": MultipartFile.fromFile(
          profilePicture!.path,
          filename: profilePicture!.path.split('/').last,
        ),
    };
  }
}
