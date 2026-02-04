import 'dart:convert';
import 'dart:developer';
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

  /// --- Validate File Before Upload ---
  bool _isValidLocalFile(File? file) {
    if (file == null) return false;

    try {
      final exists = file.existsSync();
      final isFile =
          FileSystemEntity.typeSync(file.path) == FileSystemEntityType.file;

      return exists && isFile;
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic> toFormDataMap() {
    // Convert location Map to JSON string for FormData
    String? locationJson;
    if (location != null) {
      try {
        locationJson = jsonEncode(location);
        log("USER LOCATION JSON STRING: $locationJson");
      } catch (e) {
        log("Error encoding user location to JSON: $e");
      }
    }

    final map = <String, dynamic>{
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
      // Send location as JSON string for FormData compatibility
      if (locationJson != null) "location": locationJson,
    };

    // Only include image if valid local file
    if (_isValidLocalFile(profilePicture)) {
      map["profilePicture"] = MultipartFile.fromFileSync(
        profilePicture!.path,
        filename: profilePicture!.path.split('/').last,
      );
    } else {
      log("No valid local image selected — $profilePicture");
    }

    return map;
  }
}
