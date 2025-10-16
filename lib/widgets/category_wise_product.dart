import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWiseProduct extends StatelessWidget {
  const CategoryWiseProduct({super.key, this.showDistance = true});
  final bool showDistance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 50.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.yellow2, width: 1.w),
              color: AppColors.whiteColor,
              image: DecorationImage(
                image: AssetImage(AssetsPath.product),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Lorem Ipsum",
                  fontSize: 20.sp,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 10.h),
                CustomText(text: "Store: Lorem ipsum store", fontSize: 18.sp),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "\$20.00",
                fontSize: 20.sp,
                fontColor: AppColors.yellow2,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 55.h),
              showDistance
                  ? CustomText(
                      text: "14 Miles Away",
                      fontSize: 16.sp,
                      fontColor: AppColors.yellow2,
                      weight: FontWeight.bold,
                    )
                  : SizedBox(height: 10.h, width: 85.w),
            ],
          ),
        ],
      ),
    );
  }
}
