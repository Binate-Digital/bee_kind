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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("background message received");
  print("message.data = ${message.data}");
  print("message.notification?.title = ${message.notification?.title}");
  print("message.notification?.body = ${message.notification?.body}");
}

Future<void> onDidReceiveNotificationResponseHandler(
    NotificationResponse notificationResponse) async {
  print("notification tapped in foreground/background");
  print("raw payload = ${notificationResponse.payload}");

  if (notificationResponse.payload != null &&
      notificationResponse.payload!.isNotEmpty) {
    final data = jsonDecode(notificationResponse.payload!);
    printNotificationData(data, source: "local_notification_tap");
  }
}
@pragma('vm:entry-point')
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponseHandler(
    NotificationResponse notificationResponse) {
  print("notification tapped from background isolate");
  print("raw payload = ${notificationResponse.payload}");

  if (notificationResponse.payload != null &&
      notificationResponse.payload!.isNotEmpty) {
    final data = jsonDecode(notificationResponse.payload!);
    printNotificationData(data, source: "background_notification_tap");
  }
}

void printNotificationData(Map<String, dynamic> data, {String? source}) {
  print("========== notification payload (${source ?? 'unknown'}) ==========");
  print(data);
  print("type: ${data['type']}");
  print("screen: ${data['screen']}");
  print("id: ${data['id']}");
  print("=======================================================");
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey = NetworkStrings.STRIPE_KEY;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Future.delayed(const Duration(seconds: 2));
  await FirebaseNotificationService().firebaseMessaging();
  await Validation.getFCMToken();
  await SharedPrefs.init();

  Get.lazyPut(() => StoreController(), fenix: true);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // app in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("foreground message received");
    print("message.data = ${message.data}");
    print("title = ${message.notification?.title}");
    print("body = ${message.notification?.body}");
  });

  // app opened from background by tapping notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("notification tapped -> app opened from background");
    print("message.data = ${message.data}");
    printNotificationData(message.data, source: "onMessageOpenedApp");

    // later use this for navigation
    // handleNotificationNavigation(message.data);
  });

  // app opened from terminated state by tapping notification
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    print("app opened from terminated state via notification");
    print("message.data = ${initialMessage.data}");
    printNotificationData(initialMessage.data, source: "getInitialMessage");

    // later use this for navigation
    // handleNotificationNavigation(initialMessage.data);
  }

  runApp(const BeeKind());
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
//   // WidgetsFlutterBinding.ensureInitialized();
//   //test2
//   Stripe.publishableKey = NetworkStrings.STRIPE_KEY;
//
//   SystemChrome.setSystemUIOverlayStyle(
//     SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//   );
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   // if (Firebase.apps.isEmpty) {
//   //   await Firebase.initializeApp(
//   //     options: DefaultFirebaseOptions.currentPlatform,
//   //   );
//   // }
//
//   await Future.delayed(const Duration(seconds: 2));
//   await FirebaseNotificationService().firebaseMessaging();
//
//
//   await Validation.getFCMToken();
//   // FirebaseMessaging.onBackgroundMessage(
//   //   PushNotificationService.firebaseBackgroundHandler,
//   // );
//
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await SharedPrefs.init();
//   Get.lazyPut(() => StoreController(), fenix: true);
//   runApp(const BeeKind());
// }

class BeeKind extends StatelessWidget {
  const BeeKind({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return GetMaterialApp(
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
        );
      },
    );
  }
}


class StaticData {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
