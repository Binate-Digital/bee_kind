import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../models/response_models/get_stores_response_model.dart';

class SelectedStoreLocation extends StatelessWidget {
  const SelectedStoreLocation({super.key, this.info});
  final StoreInformation? info;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BaseViewController());
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
          UserAvatarWidget(
            radius: 80,
            selectedImgPath: info?.profilePicture ?? "",
            isViewOnly: true,
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
                      text: info?.businessName ?? "Lorem Ipsum",
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
                        Container(
                          width: 250.w,
                          padding: EdgeInsets.only(left: 11.h),
                          child: CustomText(
                            text:
                                info?.vendorAddress?.address ??
                                "Address Not Available",
                            textAlign: TextAlign.left,
                            fontSize: 18.sp,
                            maxLines: 2,
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
                            text:
                                " ${controller.formatTime(info?.openTime)} To ${controller.formatTime(info?.closeTime)}",
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
                            text: "Phone no. not available",
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
