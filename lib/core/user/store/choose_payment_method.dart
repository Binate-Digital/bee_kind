// ignore_for_file: deprecated_member_use

import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/add_new_account_dialog.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/successful_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoosePaymentScreen extends StatefulWidget {
  const ChoosePaymentScreen({super.key});

  @override
  State<ChoosePaymentScreen> createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  String? _selectedPaymentMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': '1',
      'method': "A Pay",
      'color': AppColors.blackColor,
      'name': 'Apple Pay',
      'icon': '🍎', // You can replace with actual icons
    },
    {
      'id': '2',
      'method': "G Pay",
      'color': Colors.blue,
      'name': 'Google Pay',
      'icon': '📱',
    },
    {
      'id': '3',
      'method': "PayPal",
      'color': Colors.blue[900]!,
      'name': 'PayPal',
      'icon': '💳',
    },
    {
      'id': '4',
      'method': "MC",
      'color': Colors.red[800]!,
      'name': '*** **** **** 4567',
      'icon': '💳',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Choose Payment Method",
      button: Container(
        color: AppColors.whiteColor,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
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
                    text: "\$100.00",
                    fontSize: 18.sp,
                    fontColor: AppColors.yellow2,
                    weight: FontWeight.bold,
                  ),
                ],
              ),

              CustomButton(
                onTap: () => successfulOrderDialog(context),
                text: "Confirm Payment",
                width: 300.w,
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          // Payment Methods List
          ListView.builder(
            shrinkWrap: true,
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              final method = paymentMethods[index];

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
                      spreadRadius: 0,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: method['color'],
                          ),
                          child: CustomText(
                            text: method['method'],
                            fontSize: 14.sp,
                            fontColor: AppColors.whiteColor,
                            weight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // Payment Method Name
                        CustomText(
                          text: method['name'],
                          fontSize: 18.sp,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      width: 24.w,
                      height: 24.h,
                      child: Radio<String>(
                        value: method['id'],
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        fillColor: WidgetStateProperty.all(AppColors.yellow2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => addNewAccountDialog(context),
                  child: CustomText(
                    text: "Add New Account",
                    weight: FontWeight.bold,
                    fontSize: 18.sp,
                    underlined: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
