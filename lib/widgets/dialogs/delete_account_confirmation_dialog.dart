import 'package:bee_kind/core/role_type_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> deleteAccountConfirmationDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.w),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    decoration: BoxDecoration(
                      color: AppColors.yellow2,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "Delete Account",
                        fontSize: 22.sp,
                        fontColor: AppColors.blackColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.w,
                    top: 22.h,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 25.r,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35.h),

              Container(
                width: 130.w,
                height: 130.h,
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.yellow2, width: 2.w),
                ),
                child: Center(
                  child: Image.asset(
                    AssetsPath.delete,
                    width: 60.w,
                    height: 60.h,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: CustomText(
                  text: "Are you sure you want to delete your account?",
                  fontSize: 16.sp,
                  maxLines: 2,

                  fontColor: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 35.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    width: 160.w,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                    gradientColors: [
                      AppColors.whiteColor,
                      AppColors.whiteColor,
                    ],
                    borderColor: AppColors.blackColor,
                  ),
                  CustomButton(
                    width: 160.w,
                    onTap: () {
                      errorSnackBar("You've logged out!", context);
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RoleTypeScreen(showLogoutSnack: false),
                          ),
                          (route) => false,
                        );
                      });
                    },
                    text: "Delete",
                  ),
                ],
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      );
    },
  );
}
