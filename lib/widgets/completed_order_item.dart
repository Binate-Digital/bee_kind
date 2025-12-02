import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedOrderItem extends StatelessWidget {
  final bool hideDate;

  // --- NEW PARAMS ---
  final String? productName;
  final int? quantity;
  final double? price;
  final String? status;
  final String? imageUrl;
  final String? date;

  const CompletedOrderItem({
    super.key,
    this.hideDate = false,
    this.productName,
    this.quantity,
    this.price,
    this.status,
    this.imageUrl,
    this.date,
  });

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
          // ---------- IMAGE ----------
          Container(
            width: 90.w,
            height: 90.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.yellow2, width: 1.w),
              color: AppColors.whiteColor,
              image: DecorationImage(
                image: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? NetworkImage(imageUrl!)
                    : AssetImage(AssetsPath.product) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ---------- TEXTS ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: productName ?? "N/A",
                fontSize: 18.sp,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),

              CustomText(text: "Qty: ${quantity ?? '--'}", fontSize: 18.sp),
              SizedBox(height: 10.h),

              Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    text: status ?? "Completed",
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 35.w),

          // ---------- PRICE + DATE ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(text: hideDate ? "" : "Date: ${date ?? '--'}"),
              SizedBox(height: 20.h),

              CustomText(
                text: price != null
                    ? "\$${price!.toStringAsFixed(2)}"
                    : "\$0.00",
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
