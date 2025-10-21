// ignore_for_file: deprecated_member_use

import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> orderCompleteConfirmationDialog(BuildContext context) async {
  String selectedOption = "Yes";

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.w),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // === Header ===
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
                child: CustomText(
                  text: "Confirm Order Completion",
                  fontSize: 20.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // === Confirmation Text ===
                    Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: AppColors.yellow1,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.yellow2,
                          width: 2.w,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          AssetsPath.deliveryPerson,
                          width: 70.w,
                          height: 70.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    CustomText(
                      text:
                          "Have you confirmed order delivery with\nthe delivery personnel?",
                      fontSize: 16.sp,
                      fontColor: AppColors.blackColor,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 25.h),

                    // === Radio Buttons ===
                    StatefulBuilder(
                      builder: (context, setStateDialog) {
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: "Yes",
                                      groupValue: selectedOption,
                                      activeColor: AppColors.yellow2,
                                      materialTapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, // 👈 smaller touch area
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          selectedOption = value!;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ), // 👈 control spacing manually
                                    CustomText(
                                      text: "Yes",
                                      fontSize: 16.sp,
                                      fontColor: AppColors.blackColor,
                                    ),
                                  ],
                                ),
                            
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: "No",
                                      groupValue: selectedOption,
                                      activeColor: AppColors.yellow2,
                                      materialTapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, // 👈 smaller touch area
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          selectedOption = value!;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ), // 👈 control spacing manually
                                    CustomText(
                                      text: "No",
                                      fontSize: 16.sp,
                                      fontColor: AppColors.blackColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 30.h),

                    // === Complete Button ===
                    CustomButton(
                      text: "Complete Order",
                      onTap: () {
                        if (selectedOption == "Yes") {
                          Navigator.pop(context, true); // ✅ Confirmed
                        } else {
                          // ❌ Not confirmed
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
