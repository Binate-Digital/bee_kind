import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String> showStockBottomSheet(
  BuildContext context,
  String selectedOption,
  List<String> options,
) async {
  String result = selectedOption;

  final returned = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.whiteColor,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      String tempSelected = selectedOption; // temp for live selection

      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    text: "Select Stock Status",
                    fontSize: 20.sp,
                    weight: FontWeight.bold,
                    fontColor: Colors.black,
                  ),
                  SizedBox(height: 15.h),

                  // ==== Options List ====
                  ...options.map((option) {
                    final isSelected = option == tempSelected;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setModalState(() {
                          tempSelected = option;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 8.w,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.yellow2
                                    : AppColors.whiteColor,
                                border: Border.all(
                                  color: AppColors.yellow2,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            CustomText(
                              text: option,
                              fontColor: Colors.black,
                              fontSize: 16.sp,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 25.h),
                  CustomButton(
                    text: "Choose",
                    onTap: () => Navigator.pop(context, tempSelected),
                    // 👆 Return the selected option!
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  // 👇 Safe null handling — fallback to previous value
  result = returned ?? selectedOption;
  debugPrint("result: $result");
  return result;
}
