import 'package:bee_kind/common/new_address_screen.dart';
import 'package:bee_kind/core/user/store/choose_payment_method.dart';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/widgets/address_bar.dart';
import 'package:bee_kind/widgets/address_type.dart';
import 'package:bee_kind/widgets/cart_item.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CheckoutScreen extends GetView<StoreController> {
  const CheckoutScreen({super.key});

  final double deliveryCharges = 20.0;

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Checkout",

      // ---------- BOTTOM BAR ----------
      button: Container(
        color: AppColors.whiteColor,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx(() {
            final cartTotal = controller.calculateTotalCartPrice();
            final overallTotal = cartTotal + deliveryCharges;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 25.h),
                    Row(
                      children: [
                        CustomText(
                          text: "Total",
                          fontSize: 16.sp,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(width: 20.w, height: 30.h),
                      ],
                    ),
                    CustomText(
                      text: "\$${overallTotal.toStringAsFixed(2)}",
                      fontSize: 18.sp,
                      fontColor: AppColors.yellow2,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),

                Obx(
                  () => SizedBox(
                    height: 55.h,
                    child: CustomButton(
                      // isLoading: controller.isFetchingCards.value,
                      gradientColors:
                          controller.orderItems != null &&
                              controller.orderItems!.isNotEmpty
                          ? [AppColors.yellow1, AppColors.yellow2]
                          : [
                              AppColors.whiteColor,
                              AppColors.blackColor.withValues(alpha: 0.2),
                            ],
                      onTap: () async {
                        if (controller.selectedAddress.value == null) {
                          AppDialogs.showToast(
                            "Please select a delivery address",
                          );
                          return;
                        } else {
                          if (controller.orderItems != null &&
                              controller.orderItems!.isNotEmpty) {
                            // await controller.loadCards(context);
                            // if (controller.isFetchingCards.value) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChoosePaymentScreen(
                                  totalPrice: overallTotal,
                                ),
                              ),
                            );
                          }
                        }
                      },

                      text: "Checkout",
                      width: 300.w,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),

      // ---------- BODY ----------
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Obx(() {
              return AddressBar(
                onTap: () {},
                address:
                    controller.selectedAddress.value?.address ??
                    "No address selected",
              );
            }),

            SizedBox(height: 20.h),

            // ---------- CHANGE ADDRESS ----------
            Obx(
              () => !controller.isLoading.value
                  ? GestureDetector(
                      onTap: () {
                        controller.fetchUserAddresses().then(
                          (value) => showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                            ),
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setModalState) {
                                  return ListView(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    children: [
                                      SizedBox(height: 20.h),
                                      ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount:
                                            controller
                                                .userAddresses
                                                .value
                                                ?.data
                                                ?.length ??
                                            0,
                                        shrinkWrap: true,
                                        itemBuilder: (_, index) {
                                          final currentAddress = controller
                                              .userAddresses
                                              .value!
                                              .data![index];

                                          return Obx(() {
                                            bool isSelected =
                                                controller
                                                    .selectedAddressIndex
                                                    .value ==
                                                index;

                                            return GestureDetector(
                                              onTap: () {
                                                controller.selectAddress(index);

                                                setModalState(() {});

                                                Navigator.pop(context);
                                              },
                                              child: AddressType(
                                                isChecked: isSelected,
                                                type:
                                                    currentAddress
                                                        .addressName ??
                                                    "Not Specified",
                                                address:
                                                    currentAddress.address ??
                                                    "Not Specified",
                                                onChanged: (value) {
                                                  controller.selectAddress(
                                                    index,
                                                  );
                                                  Navigator.pop(context);
                                                  setModalState(() {});
                                                },
                                              ),
                                            );
                                          });
                                        },
                                      ),

                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(
                                      //     horizontal: 20.w,
                                      //     vertical: 10.h,
                                      //   ),
                                      //   child: GestureDetector(
                                      //     onTap: () => Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (_) =>
                                      //             AddNewAddressScreen(isEdit: false),
                                      //       ),
                                      //     ),
                                      //     child: Row(
                                      //       mainAxisAlignment: MainAxisAlignment.end,
                                      //       children: [
                                      //         Icon(
                                      //           Icons.add_circle,
                                      //           color: AppColors.yellow2,
                                      //         ),
                                      //         SizedBox(width: 10.w),
                                      //         CustomText(
                                      //           text: "Add Another Address",
                                      //           fontSize: 18.sp,
                                      //           weight: FontWeight.bold,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 30.h,
                                          horizontal: 20.h,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // CANCEL BUTTON
                                            CustomButton(
                                              width: 180.w,
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              text: "Cancel",
                                              gradientColors: [
                                                AppColors.whiteColor,
                                                AppColors.whiteColor,
                                              ],
                                              borderColor: AppColors.blackColor,
                                              textColor: Colors.black,
                                            ),

                                            SizedBox(width: 20.w),

                                            // ADD ANOTHER ADDRESS BUTTON
                                            CustomButton(
                                              width: 180.w,
                                              onTap: () {
                                                Navigator.pop(
                                                  context,
                                                ); // Close bottom sheet
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        AddNewAddressScreen(
                                                          isEdit: false,
                                                        ),
                                                  ),
                                                );
                                              },
                                              text: "Add Address",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                      child: CustomText(
                        text: "Select Address",
                        underlined: true,
                        weight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    )
                  : CircularProgressIndicator(color: AppColors.yellow2),
            ),

            SizedBox(height: 20.h),

            // ---------- NOTES ----------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: CustomTextField(
                hint: "Additional Notes",
                maxlines: 6,
                controller: controller.notesController,
                radius: 20.r,
              ),
            ),

            // ---------- CART ITEMS ----------
            Obx(() {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.orderItems?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CartItem(
                    index: index,
                    item: controller.orderItems![index],
                  );
                },
              );
            }),

            // ---------- DELIVERY CHARGES ----------
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Delivery Charges",
                    fontSize: 16.sp,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: "\$${deliveryCharges.toStringAsFixed(2)}",
                    fontSize: 18.sp,
                    fontColor: AppColors.yellow2,
                    weight: FontWeight.bold,
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
