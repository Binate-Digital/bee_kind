// ignore_for_file: use_build_context_synchronously

import 'package:bee_kind/auth/sign_in_screen.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/user_location_permission.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleTypeScreen extends StatefulWidget {
  const RoleTypeScreen({super.key, this.showLogoutSnack = false});
  final bool showLogoutSnack;

  @override
  State<RoleTypeScreen> createState() => _RoleTypeScreenState();
}

class _RoleTypeScreenState extends State<RoleTypeScreen> {
  final prefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    UserLocation.handleLocationPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      if (widget.showLogoutSnack) {
        errorSnackBar("You've been logged out!", context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.whiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 180.h),
              child: SizedBox(
                width: 250.w,
                child: Image.asset(AssetsPath.icon),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: CustomButton(
                onTap: () async {
                  await prefs.setString('role', 'user');
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => SignInScreen()));
                },
                text: "Login As User",
                borderColor: AppColors.blackColor,
                verticalPadding: 18.h,
                horizontalPadding: 10.w,
                fontSize: 18.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomButton(
                onTap: () async {
                  await prefs.setString('role', 'vendor');
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => SignInScreen()));
                },
                borderColor: AppColors.blackColor,
                text: "Login as Store Owner",
                verticalPadding: 18.h,
                horizontalPadding: 10.w,
                fontSize: 18.sp,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
