import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      button: Container(
        color: AppColors.whiteColor,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: CustomButton(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BaseView()),
          ),
          text: "Pay Now",
          borderColor: AppColors.blackColor,
          verticalPadding: 20.h,
          horizontalPadding: 10.w,
          fontSize: 18.sp,
        ),
      ),
      title: "Payment",
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            CustomTextField(hint: "Card Holder Name"),

            SizedBox(height: 10.h),

            CustomTextField(hint: "Account Number"),

            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: CustomTextField(hint: "Exp Date"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: CustomTextField(hint: "CVV"),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(
                  width: 40.w,
                  child: Checkbox(
                    value: isChecked,
                    checkColor: AppColors.yellow2,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    fillColor: WidgetStateProperty.all(
                      AppColors.yellow1.withValues(alpha: 0.2),
                    ),
                    side: BorderSide(color: AppColors.yellow2, width: 1),
                  ),
                ),
                SizedBox(
                  width: 350.w,
                  child: CustomText(
                    text: "Save Details.",
                    fontSize: 15.sp,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    weight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
