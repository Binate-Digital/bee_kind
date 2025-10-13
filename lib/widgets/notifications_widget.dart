import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.15),
              blurRadius: 25.r,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
          color: AppColors.whiteColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: CircleAvatar(
                      radius: 28.r,
                      backgroundColor: AppColors.yellow1,
                      child: Image.asset(AssetsPath.frame, width: 25.w),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Lorem Ipsum",
                            fontSize: 18.sp,
                            fontFamily: "Raleway",
                            weight: FontWeight.bold,
                            fontColor: AppColors.blackColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: CustomText(
                              text: "Lorem ipsum dolor sit amet consectetur",
                              fontSize: 16.sp,
                              fontFamily: "Raleway",
                              fontColor: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
