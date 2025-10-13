import 'package:bee_kind/auth/pin_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: CustomText(
                text: "Forgot Password",
                fontSize: 22.sp,
                weight: FontWeight.bold,
              ),
            ),
            Form(
              key: formKey,
              child: CustomTextField(
                hint: "Email",
                prefxicon: AssetsPath.email,
                validator: (value) => Validation.validateEmail(value),
                controller: emailController,
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.only(bottom: 215.h),
              child: CustomButton(
                onTap: () => formKey.currentState!.validate()
                    ? Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => PinScreen()))
                    : debugPrint("invalid email error"),
                text: "Continue",
                borderColor: AppColors.blackColor,
                verticalPadding: 20.h,
                horizontalPadding: 10.w,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
