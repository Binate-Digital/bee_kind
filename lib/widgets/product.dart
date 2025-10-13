import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 75.w),
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
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 140.w,
          child: Column(
            children: [
              Row(
            children: [
              CustomText(
                text: "Lorem Ipsum",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
                weight: FontWeight.bold,
              ),
              Spacer(),
              Row(
                children: [
                  Image.asset(AssetsPath.star, width: 18.w),
                  CustomText(
                    text: "4.8",
                    fontSize: 16.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              CustomText(
                text: "\$20.00",
                fontSize: 16.sp,
                fontColor: AppColors.yellow2,
                weight: FontWeight.bold,
              ),
            ],
          ),
            ],
          ),
        ),
      ],
    );
  }
}
