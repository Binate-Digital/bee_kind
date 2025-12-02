// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/main.dart';
import 'package:bee_kind/models/response_models/card_response_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/add_new_account_dialog.dart';
import 'package:bee_kind/widgets/dialogs/delete_card_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentAccountsScreen extends StatelessWidget {
  PaymentAccountsScreen({super.key});

  final StoreController controller = Get.find<StoreController>();

  @override
  Widget build(BuildContext context) {
    controller.loadCards(context); // initial load

    return AppBarBaseView(
      title: "Payment Accounts",
      button: _buildAddNewCardButton(context),
      body: Obx(() => _buildBody(context)),
    );
  }

  // -------------------- ADD NEW CARD --------------------
  Widget _buildAddNewCardButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: CustomButton(
        borderColor: AppColors.blackColor,
        text: "Add New Account",
        onTap: () async {
          await addNewAccountDialog(context);
          controller.loadCards(context); // Refresh immediately
        },
      ),
    );
  }

  // -------------------- BODY --------------------
  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.yellow2,
      onRefresh: () async {
        await controller.loadCards(context);
      },
      child: controller.isFetchingCards.value
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 250),
                Center(child: CircularProgressIndicator(color: Colors.amber)),
              ],
            )
          : _buildCardList(context),
    );
  }

  // -------------------- CARD LIST --------------------
  Widget _buildCardList(BuildContext context) {
    final cards = controller.cardList;

    if (cards.isEmpty) {
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: 200.h),
          Center(
            child: CustomText(
              text: "No payment methods added",
              fontSize: 18.sp,
              fontColor: Colors.grey,
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 20.h, bottom: 80.h),
      itemCount: cards.length,
      itemBuilder: (_, index) => _buildCardTile(cards[index]),
    );
  }

  // -------------------- CARD TILE --------------------
  Widget _buildCardTile(CardModel card) {
    return Obx(() {
      String selected = controller.selectedPaymentMethod.value;

      return Dismissible(
        key: Key(card.id.toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          await deleteCardConfirmationDialog(
            StaticData.navigatorKey.currentContext!,
            card.id ?? "",
          );
          return false; // prevent auto-dismiss UI
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.w),
          color: Colors.redAccent,
          child: Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        child: _buildCardTileContent(card, selected),
      );
    });
  }

  /// Extracted card content UI
  Widget _buildCardTileContent(CardModel card, String selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
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
          /// Brand + Last4
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

          /// Select radio
          Radio(
            value: card.id,
            groupValue: selected,
            onChanged: (value) async {
              controller.selectedPaymentMethod.value = value ?? "";
              log(
                "PAYMENT METHOD ID: ${controller.selectedPaymentMethod.value}",
              );

              // Save in prefs as you already do elsewhere
              await controller.setDefaultCard(
                StaticData.navigatorKey.currentContext!,
                value.toString(),
              );
            },
            fillColor: WidgetStateProperty.all(AppColors.yellow2),
          ),
        ],
      ),
    );
  }
}
