import 'package:bee_kind/auth/introduction_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showSuccessDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent accidental dismissal
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header container with title
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColors.yellow2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Center(
                child: CustomText(
                  text: "Successful",
                  fontSize: 22.sp,
                  fontColor: AppColors.whiteColor,
                  weight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // White checkmark inside green circle
            Icon(Icons.check_circle, color: Colors.green, size: 140.w),

            SizedBox(height: 20.h),

            // Success message
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomText(
                text:
                    "You have completed your profile set up\n\n successfully!",
                fontSize: 18.sp,
                fontColor: AppColors.blackColor,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 30.h),

            // Continue button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: CustomButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => IntroductionScreen()),
                  );
                },
                text: "Continue",
                borderColor: AppColors.blackColor,
                verticalPadding: 20.h,
                horizontalPadding: 10.w,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      );
    },
  );
}
