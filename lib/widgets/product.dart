import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Product extends StatelessWidget {
  const Product({
    super.key,
    this.stockStatus,
    this.isDiscountAvailable = false,
    this.price,
    this.afterDiscountPrice,
    this.productName,
  });
  final String? stockStatus;
  final bool isDiscountAvailable;
  final int? price;
  final int? afterDiscountPrice;
  final String? productName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120.h,
          child: Stack(
            children: [
              Container(
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
              stockStatus == "out-of-stock"
                  ? Positioned(
                      top: 10.h,
                      left: 55.w,
                      child: CustomText(text: "Out Of Stock"),
                    )
                  : Offstage(),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 95.w,
                    child: Center(
                      child: CustomText(
                        text: productName ?? "Lorem Ipsum",
                        fontSize: 16.sp,
                        fontColor: AppColors.blackColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Row(
                    children: [
                      Image.asset(AssetsPath.star, width: 15.w),
                      CustomText(
                        text: "4.8",
                        fontSize: 15.sp,
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
                    text:
                        "\$${isDiscountAvailable == true ? afterDiscountPrice : price}",
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
