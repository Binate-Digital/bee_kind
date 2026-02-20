// ignore_for_file: invalid_use_of_protected_member

import 'package:bee_kind/common/profile/address_screen.dart';
import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/selected_store.dart';
import 'package:bee_kind/models/response_models/get_stores_response_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/address_bar.dart';
import 'package:bee_kind/widgets/categories.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_keyboard_action_widget.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/dialogs/vendor_details_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/custom_slider.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  OverlayEntry? _overlayEntry;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Listen to selected store changes to show dialog
    searchFocusNode.addListener(isActive);
    final controller = Get.find<BaseViewController>();
    ever(controller.selectedStore, (StoreInformation? store) {
      if (store != null && Get.context != null) {
        Get.back();
        showVendorDetailsDialog(Get.context!, store);
      }
    });
  }

  // final FocusNode searchFocusNode = FocusNode();


  bool showWidget=true;
  void isActive(){
    if(searchFocusNode.hasFocus){

      showWidget=false;
      setState(() {

      });
      debugPrint("Keyboard is active");
    }else{
      showWidget=true;
      setState(() {

      });
      debugPrint("Keyboard is not active");
    }
  }

  // final searchFocusNode = FocusNode();

  void showSuggestionsOverlay(
    BuildContext context,
    BaseViewController controller,
  ) {
    // Remove existing overlay if any
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80.h, // Position below the search field
        left: 20.w,
        right: 20.w,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            constraints: BoxConstraints(maxHeight: 150.h), // Reduced height
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.yellow2, width: 1.w),
            ),
            child: Obx(() {
              if (!controller.showSuggestions.value ||
                  controller.searchSuggestions.isEmpty) {
                _overlayEntry?.remove();
                _overlayEntry = null;
                return const SizedBox.shrink();
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.searchSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = controller.searchSuggestions[index];
                  return ListTile(
                    dense: true,
                    title: CustomText(
                      text: suggestion,
                      fontSize: 16.sp,
                      fontColor: AppColors.blackColor,
                    ),
                    onTap: () {
                      controller.selectSuggestion(suggestion);
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                    },
                  );
                },
              );
            }),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Remove overlay when suggestions are hidden
    controller.showSuggestions.listen((show) {
      if (!show) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BaseViewController>();
    final storeController = Get.find<StoreController>();

    // ignore: unused_local_variable




    return Scaffold(


    


      body:
        Stack(
            children: [
              // FULL SCREEN MAP
              GetBuilder<BaseViewController>(
                  builder: (controller) {
                    return SizedBox.expand(
                      child: GoogleMap(
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
                          // The map will be positioned by updateMapToSelectedAddress() called in initState
                        },
                        myLocationEnabled: false,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapToolbarEnabled: false,
                        compassEnabled: false,
                        buildingsEnabled: true,
                      ),
                    );
                  }
              ),

              // TOP SEARCH BAR
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomKeyboardActionWidget(
                                      focusNode: searchFocusNode,
                                      child: CustomTextField(
                                        onTap: () {
                                          controller.showWidget = false;
                                          controller.update();
                                        },

                                        hint: "Search stores...",
                                        controller: controller.searchController,
                                        bgColor: Colors.transparent,
                                        bdColor: Colors.transparent,
                                        hintColor: AppColors.blackColor
                                            .withValues(
                                          alpha: 0.5,
                                        ),
                                        prefxicon: AssetsPath.search,
                                        focusNode: searchFocusNode,
                                        onEditingComplete: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controller.hideSuggestions();
                                          controller.fetchSeacrgStores();
                                          controller.showWidget = true;
                                          controller.update();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      controller.hideSuggestions();
                                      controller.fetchSeacrgStores();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.yellow2,
                                        borderRadius: BorderRadius.circular(
                                            10.r),
                                      ),
                                      child: Image.asset(
                                        AssetsPath.search,
                                        color: Colors.white,
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () =>
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.r),
                                            ),
                                          ),
                                          builder: (context) =>
                                              Padding(
                                                padding: EdgeInsets.all(20.w),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        CustomText(
                                                          text: "Filters",
                                                          fontSize: 20.sp,
                                                          weight: FontWeight
                                                              .bold,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                .clearFilterResponse();
                                                          },
                                                          child: CustomText(
                                                            text: "Clear Filter",
                                                            fontSize: 15.sp,
                                                            weight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20.h),
                                                    CustomDropdown(
                                                      items:
                                                      controller.categories
                                                          .value?.data
                                                          ?.map(
                                                            (c) =>
                                                        c.categoryName ??
                                                            "Unknown",
                                                      )
                                                          .toList() ??
                                                          [],
                                                      hintText: "Category",
                                                      onChanged: (value) {
                                                        // Safely resolve selected category (avoid throwing)
                                                        var category;
                                                        try {
                                                          category = controller
                                                              .categories
                                                              .value
                                                              ?.data
                                                              ?.firstWhere(
                                                                (c) =>
                                                            c.categoryName ==
                                                                value,
                                                          );
                                                        } catch (e) {
                                                          category = null;
                                                        }

                                                        controller
                                                            .updateSelectedCategory(
                                                          category?.sId,
                                                          category
                                                              ?.categoryName,
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(height: 20.h),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: CustomTextField(
                                                            hint: "Min Price",
                                                            controller: controller
                                                                .minPriceController,
                                                            keyboardType:
                                                            TextInputType
                                                                .number,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Expanded(
                                                          child: CustomTextField(
                                                            hint: "Max Price",
                                                            controller: controller
                                                                .maxPriceController,
                                                            keyboardType:
                                                            TextInputType
                                                                .number,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20.h),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30.h),
                                                      child: CustomSliderWidget(
                                                        min: controller
                                                            .filterminRadius,
                                                        max: controller
                                                            .filtermaxRadius,
                                                        initialValue: controller
                                                            .currentRadius
                                                            .value,
                                                        unit: "mi",
                                                        onChanged: (value) =>
                                                        controller.currentRadius
                                                            .value = value,
                                                      ),
                                                    ),
                                                    CustomButton(
                                                      onTap: () {
                                                        Get.back();

                                                        controller
                                                            .showfilteredlist =
                                                        true;
                                                        controller.update();

                                                        controller
                                                            .fetchStores();
                                                      },
                                                      text: "Apply Filters",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        ),
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.yellow2,
                                        borderRadius: BorderRadius.circular(
                                            10.r),
                                      ),
                                      child: Image.asset(
                                        AssetsPath.filter,
                                        color: Colors.white,
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SEARCH SUGGESTIONS
                            Obx(() {
                              if (controller.showSuggestions.value &&
                                  controller.searchSuggestions.isNotEmpty) {
                                return Container(
                                  constraints: BoxConstraints(maxHeight: 200.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.searchSuggestions
                                        .length,
                                    itemBuilder: (context, index) {
                                      final suggestion =
                                      controller.searchSuggestions[index];
                                      return ListTile(
                                        dense: true,
                                        leading: CustomText(
                                          text: suggestion,
                                          fontSize: 16.sp,
                                          fontColor: AppColors.blackColor,
                                        ),
                                        onTap: () =>
                                            controller.selectSuggestion(
                                                suggestion),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),


                          ],
                        ),
                      ),

                      // ADDRESS BAR BELOW SEARCH
                      // SizedBox(height: 5.h),
                      Obx(
                            () =>
                            AddressBar(
                              onTap: () => Get.to(() => const AddressScreen()),
                              address:
                              storeController.selectedAddress.value?.address ??
                                  controller.address,
                            ),
                      ),

                      GetBuilder<BaseViewController>(
                          builder: (controller) {
                            return Column(
                              children: [
                                controller.showfilteredlist == false
                                    ? SizedBox()
                                    :
                                Container(
                                  // height: 150,
                                  child: GetBuilder<BaseViewController>(
                                      builder: (controller) {
                                        return Container(
                                          height: 250,
                                          child: ListView.builder(
                                            itemCount: controller.filterResponse
                                                .value?.data?.length ?? 0,
                                            // shrinkWrap: true,
                                            // physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final open = controller
                                                  .formatTo12Hour(
                                                  controller.filterResponse
                                                      .value?.data?[index]
                                                      .openTime);
                                              final close = controller
                                                  .formatTo12Hour(
                                                  controller.filterResponse
                                                      .value?.data?[index]
                                                      .closeTime);
                                              return GestureDetector(
                                                onTap: () {
                                                  controller.fetchStoreDetail(
                                                      controller.filterResponse
                                                          .value?.data?[index]
                                                          .sId);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 10.h),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(20.r),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .blackColor
                                                            .withValues(
                                                            alpha: 0.15),
                                                        blurRadius: 25.r,
                                                        offset: const Offset(
                                                            0, 5),
                                                      ),
                                                    ],
                                                    color: AppColors.whiteColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [

                                                      /// IMAGE
                                                      /// IMAGE


                                                      ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .circular(20.r),
                                                        child: Container(
                                                          width: 100.w,
                                                          height: 100.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(20.r),
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .yellow2,
                                                                width: 1.w),
                                                            color: AppColors
                                                                .whiteColor,
                                                            image: DecorationImage(
                                                              image: controller
                                                                  .filterResponse
                                                                  .value
                                                                  ?.data?[index]
                                                                  .profilePicture !=
                                                                  null &&
                                                                  controller
                                                                      .filterResponse
                                                                      .value
                                                                      ?.data?[index]
                                                                      .profilePicture
                                                                      .isNotEmpty
                                                                  ? NetworkImage(
                                                                  controller
                                                                      .filterResponse
                                                                      .value
                                                                      ?.data?[index]
                                                                      .profilePicture !)
                                                                  : AssetImage(
                                                                  AssetsPath
                                                                      .product) as ImageProvider,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      /// MIDDLE TEXT
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(left: 15),
                                                        child: Container(
                                                          // width: 130.w,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              CustomText(
                                                                // text: order.items![index].productName ?? "N/A",
                                                                text: controller
                                                                    .filterResponse
                                                                    .value
                                                                    ?.data?[index]
                                                                    .businessName ??
                                                                    "",
                                                                fontColor: Colors
                                                                    .orange,
                                                                fontSize: 18.sp,
                                                                weight: FontWeight
                                                                    .bold,
                                                              ),
                                                              SizedBox(
                                                                  height: 10.h),
                                                              CustomText(
                                                                  text: "${open } To ${close } ",
                                                                  fontSize: 13
                                                                      .sp),
                                                              SizedBox(
                                                                  height: 10.h),
                                                              CustomText(
                                                                  text: controller
                                                                      .filterResponse
                                                                      .value
                                                                      ?.data?[index]
                                                                      .phoneNumber ??
                                                                      "",
                                                                  fontSize: 13
                                                                      .sp),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      SizedBox(width: 35.w),

                                                      /// PRICE + BUTTON
                                                      SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },),
                                        );
                                      }
                                  ),
                                )
                              ],
                            );
                          }
                      )
                    ],
                  ),
                ),
              ),






              // BOTTOM CATEGORIES SHEET
              GetBuilder<BaseViewController>(
                  builder: (controller) {
                    return
                      showWidget == true ?
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 320.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // DRAG HANDLE
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                height: 4.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Row(
                                  children: [
                                    CustomText(
                                      text: "Categories",
                                      fontSize: 20.sp,
                                      weight: FontWeight.bold,
                                      fontColor: AppColors.blackColor,
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Obx(
                                      () =>
                                      ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        itemCount:
                                        controller.categories.value?.data
                                            ?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          final category =
                                          controller.categories.value
                                              ?.data?[index];
                                          return GestureDetector(
                                            onTap: () =>
                                                controller
                                                    .getProductsByCategory(
                                                  category?.sId,
                                                  category?.categoryName,
                                                  context,
                                                ),
                                            child: Container(
                                              // width: 40,
                                              // color: Colors.red,
                                              margin: EdgeInsets.only(
                                                  right: 10.w),
                                              child: Categories(
                                                name: category?.categoryName,
                                                image: category?.categoryImage,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : SizedBox();
                  }
              ),
            ],
          )

    );
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }
}
