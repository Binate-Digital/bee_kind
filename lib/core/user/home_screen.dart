// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/address_bar.dart';
import 'package:bee_kind/widgets/categories.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_google_maps.dart';
import 'package:bee_kind/widgets/custom_keyboard_action_widget.dart';
import 'package:bee_kind/widgets/custom_slider.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/selected_store_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BaseViewController>();

    final searchFocusNode = FocusNode();
    final maxFocusNode = FocusNode();
    final minFocusNode = FocusNode();

    return Obx(
      () => CustomGoogleMap(
        initialCameraPosition: CameraPosition(
          target:
              controller.currentLatLng.value ??
              const LatLng(24.870912, 67.0826496),
          zoom: 10,
        ),
        markers: controller.markers.value,
        circles: controller.circles.value,
        onMapCreated: (ctrl) {
          controller.mapController = ctrl;
        },
        widget: Column(
          children: [
            SizedBox(height: 10.h),
            // SEARCH FIELD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomKeyboardActionWidget(
                focusNode: searchFocusNode,
                child: CustomTextField(
                  hint: "Search",
                  controller: controller.searchController,
                  bgColor: AppColors.whiteColor,
                  bdColor: AppColors.yellow2,
                  hintColor: AppColors.blackColor.withValues(alpha: 0.3),
                  prefxicon: AssetsPath.search,
                  isSuffixIcon: true,
                  focusNode: searchFocusNode,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    controller.fetchStores();
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20.h,
                              horizontal: 20.w,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: CustomDropdown(
                                    items:
                                        controller.categories.value?.data
                                            ?.map(
                                              (c) =>
                                                  c.categoryName ?? "Unknown",
                                            )
                                            .toList() ??
                                        [],
                                    hintText: "Product Category",

                                    onChanged: (selectedName) {
                                      final selectedCategory = controller
                                          .categories
                                          .value
                                          ?.data
                                          ?.firstWhere(
                                            (c) =>
                                                c.categoryName == selectedName,
                                          );
                                      log(
                                        "selected category: ${selectedCategory?.sId}\n name: ${selectedCategory?.categoryName}",
                                      );
                                      controller.updateSelectedCategory(
                                        selectedCategory?.sId,
                                        selectedCategory?.categoryName,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: CustomText(
                                    text: "Price Range",
                                    fontFamily: "Raleway",
                                    weight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 150.w,
                                      child: CustomKeyboardActionWidget(
                                        focusNode: maxFocusNode,
                                        child: CustomTextField(
                                          hint: "Max Price",
                                          focusNode: maxFocusNode,
                                          controller:
                                              controller.maxPriceController,
                                          keyboardType: TextInputType.number,
                                          radius: 10.r,
                                          onEditingComplete: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150.w,
                                      child: CustomKeyboardActionWidget(
                                        focusNode: minFocusNode,
                                        child: CustomTextField(
                                          focusNode: minFocusNode,
                                          hint: "Min Price",
                                          controller:
                                              controller.minPriceController,
                                          onEditingComplete: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          keyboardType: TextInputType.number,
                                          radius: 10.r,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 50.w),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 10.h,
                                    top: 20.h,
                                  ),
                                  child: CustomText(
                                    text: "Delivery Radius",
                                    fontFamily: "Raleway",
                                    weight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                CustomSliderWidget(
                                  min: controller.minRadius.value,
                                  max: controller.maxRadius.value,
                                  initialValue: controller.currentRadius.value,
                                  unit: "miles",
                                  formatValue: (value) =>
                                      controller.formatRadius(value),
                                  onChanged: controller.updateRadius,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30.h),
                                  child: CustomButton(
                                    onTap: () async => await controller
                                        .fetchStores()
                                        .then((value) {
                                          Get.back();
                                        }),
                                    text: "Search",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      AssetsPath.filter,
                      color: AppColors.yellow2,
                    ),
                  ),
                ),
              ),
            ),

            AddressBar(onTap: () {}, address: controller.address),

            controller.showWindow.value
                ? GestureDetector(
                    onTap: () async {
                      debugPrint("ontap");
                      final storeId = controller.selectedStore.value?.sId;
                      if (storeId == null) return;
                      await controller.fetchStoreDetail(storeId, context);
                    },
                    child: SelectedStoreLocation(
                      info: controller.selectedStore.value,
                    ),
                  )
                : SizedBox(width: 90.w, height: 177.h),

            // CATEGORIES SECTION
            Container(
              margin: EdgeInsets.only(top: 155.h),
              padding: EdgeInsets.symmetric(vertical: 20.h),
              color: AppColors.whiteColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, right: 30.w),
                    child: Row(
                      children: [
                        CustomText(
                          text: "Categories",
                          fontColor: AppColors.blackColor,
                          fontSize: 22.sp,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 265.h,
                    child: ListView.builder(
                      itemCount: controller.categories.value?.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final c = controller.categories.value?.data?[index];
                        return GestureDetector(
                          onTap: () async {
                            await controller.getProductsByCategory(
                              c?.sId,
                              c?.categoryName,
                              context,
                            );
                          },
                          child: Categories(
                            name: c?.categoryName,
                            image: c?.categoryImage,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
