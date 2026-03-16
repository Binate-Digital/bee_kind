import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<String?> showRespondDialog(BuildContext ctx, String? reviewId) async {
  TextEditingController responseController = TextEditingController();
  final storeController = Get.find<StoreController>();
  bool isLoading = false;

  return showDialog<String>(
    context: ctx,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 20.w,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Title ===
                Center(
                  child: CustomText(
                    text: "Respond to Review",
                    fontSize: 20.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.blackColor,
                  ),
                ),

                SizedBox(height: 20.h),

                // === Input Field ===
                CustomTextField(
                  hint: "Type your response...",
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
                      onTap: isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      text: "Cancel",
                      gradientColors: [
                        AppColors.whiteColor,
                        AppColors.whiteColor,
                      ],
                      borderColor: AppColors.blackColor,
                    ),
                    SizedBox(width: 10.w),
                    CustomButton(
                      width: 140.w,
                      onTap: isLoading
                          ? null
                          : () async {
                              if (responseController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please enter a response"),
                                  ),
                                );
                                return;
                              }

                              setState(() => isLoading = true);

                              final isSuccess = await storeController.addReplyToReview(
                                reviewId,
                                responseController.text.trim(),
                                context,
                              );

                              setState(() => isLoading = false);
                              if (isSuccess && context.mounted) {
                                Navigator.pop(context, responseController.text.trim());
                              }
                            },
                      text: isLoading ? "Sending..." : "Send",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
