import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ 1. Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('⚠️ Location services are disabled.');
      await Geolocator.openLocationSettings();
      // Give user time to enable and recheck
      await Future.delayed(const Duration(seconds: 2));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
    }

    // ✅ 2. Check existing permission status
    permission = await Geolocator.checkPermission();

    // Denied (not forever)
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('⚠️ Location permission denied. Opening app settings...');
        await Geolocator.openAppSettings();
        // Wait for user to return and recheck
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
        '🚫 Location permission permanently denied. Opening settings...',
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

    // ✅ 3. Permission granted
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
}
