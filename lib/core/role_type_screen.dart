import 'package:bee_kind/auth/sign_in_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/user_location_permission.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleTypeScreen extends StatefulWidget {
  const RoleTypeScreen({super.key});

  @override
  State<RoleTypeScreen> createState() => _RoleTypeScreenState();
}

class _RoleTypeScreenState extends State<RoleTypeScreen> {

@override
  void initState() {
    super.initState();
    UserLocation.handleLocationPermission();
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
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => SignInScreen())),
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
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => SignInScreen())),
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
