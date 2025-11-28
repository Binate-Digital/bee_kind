// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/models/response_models/card_response_model.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
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
    this.cards,
    this.selectedPaymentMethod,
  });
  final double? totalPrice;
  final List<CardModel>? cards;
  final String? selectedPaymentMethod;

  @override
  State<ChoosePaymentScreen> createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  String? _selectedPaymentMethod;

  final controller = Get.find<StoreController>();

  final prefs = SharedPrefs();

  CardResponseModel? cardData;
  bool isLoading = false;

  List<CardModel>? cardDataList = [];

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.selectedPaymentMethod;
    log("Selected payment id: ${_selectedPaymentMethod}");
    cardDataList = widget.cards; // store cards locally
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Choose Payment Method",
      button: _buildBottomBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: AppColors.whiteColor,
      height: 130.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10.w),
                _buildAddNewCard(),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 25.h),
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
                        controller.selectedPaymentMethod.value =
                            _selectedPaymentMethod ?? "";
                        controller.createOrder(context, widget.totalPrice ?? 0);
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

  Widget _buildBody() {
    final cards = widget.cards;

    return cards!.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: cards.length,
            itemBuilder: (_, i) => _buildCardTile(cards[i]),
          )
        : Center(child: CustomText(text: "No Cards Found"));
  }

  Widget _buildCardTile(CardModel card) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.15),
            blurRadius: 25.r,
            offset: Offset(0, 5),
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
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value;
                prefs.setString("cardId", value.toString());
                log("selected payment ID: $value");
                controller.selectedPaymentMethod.value = value ?? "";
              });
            },
            fillColor: WidgetStateProperty.all(AppColors.yellow2),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewCard() {
    return GestureDetector(
      onTap: () => addNewAccountDialog(context),
      child: CustomText(
        text: "Add New Account",
        weight: FontWeight.bold,
        fontSize: 18.sp,
        underlined: true,
      ),
    );
  }
}
