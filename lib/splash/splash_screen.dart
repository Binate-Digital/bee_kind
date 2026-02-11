import 'dart:async';
import 'dart:developer';

import 'package:bee_kind/core/role_type_screen.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../services/push_notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // PushNotificationService.initialize();
    // _getFCMToken();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleTypeScreen()),
      );
    });
  }

  Future<void> _getFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      log('FCM Token: $token');
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(AssetsPath.splashImage),
    );
  }
}
