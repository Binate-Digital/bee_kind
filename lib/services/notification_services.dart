import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../main.dart';

class FirebaseNotificationService{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  firebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        // description
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        enableLights: true,
        enableVibration: true);
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsiOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );


    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsiOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
        onDidReceiveNotificationResponseHandler,
        onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponseHandler);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FirebaseMessaging.onMessage.listen ${message.data}");
      showFlutterNotification(message);
    });
  }


  void showFlutterNotification(RemoteMessage message) {

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        // description
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        enableLights: true,
        enableVibration: true);

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                importance: Importance.max,
                priority: Priority.max,
                icon: "@mipmap/ic_launcher",
              ),
              iOS: const DarwinNotificationDetails(
                presentSound: true,
                presentBadge: true,
                presentAlert: true,
                interruptionLevel: InterruptionLevel.timeSensitive,
              )),
          payload: jsonEncode(message.data));
    }
    else if (Platform.isIOS) {
      // flutterLocalNotificationsPlugin.show(
      //   notification.hashCode,
      //   notification?.title,
      //   notification?.body,
      //   payload: jsonEncode(message.data),
      //   const NotificationDetails(
      //       iOS: DarwinNotificationDetails(
      //         presentSound: true,
      //         presentBadge: true,
      //         presentAlert: true,
      //         interruptionLevel: InterruptionLevel.timeSensitive,
      //       )),
      // );
    }
  }
}