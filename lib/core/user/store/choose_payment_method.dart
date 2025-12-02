// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/main.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/dialogs/add_new_account_dialog.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChoosePaymentScreen extends StatefulWidget {
  const ChoosePaymentScreen({
    super.key,
    this.totalPrice,
  });

  final double? totalPrice;

  @override
  State<ChoosePaymentScreen> createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  final controller = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();

    /// Load cards SAME as PaymentAccountsScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCards(StaticData.navigatorKey.currentContext!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Choose Payment Method",
      button: _buildBottomBar(),
      body: Obx(() => _buildBody()),
    );
  }

  // ----------------------- BOTTOM BAR -----------------------

  Widget _buildBottomBar() {
    return Container(
      color: AppColors.whiteColor,
      height: 130.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10.w),
                _buildAddNewCard(),
              ],
            ),

            SizedBox(height: 25.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomText(
                      text: "Total",
                      fontSize: 16.sp,
                      weight: FontWeight.bold,
                    ),
                    CustomText(
                      text: "\$${widget.totalPrice}",
                      fontSize: 18.sp,
                      fontColor: AppColors.yellow2,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),

                Obx(
                  () => SizedBox(
                    height: 60.h,
                    child: CustomButton(
                      onTap: () {
                        controller.createOrder(
                          context,
                          widget.totalPrice ?? 0,
                        );
                      },
                      text: "Confirm Payment",
                      width: 300.w,
                      isLoading: controller.isCreatingOrder.value,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------- CARD LIST ------------------------

  Widget _buildBody() {
    /// Use controller.cardList instead of widget.cards
    final cards = controller.cardList;

    if (controller.isFetchingCards.value) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    if (cards.isEmpty) {
      return Center(
        child: CustomText(
          text: "No Cards Found",
          fontSize: 18.sp,
          fontColor: Colors.grey,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: cards.length,
      itemBuilder: (_, index) => _buildCardTile(cards[index]),
    );
  }

  // ------------------- CARD TILE ---------------------------

  Widget _buildCardTile(card) {
    return Obx(() {
      String selected = controller.selectedPaymentMethod.value;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.15),
              blurRadius: 25.r,
              offset: const Offset(0, 5),
            ),
          ],
          color: AppColors.whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 70.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.yellow2,
                  ),
                  child: CustomText(
                    text: card.brand?.toUpperCase() ?? "CARD",
                    fontSize: 14.sp,
                    fontColor: AppColors.whiteColor,
                    weight: FontWeight.bold,
                  ),
                ),

                SizedBox(width: 12.w),

                CustomText(
                  text: "**** **** **** ${card.last4}",
                  fontSize: 18.sp,
                  weight: FontWeight.w600,
                ),
              ],
            ),

            Radio(
              value: card.id,
              groupValue: selected,
              fillColor: WidgetStateProperty.all(AppColors.yellow2),

              onChanged: (value) async {
                controller.selectedPaymentMethod.value = value ?? "";
                log("User selected card: ${controller.selectedPaymentMethod.value}");

                /// SAME BEHAVIOR as PaymentAccountsScreen
                await controller.setDefaultCard(
                  StaticData.navigatorKey.currentContext!,
                  value.toString(),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddNewCard() {
    return GestureDetector(
      onTap: () async {
        await addNewAccountDialog(context);

        /// Refresh same as PaymentAccountsScreen
        controller.loadCards(StaticData.navigatorKey.currentContext!);
      },
      child: CustomText(
        text: "Add New Account",
        weight: FontWeight.bold,
        fontSize: 18.sp,
        underlined: true,
      ),
    );
  }
}
