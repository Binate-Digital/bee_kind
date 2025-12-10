import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bee_kind/models/response_models/vendor_pending_orders_response_model.dart'
    as pendingOrder;
import 'package:bee_kind/utils/network_strings.dart';

class OrderRequest extends StatelessWidget {
  const OrderRequest({super.key, this.onAccept, this.onReject, this.order});

  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final pendingOrder.PendingOrder? order;

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
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.yellow2, width: 1.w),
              color: AppColors.whiteColor,
              image: DecorationImage(
                image:
                    order != null &&
                        order?.items != null &&
                        order!.items!.isNotEmpty
                    ? NetworkImage(
                        _resolveImageUrl(order!.items!.first.productImage),
                      )
                    : AssetImage(AssetsPath.product),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // === Product Details ===
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text:
                      order != null &&
                          order?.items != null &&
                          order!.items!.isNotEmpty
                      ? (order?.items!.first.productName ?? 'Product')
                      : "Lorem Ipsum",
                  fontSize: 16.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.blackColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: order != null && order?.userAddress != null
                      ? (order?.userAddress!.address ?? 'Customer')
                      : "John Smith",
                  fontSize: 14.sp,
                  fontColor: AppColors.blackColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  text:
                      order != null &&
                          order?.items != null &&
                          order!.items!.isNotEmpty
                      ? "Qty: ${order?.items!.first.quantity?.toString() ?? '0'}"
                      : "Qty: 01",
                  fontSize: 14.sp,
                  fontColor: AppColors.blackColor,
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                width: 100.w,
                text: "Accept",
                onTap: onAccept,
                verticalPadding: 10.h,
                fontSize: 12.sp,
                borderColor: AppColors.blackColor,
                gradientColors: [AppColors.yellow1, AppColors.yellow2],
              ),
              SizedBox(height: 8.h),
              CustomButton(
                width: 100.w,
                text: "Reject",
                onTap: onReject,
                verticalPadding: 10.h,
                fontSize: 12.sp,
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

String _resolveImageUrl(String? image) {
  if (image == null) {
    return '${NetworkStrings.NETWORK_IMAGE_BASE_URL}uploads/images/default.png';
  }
  if (image.startsWith('http')) {
    return image;
  }
  if (image.startsWith('/')) {
    return '${NetworkStrings.NETWORK_IMAGE_BASE_URL}${image.substring(1)}';
  }
  return '${NetworkStrings.NETWORK_IMAGE_BASE_URL}$image';
}
