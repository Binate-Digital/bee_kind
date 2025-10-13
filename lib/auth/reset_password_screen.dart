import 'package:bee_kind/auth/sign_in_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordCtrl = TextEditingController();

  TextEditingController confirmPasswordCtrl = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isObscure = true;

  bool isAlsoObscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: CustomText(
                  text: "Reset Password",
                  fontSize: 22.sp,
                  weight: FontWeight.bold,
                ),
              ),
              CustomTextField(
                hint: "Password",
                prefxicon: AssetsPath.password,
                controller: passwordCtrl,
                validator: (value) => Validation.validatePassword(value),
                isSuffixIcon: true,
                isObscure: isObscure,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  child: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.blackColor.withValues(alpha: 0.4),
                    size: 25.h,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              CustomTextField(
                hint: "Confirm Password",
                prefxicon: AssetsPath.password,
                controller: confirmPasswordCtrl,
                isSuffixIcon: true,
                validator: (value) => Validation.validateConfirmPassword(
                  value,
                  passwordCtrl.text,
                ),
                isObscure: isAlsoObscure,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isAlsoObscure = !isAlsoObscure;
                    });
                  },
                  child: Icon(
                    isAlsoObscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.blackColor.withValues(alpha: 0.4),
                    size: 25.h,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.only(bottom: 215.h),
                child: CustomButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => SignInScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  text: "Reset Password",
                  borderColor: AppColors.blackColor,
                  verticalPadding: 20.h,
                  horizontalPadding: 10.w,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
