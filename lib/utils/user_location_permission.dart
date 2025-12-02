import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UserPermissions {
  // -----------------------------
  // LOCATION HANDLER
  // -----------------------------
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (Platform.isAndroid) {
        await Geolocator.openLocationSettings();
      }
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 🔥 On iOS → DO NOT auto-open settings
    if (permission == LocationPermission.denied) {
      if (Platform.isAndroid) await openAppSettings();
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      if (Platform.isAndroid) await openAppSettings();
      return false;
    }

    return true;
  }

  // -----------------------------
  // CAMERA + MICROPHONE HANDLER
  // -----------------------------
  static Future<bool> handleCameraAndMicPermission() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    // iOS → NO settings redirection
    if (Platform.isIOS) {
      return cameraStatus.isGranted && micStatus.isGranted;
    }

    // Android → allow redirect to settings
    if (cameraStatus.isDenied || micStatus.isDenied) {
      await openAppSettings();
      return false;
    }

    if (cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return true;
  }

  // -----------------------------
  // REQUEST ALL
  // -----------------------------
  static Future<bool> requestAllPermissions() async {
    final loc = await handleLocationPermission();
    if (!loc) return false;

    final camMic = await handleCameraAndMicPermission();
    if (!camMic) return false;

    return true;
  }

  // -----------------------------
  // GET LOCATION
  // -----------------------------
  static Future<Position?> getCurrentLocation() async {
    final allowed = await handleLocationPermission();
    if (!allowed) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
