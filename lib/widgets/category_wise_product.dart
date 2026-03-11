import 'package:bee_kind/models/response_models/get_products_by_category_response_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_extended_image.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWiseProduct extends StatelessWidget {
  const CategoryWiseProduct({super.key, this.fromHome = false, this.product});

  final bool fromHome;
  final ProductByCategoryData? product;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 110.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.yellow2, width: 1.w),
                color: AppColors.whiteColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: CustomExtendedImageWidget(
                  imagePath:
                      (product?.productImages != null &&
                          product!.productImages!.isNotEmpty)
                      ? product!.productImages!.first
                      : AssetsPath.product,
                  imageType:
                      (product?.productImages != null &&
                          product!.productImages!.isNotEmpty)
                      ? MediaPathType.NETWORK.name
                      : MediaPathType.ASSETS.name,
                  imagePlaceholder: AssetsPath.product,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Container(
            width: 160.w,
            padding: EdgeInsets.only(left: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                CustomText(
                  text: product?.productName ?? "Lorem Ipsum",
                  fontSize: 20.sp,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: fromHome
                      ? "Store: ${product?.businessName ?? "Lorem ipsum"}"
                      : "Qty: ${product?.quantity ?? "0"}",
                  fontSize: 18.sp,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 10.h),

              CustomText(
                text: "\$${product?.price.toString()}",
                fontSize: 20.sp,
                lineThrough: product?.isDiscountAvailable == true
                    ? true
                    : false,
                fontColor: product?.isDiscountAvailable == true
                    ? AppColors.shimmerHighlightColor
                    : AppColors.yellow2,
                weight: FontWeight.bold,
              ),
              product?.isDiscountAvailable == true
                  ? CustomText(
                      text: "\$${product?.afterDiscountPrice.toString()}",
                      fontSize: 20.sp,
                      fontColor: AppColors.yellow2,
                      weight: FontWeight.bold,
                    )
                  : SizedBox(),
              SizedBox(height: 55.h),


              fromHome
                  ? CustomText(
                      text: "${product?.distanceInKm?.toStringAsFixed(1) ?? 0.toStringAsFixed(1)} Miles Away",
                      fontSize: 16.sp,
                      fontColor: AppColors.yellow2,
                      weight: FontWeight.bold,

                    )
                  : SizedBox(width: 85.w),
            ],
          ),
        ],
      ),
    );
  }
}
