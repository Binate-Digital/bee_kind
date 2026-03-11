import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/checkout.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/cart_item.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartScreen extends GetView<StoreController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final items = controller.orderItems!;

        // print("itemsitems${items[1].productImage}");

        return Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: CustomText(
                        text: "No Items In Cart!",
                        fontSize: 18.sp,
                        fontColor: AppColors.blackColor.withValues(alpha: 0.3),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      physics: BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return CartItem(index: index, item: items[index]);
                      },
                    ),
            ),

            // STATIC BOTTOM SECTION
            if (items.isNotEmpty)
              Container(
                height: 235.h,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                    children: [
                      Row(
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

                      SizedBox(height: 10.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Total",
                                fontSize: 16.sp,
                                weight: FontWeight.bold,
                              ),
                              SizedBox(height: 5.h),
                              Obx(() {
                                return CustomText(
                                  text:
                                      // "\$${controller.calculateTotalCartPrice().toStringAsFixed(2)}",
                                  "\$${(controller.calculateTotalCartPrice() + 20).toStringAsFixed(2)}",

                                fontSize: 18.sp,
                                  fontColor: AppColors.yellow2,
                                  weight: FontWeight.bold,
                                );
                              }),
                            ],
                          ),

                          CustomButton(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(),
                              ),
                            ),
                            text: "Checkout",
                            width: 200.w,
                            horizontalPadding: 10.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
