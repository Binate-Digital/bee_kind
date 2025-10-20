import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageContainer extends StatelessWidget {
  const PackageContainer({
    super.key,
    this.packageName,
    this.packageText,
    this.onTap,
  });
  final String? packageName;
  final String? packageText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main container
        Container(
          height: 650.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
          padding: EdgeInsets.only(bottom: 70.h), // space for button
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.yellow2, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== Heading =====
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.yellow2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                child: Center(
                  child: CustomText(
                    text: packageName,
                    fontSize: 24.sp,
                    weight: FontWeight.bold,
                    lineSpacing: 1.5,
                    textAlign: TextAlign.center,
                    fontColor: AppColors.whiteColor,
                  ),
                ),
              ),

              // ===== 4 Description Sections =====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Column(
                  children: List.generate(4, (idx) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: AppColors.yellow2,
                              size: 25.sp,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: CustomText(
                                text: packageText,
                                fontSize: 16.sp,
                                fontColor: AppColors.blackColor,
                                lineSpacing: 1.5,
                                textAlign: TextAlign.justify,
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),

                        // Divider (as container)
                        if (idx != 3)
                          Container(
                            height: 1,
                            color: AppColors.blackColor.withValues(alpha: 0.4),
                            margin: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 5.w,
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        // ===== Pay Now Button =====
        Positioned(
          bottom: 150.h,
          left: 20.w,
          right: 20.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.w),
            child: CustomButton(
              onTap: onTap,
              text: "Pay Now",
              verticalPadding: 18.h,
              borderColor: AppColors.blackColor,
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
