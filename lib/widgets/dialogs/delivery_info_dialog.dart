import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showAddDeliveryPersonnelDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      // Text editing controllers
      final carColorController = TextEditingController();
      final carMakeController = TextEditingController();
      final carNumberPlateController = TextEditingController();
      final phoneNumberController = TextEditingController();

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.w),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // === Heading ===
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  decoration: BoxDecoration(
                    color: AppColors.yellow2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: CustomText(
                    text: "Add Delivery Personnel Detail",
                    fontSize: 20.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.blackColor,
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 20.w,
                  ),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // === Delivery Person Image ===
                        Container(
                          width: 120.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: AppColors.yellow1,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.yellow2,
                              width: 2.w,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              AssetsPath.deliveryPerson,
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        CustomTextField(hint: "Delivery Personnel Name"),

                        SizedBox(height: 30.h),

                        // === Car Info ===
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: "Car Details",
                            fontSize: 18.sp,
                            weight: FontWeight.bold,
                            fontColor: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hint: "Color",
                          controller: carColorController,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hint: "Make",
                          controller: carMakeController,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hint: "Number Plate",
                          controller: carNumberPlateController,
                        ),

                        SizedBox(height: 20.h),

                        // === Phone Number ===
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: "Phone Number",
                            fontSize: 18.sp,
                            weight: FontWeight.bold,
                            fontColor: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hint: "Enter phone number",
                          keyboardType: TextInputType.phone,
                          controller: phoneNumberController,
                        ),

                        SizedBox(height: 30.h),

                        // === Buttons ===
                        CustomButton(
                          text: "Add",
                          onTap: () {
                            // ✅ Return true when adding successfully
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
