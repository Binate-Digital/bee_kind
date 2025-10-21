import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> cancelOrderDialog(BuildContext context) async {
  int? selectedReason;
  final TextEditingController descriptionController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                          child: Icon(
                            Icons.close,
                            size: 25.r,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  // Radio buttons for cancellation reasons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        // Changed my mind
                        _buildRadioOption(
                          context: context,
                          value: 0,
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          text: "Changed my mind",
                        ),
                        SizedBox(height: 12.h),

                        // Got a better price
                        _buildRadioOption(
                          context: context,
                          value: 1,
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          text: "Got a better price",
                        ),
                        SizedBox(height: 12.h),

                        // Other
                        _buildRadioOption(
                          context: context,
                          value: 2,
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          text: "Other",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Description text field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomTextField(
                      hint: "Description",
                      radius: 10.r,
                      controller: descriptionController,
                      maxlines: 5,
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // Submit button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: CustomButton(
                      onTap: () {
                        // Handle submit logic here
                        if (selectedReason == null) {
                          // Show error message
                          return;
                        }

                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      text: "Submit",
                      borderColor: AppColors.blackColor,
                      verticalPadding: 20.h,
                      horizontalPadding: 10.w,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
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
