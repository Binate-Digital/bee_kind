import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showDiscountDialog(BuildContext ctx) async {
  TextEditingController discountController = TextEditingController();

  showDialog(
    context: ctx,
    barrierDismissible: false,
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
            // === Header ===
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
                  text: "Add Discounted Price",
                  fontSize: 22.sp,
                  fontColor: AppColors.whiteColor,
                  weight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // === Discounted Price Field ===
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomTextField(
                hint: "Discounted Price",
                controller: discountController,
                keyboardType: TextInputType.number,
              ),
            ),

            SizedBox(height: 15.h),

            // === Info Text ===
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomText(
                text:
                    "The discounted price will be shown on the\nproduct information page along with %\ndiscount.",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
                textAlign: TextAlign.start,
              ),
            ),

            SizedBox(height: 30.h),

            // === Buttons ===
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      gradientColors: [
                        AppColors.whiteColor,
                        AppColors.whiteColor,
                      ],
                      textColor: Colors.black,
                      borderColor: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        final discount = discountController.text.trim();
                        if (discount.isNotEmpty) {
                          Navigator.pop(context, discount);
                        }
                      },
                      text: "Add",
                      borderColor: AppColors.blackColor,
                      verticalPadding: 18.h,
                      horizontalPadding: 10.w,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      );
    },
  );
}
