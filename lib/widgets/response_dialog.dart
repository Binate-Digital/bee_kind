import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showRespondDialog(BuildContext ctx) async {
  TextEditingController responseController = TextEditingController();

  showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Title ===
            Center(
              child: CustomText(
                text: "Respond to John Smith",
                fontSize: 20.sp,
                weight: FontWeight.bold,
                fontColor: AppColors.blackColor,
              ),
            ),

            SizedBox(height: 20.h),

            // === Input Field ===
            CustomTextField(
              hint: "Type here...",
              controller: responseController,
              maxlines: 5,
            ),

            SizedBox(height: 30.h),

            // === Action Buttons ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  width: 140.w,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: "Cancel",
                  gradientColors: [AppColors.whiteColor, AppColors.whiteColor],
                  borderColor: AppColors.blackColor,
                ),
                SizedBox(width: 10.w),
                CustomButton(
                  width: 140.w,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: "Send",
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
