import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> addNewAccountDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent accidental dismissal
    builder: (context) {
      return StatefulBuilder(
        builder: (context, child) {
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
                Stack(
                  children: [
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
                          text: "Add New Account",
                          fontSize: 22.sp,
                          fontColor: AppColors.blackColor,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      top: 17.h,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          size: 20.r,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomTextField(hint: "Account Holder Name"),
                ),

                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomTextField(hint: "Account Number"),
                ),

                SizedBox(height: 30.h),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomTextField(hint: "Exp Date"),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomTextField(hint: "CVV"),
                      ),
                    ),
                  ],
                ),

                // Continue button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 20.h,
                  ),
                  child: CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Add Account",
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
    },
  );
}
