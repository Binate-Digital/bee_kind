import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushTokenService {
  static Future<String?> getFcmTokenSafe() async {
    final messaging = FirebaseMessaging.instance;

    // Ask permission (iOS)
    if (Platform.isIOS) {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return null; // user denied notifications
      }
    }

    // iOS: wait until APNs token exists, then get FCM token
    if (Platform.isIOS) {
      String? apns = await messaging.getAPNSToken();

      int tries = 0;
      while (apns == null && tries < 10) {
        await Future.delayed(const Duration(milliseconds: 400));
        apns = await messaging.getAPNSToken();
        tries++;
      }

      if (apns == null) {
        // APNs still not ready (common if capabilities/config missing)
        return null;
      }
    }

    print("messaging.getToken();messaging.getToken();${messaging.getToken()}");
    // Now FCM token should work
    return await messaging.getToken();
  }
}
