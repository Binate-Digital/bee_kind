import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Android notification channel
  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.high,
    playSound: true,
  );

  /// Background handler (MUST be top-level or static)
  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Background Message: ${message.messageId}');
  }

  /// Entry point to initialize notifications
  static Future<void> initialize() async {
    await _requestPermission();
    await _initializeLocalNotifications();
    await _createAndroidChannel();
    await _getToken();
    _listenTokenRefresh();
    _foregroundHandler();
    _onMessageOpenedApp();
    _handleTerminatedState();
  }

  /// Request notification permission
  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('Permission status: ${settings.authorizationStatus}');
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings =
    InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(settings);
  }

  /// Create Android notification channel
  static Future<void> _createAndroidChannel() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Get FCM token
  static Future<void> _getToken() async {
    final token = await _messaging.getToken();
    log('FCM Token: $token');
  }

  /// Listen token refresh
  static void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) {
      log('FCM Token Refreshed: $token');
    });
  }

  /// Foreground notification handler
  static void _foregroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground Message: ${message.notification?.title}');

      final notification = message.notification;
      final android = notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
          ),
        );
      }
    });
  }

  /// App opened via notification (background → foreground)
  static void _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification Clicked (Background)');
    });
  }

  /// App launched from terminated state
  static Future<void> _handleTerminatedState() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      log('Notification Clicked (Terminated)');
    }
  }
}
