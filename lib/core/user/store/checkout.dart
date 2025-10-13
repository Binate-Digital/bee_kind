import 'package:bee_kind/core/user/store/choose_payment_method.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/address_bar.dart';
import 'package:bee_kind/widgets/address_type.dart';
import 'package:bee_kind/widgets/cart_item.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isHomeChecked = false;
  bool isOfficeChecked = false;
  bool isApartmentChecked = false;
  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Checkout",
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
                  MaterialPageRoute(
                    builder: (context) => ChoosePaymentScreen(),
                  ),
                ),
                text: "Checkout",
                width: 300.w,
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            AddressBar(onTap: () {}, isEdit: true),
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
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 20.h),
                            AddressType(
                              isChecked: isHomeChecked,
                              type: "Home",
                              onChanged: (value) {
                                setModalState(() {
                                  isHomeChecked = value!;
                                });
                              },
                            ),
                            AddressType(
                              isChecked: isOfficeChecked,
                              type: "Office",
                              onChanged: (value) {
                                setModalState(() {
                                  isOfficeChecked = value!;
                                });
                              },
                            ),
                            AddressType(
                              isChecked: isApartmentChecked,
                              type: "Apartment",
                              onChanged: (value) {
                                setModalState(() {
                                  isApartmentChecked = value!;
                                });
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 30.h,
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
                                    text: "Change Address",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: CustomText(
                text: "Change Address",
                underlined: true,
                weight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: CustomTextField(
                hint: "Additional Notes",
                maxlines: 6,
                radius: 20.r,
                verticalPadding: 70.h,
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartItem();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
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
          ],
        ),
      ),
    );
  }
}
