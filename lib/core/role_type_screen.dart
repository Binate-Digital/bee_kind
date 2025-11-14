import 'package:bee_kind/controllers/role_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RoleTypeScreen extends StatelessWidget {
  const RoleTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoleController controller = Get.put(RoleController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
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
                onTap: () => controller.selectRole('user'),
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
                onTap: () => controller.selectRole('vendor'),
                text: "Login as Store Owner",
                borderColor: AppColors.blackColor,
                verticalPadding: 18.h,
                horizontalPadding: 10.w,
                fontSize: 18.sp,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
