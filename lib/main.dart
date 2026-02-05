import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/firebase_options.dart';
import 'package:bee_kind/services/push_notification_service.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/splash/splash_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//test
  //test
  Stripe.publishableKey = NetworkStrings.STRIPE_KEY;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseMessaging.onBackgroundMessage(
    PushNotificationService.firebaseBackgroundHandler,
  );

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
