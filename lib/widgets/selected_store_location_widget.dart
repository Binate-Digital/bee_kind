import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedStoreLocation extends StatelessWidget {
  const SelectedStoreLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(30.r)),
        border: Border.all(color: AppColors.blackColor, width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            width: 90.w,
            height: 90.h,
            decoration: BoxDecoration(shape: BoxShape.circle),
            margin: EdgeInsets.symmetric(vertical: 15.h),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.yellow2, width: 2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(AssetsPath.placeholder),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomText(
                      text: "Lorem Ipsum",
                      fontSize: 22.sp,
                      fontColor: AppColors.yellow2,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        Image.asset(AssetsPath.location, width: 17.w),
                        Padding(
                          padding: EdgeInsets.only(left: 11.h),
                          child: CustomText(
                            text: "Lorem ipsum raod street 26",
                            fontSize: 18.sp,
                            fontColor: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        Image.asset(AssetsPath.clock, width: 19.w),
                        Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: CustomText(
                            text: "9 AM To 6PM",
                            fontSize: 18.sp,
                            fontColor: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        Image.asset(AssetsPath.phone, width: 20.w),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomText(
                            text: "+123-456-7890",
                            fontSize: 18.sp,
                            fontColor: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
