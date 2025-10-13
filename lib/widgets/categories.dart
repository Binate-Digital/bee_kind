import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            width: 130.w,
            height: 130.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.yellow2, width: 1.w),
              color: AppColors.whiteColor,
              image: DecorationImage(
                image: AssetImage(AssetsPath.product),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: "All",
            fontSize: 22.sp,
            fontColor: AppColors.yellow2,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
