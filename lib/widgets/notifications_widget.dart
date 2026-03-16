import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({
    super.key,
    this.title,
    this.message,
    this.time,
    this.type,
    this.onTap,
  });

  final String? title;
  final String? message;
  final String? time;
  final String? type;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: GestureDetector(
        onTap: onTap,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: title ?? "Notification",
                                  fontSize: 18.sp,
                                  fontFamily: "Raleway",
                                  weight: FontWeight.bold,
                                  fontColor: AppColors.blackColor,
                                ),
                                CustomText(
                                  text: time ?? "Notification",
                                  fontSize: 18.sp,
                                  fontFamily: "Raleway",
                                  weight: FontWeight.normal,
                                  fontColor: AppColors.blackColor,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomText(
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                                text: message ?? "No message",
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
      ),
    );
  }
}
