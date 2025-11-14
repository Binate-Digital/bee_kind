import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static FirebaseMessagingService? _instance;
  static FirebaseMessaging? _firebaseMessaging;

  FirebaseMessagingService._();

  factory FirebaseMessagingService() {
    _instance ??= FirebaseMessagingService._();
    _firebaseMessaging ??= FirebaseMessaging.instance;
    return _instance!;
  }

  Future<String?> getToken() async {
    final settings = await _firebaseMessaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("Permission status: ${settings.authorizationStatus}");

    // Finally get the FCM token
    final token = await _firebaseMessaging!.getToken();
    log("FCM Token: $token");
    return token;
  }
}
