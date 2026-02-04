import 'dart:developer' as dev;
import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/models/response_models/get_stores_response_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> showVendorDetailsDialog(
  BuildContext context,
  StoreInformation store,
) async {
  final controller = Get.find<BaseViewController>();

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      print("huzaifa");
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.w),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellow2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Vendor Details",
                        fontSize: 20.sp,
                        weight: FontWeight.bold,
                        fontColor: AppColors.blackColor,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.blackColor,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 20.w,
                  ),
                  child: Column(
                    children: [
                      // Vendor Avatar
                      UserAvatarWidget(
                        radius: 80,
                        selectedImgPath: store.profilePicture ?? "",
                        isViewOnly: true,
                      ),

                      SizedBox(height: 20.h),

                      // Business Name
                      CustomText(
                        text: store.businessName ?? "Unknown Vendor",
                        fontSize: 24.sp,
                        fontColor: AppColors.yellow2,
                        weight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 20.h),

                      // Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            AssetsPath.location,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: CustomText(
                              text:
                                  store.vendorAddress?.address ??
                                  "Address Not Available",
                              fontSize: 16.sp,
                              fontColor: AppColors.blackColor,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // Operating Hours
                      Row(
                        children: [
                          Image.asset(
                            AssetsPath.clock,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(width: 10.w),
                          CustomText(
                            text:
                                "${controller.formatTime(store.openTime)} To ${controller.formatTime(store.closeTime)}",
                            fontSize: 16.sp,
                            fontColor: AppColors.blackColor,
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // Phone (placeholder since not available in model)
                      Row(
                        children: [
                          Image.asset(
                            AssetsPath.phone,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: "Phone not available",
                            fontSize: 16.sp,
                            fontColor: AppColors.blackColor,
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),

                      // View Store Button
                      CustomButton(
                        onTap: () async {
                          Navigator.pop(context); // Close dialog
                          // Resolve store id safely. If missing, try to find a matching store in controller.storesList
                          String? storeId = store.sId;
                          dev.log('View Store tapped for id: $storeId');

                          if (storeId == null || storeId.isEmpty) {
                            try {
                              final match = controller.storesList.firstWhere((
                                s,
                              ) {
                                final sameName =
                                    (s.businessName ?? '').trim() ==
                                    (store.businessName ?? '').trim();
                                final sameAddress =
                                    (s.vendorAddress?.address ?? '').trim() ==
                                    (store.vendorAddress?.address ?? '').trim();
                                return sameName && sameAddress;
                              });
                              storeId = match.sId;
                              dev.log('Resolved store id from list: $storeId');
                            } catch (e) {
                              storeId = null;
                            }
                          }

                          if (storeId == null || storeId.isEmpty) {
                            AppDialogs.showToast('Store id missing');
                            return;
                          }

                          await controller.fetchStoreDetail(storeId);
                        },
                        text: "View Store",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
