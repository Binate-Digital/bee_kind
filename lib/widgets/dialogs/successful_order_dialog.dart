import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart'; // Add your assets path
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> successfulOrderDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.w),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 25.h),
                decoration: BoxDecoration(
                  color: AppColors.yellow2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Center(
                  child: CustomText(
                    text: "Order Successful!",
                    fontSize: 24.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 35.h),

              // Yellow circle with success image
              Container(
                width: 130.w,
                height: 130.h,
                decoration: BoxDecoration(
                  color: AppColors.yellow1,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.yellow2, width: 2.w),
                ),
                child: Center(
                  child: Image.asset(
                    AssetsPath.success, // Replace with your success image asset
                    width: 60.w,
                    height: 60.h,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Success message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: CustomText(
                  text:
                      "Lorem ipsum dolor sit amet consectetur elit odio ac arcu mi felis",
                  fontSize: 16.sp,
                  maxLines: 2,

                  fontColor: AppColors.blackColor,
                  textAlign: TextAlign.justify,
                ),
              ),

              SizedBox(height: 35.h),

              // Back To Store button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                child: CustomButton(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BaseView(currIndex: 2)),
                    );
                    // Add your navigation logic here
                  },
                  text: "Track Your Order",
                  borderColor: AppColors.blackColor,
                  verticalPadding: 18.h,
                  horizontalPadding: 10.w,
                  fontSize: 18.sp,
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      );
    },
  );
}
