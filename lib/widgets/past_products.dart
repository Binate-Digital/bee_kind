import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/models/response_models/vendor_orders_response_model.dart'
    as vorder;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PastProducts extends StatelessWidget {
  const PastProducts({
    super.key,
    this.isCurrent = false,
    this.isCancelled = false,
    this.vendorOrder,
  });
  final bool isCurrent;
  final bool isCancelled;
  final vorder.VendorOrder? vendorOrder;

  String _resolveImageUrl(String? image) {
    if (image == null)
      return NetworkStrings.NETWORK_IMAGE_BASE_URL +
          'uploads/images/default.png';
    if (image.startsWith('http')) return image;
    if (image.startsWith('/'))
      return NetworkStrings.NETWORK_IMAGE_BASE_URL + image.substring(1);
    return NetworkStrings.NETWORK_IMAGE_BASE_URL + image;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  ImageProvider _getProductImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(_resolveImageUrl(imageUrl));
    }
    return AssetImage(AssetsPath.product);
  }

  @override
  Widget build(BuildContext context) {
    // Get first item from vendor order if available
    final firstItem = vendorOrder?.items?.isNotEmpty == true
        ? vendorOrder!.items!.first
        : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.15),
            blurRadius: 25.r,
            offset: const Offset(0, 5),
            spreadRadius: 0,
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
                image: _getProductImage(firstItem?.productImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // === Product Details ===
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: firstItem?.productName ?? "Lorem Ipsum",
                  fontSize: 16.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.blackColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: vendorOrder?.user?.name ?? "John Smith",
                  fontSize: 14.sp,
                  fontColor: AppColors.blackColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  text: "Order Date: ${_formatDate(vendorOrder?.createdAt)}",
                  fontSize: 14.sp,
                  fontColor: AppColors.blackColor,
                ),
                if (!isCurrent)
                  CustomText(
                    text: "Status: ${isCancelled ? "Cancelled" : "Completed"}",
                    fontSize: 14.sp,
                    fontColor: AppColors.blackColor,
                  ),
              ],
            ),
          ),

          // === Price & Quantity ===
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomText(
                text:
                    "\$${vendorOrder?.totalAmount?.toStringAsFixed(2) ?? "0.00"}",
                fontSize: 18.sp,
                fontColor: AppColors.yellow2,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: "Qty: ${firstItem?.quantity ?? 0}",
                fontSize: 14.sp,
                fontColor: AppColors.blackColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
