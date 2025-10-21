import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderRequest extends StatelessWidget {
  const OrderRequest({super.key, this.onAccept, this.onReject});

  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.15),
            blurRadius: 25.r,
            offset: const Offset(0, 5),
          ),
        ],
        color: AppColors.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // === Product Image ===
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

          SizedBox(width: 10.w),

          // === Product Details ===
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Lorem Ipsum",
                fontSize: 18.sp,
                weight: FontWeight.bold,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: "John Smith",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              CustomText(
                text: "Qty: 01",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
            ],
          ),

          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                width: 120.w,
                text: "Accept",
                onTap: onAccept,
                verticalPadding: 12.h,
                fontSize: 14.sp,
                borderColor: AppColors.blackColor,
                gradientColors: [AppColors.yellow1, AppColors.yellow2],
              ),
              SizedBox(height: 10.h),
              CustomButton(
                width: 120.w,
                text: "Reject",
                onTap: onReject,
                verticalPadding: 12.h,
                fontSize: 14.sp,
                borderColor: AppColors.blackColor,
                gradientColors: [AppColors.whiteColor, AppColors.whiteColor],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
