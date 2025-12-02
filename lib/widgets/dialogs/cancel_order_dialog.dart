import 'dart:developer';

import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> cancelOrderDialog(BuildContext context, String orderId) async {
  int selectedReason = 0;
  final TextEditingController descriptionController = TextEditingController();
  final controller = Get.find<StoreController>();

  // final List<String> reasonLabels = [
  //   "Changed my mind",
  //   "Got a better price",
  //   "Other",
  // ];

  final List<String> reasonKeys = [
    "changed-mind",
    "found-better-price",
    "other",
  ];

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final bool showDescription = selectedReason == 2; // "Other"

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20.w),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HEADER
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
                              text: "Cancel Order",
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
                            child: Icon(Icons.close, size: 25.r),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15.h),

                    // REASONS
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          _buildRadioOption(
                            context: context,
                            value: 0,
                            selectedValue: selectedReason,
                            onChanged: (value) {
                              setState(() {
                                selectedReason = value!;
                              });
                            },
                            text: "Changed my mind",
                          ),
                          SizedBox(height: 12.h),

                          _buildRadioOption(
                            context: context,
                            value: 1,
                            selectedValue: selectedReason,
                            onChanged: (value) {
                              setState(() {
                                selectedReason = value!;
                              });
                            },
                            text: "Got a better price",
                          ),
                          SizedBox(height: 12.h),

                          _buildRadioOption(
                            context: context,
                            value: 2,
                            selectedValue: selectedReason,
                            onChanged: (value) {
                              setState(() {
                                selectedReason = value!;
                              });
                            },
                            text: "Other",
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // DESCRIPTION — SHOW ONLY WHEN "Other"
                    if (showDescription)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomTextField(
                          hint: "Describe your reason",
                          radius: 10.r,
                          controller: descriptionController,
                          maxlines: 5,
                        ),
                      ),

                    if (showDescription) SizedBox(height: 25.h),

                    // SUBMIT BUTTON
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Obx(
                        () => CustomButton(
                          text: "Submit",
                          fontSize: 18.sp,
                          borderColor: AppColors.blackColor,
                          verticalPadding: 20.h,
                          isLoading: controller.isLoading.value,
                          horizontalPadding: 10.w,
                          onTap: () async {
                            if (selectedReason == 2 &&
                                descriptionController.text.trim().isEmpty) {
                              AppDialogs.showToast(
                                "Please describe your reason",
                              );
                              return;
                            }

                            log(
                              "SELECTED REASON: ${reasonKeys[selectedReason]}",
                            );

                            await controller.cancelOrder(
                              orderId: orderId,
                              reason: reasonKeys[selectedReason],
                              description: descriptionController.text.trim(),
                              context: context,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildRadioOption({
  required BuildContext context,
  required int value,
  required int? selectedValue,
  required ValueChanged<int?> onChanged,
  required String text,
}) {
  return GestureDetector(
    onTap: () {
      onChanged(value);
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedValue == value
                    ? AppColors.yellow2
                    : Colors.grey.shade500,
                width: 2.w,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: selectedValue == value ? 10.w : 0,
                height: selectedValue == value ? 10.h : 0,
                decoration: BoxDecoration(
                  color: AppColors.yellow2,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          CustomText(
            text: text,
            fontSize: 18.sp,
            fontColor: AppColors.blackColor,
            weight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}
