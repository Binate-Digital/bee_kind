import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/models/data_models/create_order_data_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartItem extends GetView<StoreController> {
  const CartItem({super.key, this.item, required this.index});

  final OrderItem? item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
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
        children: [
          // ---------- IMAGE ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.yellow2, width: 1.w),
              ),
              child:
                  (item?.productImage != null &&
                      item!.productImage!.isNotEmpty &&
                      item?.productImage != "null")
                  ? Image.network(
                      item!.productImage!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          Image.asset(AssetsPath.product, fit: BoxFit.contain),
                    )
                  : Image.asset(AssetsPath.product, fit: BoxFit.contain),
            ),
          ),

          SizedBox(width: 10.w),

          // ---------- NAME & QUANTITY ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: item?.productName ?? "",
                fontSize: 18.sp,
                weight: FontWeight.bold,
              ),

              SizedBox(height: 20.h),

              // ONLY THIS PART IS REACTIVE
              Obx(() {
                if (controller.orderItems!.length <= index) {
                  return SizedBox();
                }

                final currentItem = controller.orderItems![index];
                final qty = currentItem.quantity ?? 0;

                return Row(
                  children: [
                    // MINUS
                    GestureDetector(
                      onTap: () {
                        if (qty > 1) {
                          final unit = currentItem.unitPrice! / qty;
                          controller.addItems(
                            OrderItem(
                              productId: currentItem.productId,
                              productName: currentItem.productName,
                              productImage: currentItem.productImage,
                              unitPrice: unit,
                              quantity: qty - 1,
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: qty > 1
                              ? AppColors.blackColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.r),
                            bottomLeft: Radius.circular(24.r),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 30.w,
                          color: qty > 1 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),

                    // COUNT
                    SizedBox(
                      width: 50.w,
                      child: Center(
                        child: CustomText(
                          text: '$qty',
                          fontSize: 22.sp,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // PLUS
                    GestureDetector(
                      onTap: () {
                        final unit = currentItem.unitPrice! / qty;
                        controller.addItems(
                          OrderItem(
                            productId: currentItem.productId,
                            productName: currentItem.productName,
                            productImage: currentItem.productImage,
                            unitPrice: unit,
                            quantity: qty + 1,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.yellow2,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24.r),
                            bottomRight: Radius.circular(24.r),
                          ),
                        ),
                        child: Icon(Icons.add, size: 30.w, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),

          Spacer(),

          // ---------- PRICE + DELETE ----------
          Obx(() {
            if (controller.orderItems!.length <= index) {
              return Offstage();
            }

            final currentItem = controller.orderItems![index];

            return Column(
              children: [
                CustomText(
                  text:
                      "\$${currentItem.unitPrice?.toStringAsFixed(2) ?? "0.00"}",
                  fontSize: 18.sp,
                  fontColor: AppColors.yellow2,
                  weight: FontWeight.bold,
                ),

                SizedBox(height: 20.h),

                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 30.h,
                            horizontal: 20.w,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                text: "Remove this item?",
                                fontSize: 22.sp,
                                weight: FontWeight.bold,
                              ),
                              SizedBox(height: 30.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    width: 180.w,
                                    onTap: () => Navigator.pop(context),
                                    text: "Cancel",
                                    gradientColors: [
                                      AppColors.whiteColor,
                                      AppColors.whiteColor,
                                    ],
                                    borderColor: AppColors.blackColor,
                                  ),
                                  SizedBox(width: 20.w),
                                  CustomButton(
                                    width: 180.w,
                                    onTap: () {
                                      controller.removeItem(
                                        currentItem.productId!,
                                      );
                                      Navigator.pop(context);
                                    },
                                    text: "Remove",
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.asset(AssetsPath.delete, width: 18.w),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
