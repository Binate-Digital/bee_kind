import 'package:bee_kind/core/user/store/checkout.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/cart_item.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CartItem();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Delivery Charges",
                    fontSize: 16.sp,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: "\$20.00",
                    fontSize: 18.sp,
                    fontColor: AppColors.yellow2,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
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
                      text: "\$20.00",
                      fontSize: 18.sp,
                      fontColor: AppColors.yellow2,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),

                CustomButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  ),
                  text: "Checkout",
                  width: 300.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
