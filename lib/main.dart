import 'dart:convert';

import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/firebase_options.dart';
import 'package:bee_kind/services/notification_services.dart';
import 'package:bee_kind/services/push_notification_service.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/splash/splash_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.data}');
}

Future<void> onDidReceiveNotificationResponseHandler(
    NotificationResponse notificationResponse) async {
  // appPrint("onDidReceiveNotificationResponseHandler $notificationResponse || ${notificationResponse.payload}");
  var data = jsonDecode(notificationResponse.payload!);
  print("onDidReceiveNotificationResponseHandler decoded $data");
}
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponseHandler(
    NotificationResponse notificationResponse) {
  var data = jsonDecode(notificationResponse.payload!);
  print('onDidReceiveBackgroundNotificationResponseHandler $data');
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // WidgetsFlutterBinding.ensureInitialized();
  //test2
  Stripe.publishableKey = NetworkStrings.STRIPE_KEY;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  await Future.delayed(const Duration(seconds: 2));
  await FirebaseNotificationService().firebaseMessaging();


  await Validation.getFCMToken();
  // FirebaseMessaging.onBackgroundMessage(
  //   PushNotificationService.firebaseBackgroundHandler,
  // );

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs.init();
  Get.lazyPut(() => StoreController(), fenix: true);
  runApp(const BeeKind());
}

class BeeKind extends StatelessWidget {
  const BeeKind({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bee Kind',
        navigatorKey: StaticData.navigatorKey,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: AppColors.whiteColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.whiteColor,
          ),
          fontFamily: "Raleway",
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class StaticData {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
