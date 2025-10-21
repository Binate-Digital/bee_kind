import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/delivery_info_dialog.dart';
import 'package:bee_kind/widgets/dialogs/error_dialog.dart';
import 'package:bee_kind/widgets/dialogs/order_complete_confirmation_dialog.dart';
import 'package:bee_kind/widgets/stepper_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedOrder extends StatefulWidget {
  const SelectedOrder({
    super.key,
    this.isCancelled = false,
    this.isCurrent = false,
    this.isAccepted = false,
  });
  final bool isCancelled;
  final bool isCurrent;
  final bool isAccepted;

  @override
  State<SelectedOrder> createState() => _SelectedOrderState();
}

class _SelectedOrderState extends State<SelectedOrder> {
  int currentCarouselIndex = 0;
  int currentStep = 0;
  bool isAccepted = false;
  bool isCurrent = false; // ✅ Local copy to modify dynamically

  final List<String> steps = [
    AssetsPath.box,
    AssetsPath.truck,
    AssetsPath.carry,
  ];

  String text = "Ready for Pickup";

  @override
  void initState() {
    super.initState();
    currentStep = widget.isCurrent ? 0 : 2;
    isAccepted = widget.isAccepted;
    isCurrent = widget.isCurrent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(30.w, 350.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      items: [1, 2, 3].map((i) {
                        return Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(AssetsPath.store),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 290.h,
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 2.0,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentCarouselIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 270.h,
                  left: 170.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [1, 2, 3].asMap().entries.map((entry) {
                      bool isSelected = currentCarouselIndex == entry.key;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: isSelected ? 50.w : 8.w,
                        height: 8.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blackColor,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.whiteColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 70.h,
                    bottom: 20.h,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 150.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 30.r,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        CustomText(
                          text: "Order Requests Detail",
                          fontColor: AppColors.whiteColor,
                          fontSize: 18.sp,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(width: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomText(
                text: "Customer",
                fontSize: 20.sp,
                weight: FontWeight.bold,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.yellow2,
                          width: 2.w,
                        ),
                        image: DecorationImage(
                          image: AssetImage(AssetsPath.dummy),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CustomText(text: "John Smith", fontSize: 18.sp),
                ],
              ),
              CustomText(
                text: "Order Details",
                fontSize: 18.sp,
                weight: FontWeight.bold,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 10.h),

              CustomText(
                text: "Product: Lorem Ipsum",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              CustomText(
                text: "Qty: 2",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              CustomText(
                text: "Order Number: 123456789",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              CustomText(
                text: "Placed on: 01-06-2025",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 30.h),
              CustomText(
                text: "Address",
                fontSize: 18.sp,
                weight: FontWeight.bold,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: "Lorem Ipsum road street 21 California USA",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Payment Method",
                    fontSize: 18.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.blackColor,
                  ),
                  CustomText(
                    text: "Master Card *****4544",
                    fontSize: 18.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Total Bill",
                    fontSize: 18.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.blackColor,
                  ),
                  CustomText(
                    text: "\$20.00",
                    fontSize: 18.sp,
                    fontColor: AppColors.yellow2,
                  ),
                ],
              ),
              SizedBox(height: 60.h),

              // === Conditional Rendering ===
              if (widget.isCancelled) ...[
                // 🟥 Cancelled Order
                CustomText(
                  text: "Order Cancelled",
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.blackColor,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: "Cancellation Reason",
                  fontSize: 18.sp,
                  fontColor: AppColors.blackColor,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text:
                      "Lorem ipsum dolor sit amet consectetur adipiscing elit nec est, primis sem",
                  fontSize: 18.sp,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  fontColor: AppColors.blackColor,
                ),

                // 🟨 Order Not Accepted Yet
              ] else if (!isAccepted) ...[
                Padding(
                  padding: EdgeInsets.only(top: 150.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        width: 160.w,
                        text: "Reject",
                        onTap: () {
                          errorSnackBar("Order rejected!", context);
                        },
                        verticalPadding: 20.h,
                        gradientColors: [
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                        ],

                        borderColor: AppColors.blackColor,
                      ),
                      CustomButton(
                        width: 160.w,
                        text: "Accept",
                        onTap: () {
                          setState(() {
                            isAccepted = true;
                            isCurrent = true; // ✅ Start stepper flow
                            currentStep = 0;
                            text = "Ready for Pickup";
                          });
                        },
                        verticalPadding: 20.h,
                        gradientColors: [AppColors.yellow1, AppColors.yellow2],

                        borderColor: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),

                // 🟩 Accepted & Current (Normal flow)
              ] else if (isCurrent) ...[
                HorizontalStepper(currentStep: currentStep, steps: steps),
                SizedBox(height: 20.h),
                CustomText(
                  text: "Select Order Status",
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.yellow2,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: text,
                  onTap: () async {
                    if (currentStep == 0) {
                      final result = await showAddDeliveryPersonnelDialog(
                        context,
                      );
                      if (result == true) {
                        setState(() {
                          currentStep = 1;
                          text = "Order Handed to Delivery Personnel";
                        });
                      }
                    } else if (currentStep == 1) {
                      setState(() {
                        currentStep = 2;
                        text = "Order Completed";
                      });
                    } else if (currentStep == 2) {
                      final confirmResult =
                          await orderCompleteConfirmationDialog(context);
                      if (confirmResult == true) {
                        setState(() {
                          currentStep = 3;
                        });
                      }
                    } else if (currentStep >= 3) {
                      errorSnackBar("Order already delivered!", context);
                    }
                  },
                ),

                // ✅ Completed Order
              ] else ...[
                HorizontalStepper(currentStep: steps.length, steps: steps),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
