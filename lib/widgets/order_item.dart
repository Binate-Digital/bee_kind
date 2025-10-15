import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, this.hideButton = false, required this.onTap});
  final bool hideButton;
  final VoidCallback onTap;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
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
            padding: EdgeInsets.symmetric(vertical: 55.h, horizontal: 55.w),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Lorem Ipsum",
                fontSize: 20.sp,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),
              CustomText(text: "Qty:01", fontSize: 18.sp),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(text: "In Delivery", fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(width: 35.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: "\$20.00",
                fontSize: 20.sp,
                fontColor: AppColors.yellow2,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),
              widget.hideButton ? SizedBox(width: 100.w) : CustomButton(
                onTap: widget.onTap,
                text: "Track Order",
                width: 100.w,
                fontSize: 13.sp,
                horizontalPadding: 10.w,
                verticalPadding: 15.h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
