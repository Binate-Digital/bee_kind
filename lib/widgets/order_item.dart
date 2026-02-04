import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    this.hideButton = false,
    required this.onTap,
    this.verticalPadding,
    this.horizontalPadding,
    this.fontSize,

    // 🔥 New fields
    this.productName,
    this.quantity,
    this.price,
    this.status,
    this.imageUrl,
  });

  final bool hideButton;
  final VoidCallback onTap;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? fontSize;

  final String? productName;
  final int? quantity;
  final double? price;
  final String? status;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    print(status);
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
          ),
        ],
        color: AppColors.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// IMAGE
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.yellow2, width: 1.w),
                color: AppColors.whiteColor,
                image: DecorationImage(
                  image:
                      (imageUrl != null &&
                          imageUrl!.isNotEmpty &&
                          imageUrl != "null")
                      ? NetworkImage(imageUrl!)
                      : const AssetImage(AssetsPath.product),
                  fit: BoxFit.cover, // 🔥 FULL FILL
                ),
              ),
            ),
          ),

          // ClipRRect(
          //   borderRadius: BorderRadius.circular(20.r),
          //   child: Container(
          //     width: 100.w,
          //     height: 100.h,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20.r),
          //       border: Border.all(color: AppColors.yellow2, width: 1.w),
          //       color: AppColors.whiteColor,
          //       image: DecorationImage(
          //         image: imageUrl != null && imageUrl!.isNotEmpty
          //             ? NetworkImage(imageUrl!)
          //             : AssetImage(AssetsPath.product) as ImageProvider,
          //       ),
          //     ),
          //   ),
          // ),

          /// MIDDLE TEXT
          Container(
            width: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: productName ?? "N/A",
                  fontSize: fontSize ?? 18.sp,
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
                    child: CustomText(text: status ?? "N/A", fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 35.w),

          /// PRICE + BUTTON
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: price != null
                    ? "\$${price!.toStringAsFixed(2)}"
                    : "\$0.00",
                fontSize: 20.sp,
                fontColor: AppColors.yellow2,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),
              hideButton
                  ? SizedBox(width: 100.w)
                  : CustomButton(
                      onTap: onTap,
                      text: "Track Order",
                      width: 100.w,
                      height: 40.h,
                      fontSize: 13.sp,
                      horizontalPadding: 10.w,
                      verticalPadding: 5.h,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
