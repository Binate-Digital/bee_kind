import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int _count = 1;

  void increment() {
    setState(() {
      _count++;
    });
  }

  void decrement() {
    setState(() {
      if (_count > 0) _count--;
    });
  }

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
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
        color: AppColors.whiteColor,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 40.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.yellow2, width: 1.w),
              color: AppColors.whiteColor,
              image: DecorationImage(
                image: AssetImage(AssetsPath.product),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            children: [
              CustomText(
                text: "Lorem Ipsum",
                fontSize: 18.sp,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  // Minus Button
                  GestureDetector(
                    onTap: decrement, // Use local decrement method
                    child: Container(
                      decoration: BoxDecoration(
                        color: _count > 0
                            ? AppColors.blackColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          bottomLeft: Radius.circular(24.r),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.remove,
                          size: 30.w,
                          color: _count > 0 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Count Display
                  Container(
                    width: 50.w,
                    color: Colors.transparent,
                    child: Center(
                      child: CustomText(
                        text: '$_count', // Use local _count
                        fontSize: 22.sp,
                        weight: FontWeight.bold,
                        fontColor: AppColors.blackColor,
                      ),
                    ),
                  ),

                  // Plus Button
                  GestureDetector(
                    onTap: increment, // Use local increment method
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow2,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24.r),
                          bottomRight: Radius.circular(24.r),
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.add, size: 30.w, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 110.w),
          Column(
            children: [
              CustomText(
                text: "\$20.00",
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
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.w),
                            child: CustomText(
                              text: "Remove from Cart?",
                              fontSize: 22.sp,
                              weight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20.h,
                              horizontal: 20.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  width: 180.w,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
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
                                    Navigator.pop(context);
                                  },
                                  text: "Yes Remove",
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Image.asset(AssetsPath.delete, width: 18.w),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
