import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationBar extends StatelessWidget {
  final VoidCallback onTap;
  final String address;
  final bool isPickup; // true = Pick Up, false = Drop Off

  const LocationBar({
    super.key,
    required this.onTap,
    required this.address,
    this.isPickup = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.yellow2, width: 1.w),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0, 2),
              blurRadius: 4.r,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 📍 Address Text
            Expanded(
              flex: 3,
              child: CustomText(
                text: address,
                fontColor: AppColors.blackColor,
                fontSize: 16.sp,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Separator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                width: 1.5.w,
                height: 20.h,
                color: AppColors.yellow2,
              ),
            ),

            // Pick Up / Drop Off text
            CustomText(
              text: isPickup ? "Pick Up" : "Drop Off",
              fontSize: 16.sp,
              fontColor: AppColors.yellow2,
              weight: FontWeight.bold,
            ),

            // Separator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                width: 1.5.w,
                height: 20.h,
                color: AppColors.yellow2,
              ),
            ),

            // 📍 Location Icon
            Image.asset(
              AssetsPath.location,
              width: 22.w,
              height: 22.h,
              color: AppColors.yellow2,
            ),
          ],
        ),
      ),
    );
  }
}
