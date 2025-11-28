import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UserPermissions {
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      await Geolocator.openLocationSettings();

      await Future.delayed(const Duration(seconds: 2));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permission denied. Opening app settings...');
        await Geolocator.openAppSettings();

        await Future.delayed(const Duration(seconds: 2));
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return false;
        }
      }
    }

    // Denied forever
    if (permission == LocationPermission.deniedForever) {
      debugPrint(
        ' Location permission permanently denied. Opening settings...',
      );
      await Geolocator.openAppSettings();
      // Wait a bit and recheck
      await Future.delayed(const Duration(seconds: 2));
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return false;
      }
    }

    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return null;

    // Retrieve the current position
    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<void> requestCameraAndMicrophonePermission() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      debugPrint('Camera and Microphone permissions granted');
      // You can now access camera and microphone
    } else if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      debugPrint('Camera or Microphone permissions denied');
      // Handle denied permission (e.g., show a message, disable features)
    } else if (cameraStatus.isPermanentlyDenied ||
        microphoneStatus.isPermanentlyDenied) {
      debugPrint('Camera or Microphone permissions permanently denied');
      // Guide the user to app settings to grant permissions manually
      openAppSettings();
    }
  }
}
