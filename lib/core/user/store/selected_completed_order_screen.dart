import 'package:bee_kind/core/user/store/checkout.dart';
import 'package:bee_kind/core/user/store/ratings_and_reviews.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/completed_order_item.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedCompletedOrderScreen extends StatefulWidget {
  const SelectedCompletedOrderScreen({super.key});

  @override
  State<SelectedCompletedOrderScreen> createState() =>
      _SelectedCompletedOrderScreenState();
}

class _SelectedCompletedOrderScreenState
    extends State<SelectedCompletedOrderScreen> {
  int _currentStep = 0;
  double rating = 3.5;

  final List<String> _steps = [
    AssetsPath.box,
    AssetsPath.truck,
    AssetsPath.carry,
    AssetsPath.openBox,
  ];

  void nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Completed Order",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CheckoutScreen()),
              ),
              text: "Re-Order",
              gradientColors: [AppColors.whiteColor, AppColors.whiteColor],
            ),
            SizedBox(height: 20.h),
            CustomButton(
              onTap: () {
                showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 30.h,
                            horizontal: 20.h,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                text: "How is your order?",
                                weight: FontWeight.w600,
                                fontSize: 22.sp,
                              ),
                              SizedBox(height: 20.h),
                              CustomText(
                                text:
                                    "Please give your rating & also your review...",
                                fontSize: 18.sp,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20.h,
                                  bottom: 10.h,
                                ),
                                child: StarRating(
                                  size: 40.r,
                                  rating: rating,
                                  color: AppColors.yellow2,
                                  borderColor: Colors.grey,
                                  allowHalfRating: true,
                                  starCount: 5,
                                  onRatingChanged: (rate) => setModalState(() {
                                    rating = rate;
                                  }),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: CustomTextField(
                                  hint: "Write a Review",
                                  radius: 10.r,
                                  maxlines: 6,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              CustomButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RatingScreen(addReview: true),
                                    ),
                                  );
                                },
                                text: "Submit",
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              text: "Leave a Review",
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompletedOrderItem(hideDate: true),
            SizedBox(height: 20.h),
            HorizontalStepper(
              currentStep: _currentStep,
              steps: _steps,
              activeColor: AppColors.blackColor,
              inactiveColor: AppColors.whiteColor,
            ),
            SizedBox(height: 20.h),
            Container(color: AppColors.blackColor, height: 0.5.w),
            SizedBox(height: 20.h),
            CustomText(
              text: "Order Details",
              weight: FontWeight.bold,
              fontSize: 22.sp,
            ),
            SizedBox(height: 10.h),
            CustomText(text: "Vendor: Lorem Ipsum", fontSize: 18.sp),
            SizedBox(height: 10.h),
            CustomText(text: "Placed On: 01-01-2025", fontSize: 18.sp),
            SizedBox(height: 20.h),
            CustomText(
              text: "Address",
              weight: FontWeight.bold,
              fontSize: 22.sp,
            ),
            SizedBox(height: 10.h),
            CustomText(
              text: "Lorem Ipsum Road Street 21 California USA",
              fontSize: 18.sp,
            ),
            SizedBox(height: 20.h),
            CustomText(
              text: "Additional Notes",
              weight: FontWeight.bold,
              fontSize: 22.sp,
            ),
            SizedBox(height: 10.h),
            CustomText(
              text:
                  "Lorem ipsum dolor sit amet consectetur adipiscing elit nec est, primis sem",
              maxLines: 3,
              textAlign: TextAlign.start,
              fontSize: 18.sp,
            ),
            SizedBox(height: 20.h),
            Container(color: AppColors.blackColor, height: 0.5.w),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Payment Method",
                  weight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
                CustomText(text: "Master Card ****4544", fontSize: 18.sp),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Total Bill",
                  weight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
                CustomText(
                  text: "\$20.00",
                  fontSize: 20.sp,
                  fontColor: AppColors.yellow2,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
