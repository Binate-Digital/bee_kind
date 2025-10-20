import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/splash/splash_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bee Kind',
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
