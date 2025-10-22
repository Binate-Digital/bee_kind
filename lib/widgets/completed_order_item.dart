import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedOrderItem extends StatefulWidget {
  const CompletedOrderItem({super.key, this.hideDate = false});
  final bool hideDate;

  @override
  State<CompletedOrderItem> createState() => _CompletedOrderItemState();
}

class _CompletedOrderItemState extends State<CompletedOrderItem> {
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
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 45.w),
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
                fontSize: 18.sp,
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
                  child: CustomText(text: "Completed", fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(width: 35.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.hideDate
                  ? CustomText(
                      text: "Date: 19-06-2025",
                      fontColor: AppColors.whiteColor,
                    )
                  : CustomText(text: "Date: 19-06-2025"),
              SizedBox(height: 20.h),
              CustomText(
                text: "\$20.00",
                fontSize: 20.sp,
                fontColor: AppColors.yellow2,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ],
      ),
    );
  }
}
