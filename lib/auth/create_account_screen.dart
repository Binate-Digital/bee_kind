import 'dart:io';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_fonts.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(
      AuthController(),
      permanent: true,
    );

    return CustomScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: CustomText(
                text: "Create Account",
                fontSize: 22.sp,
                weight: FontWeight.bold,
              ),
            ),

            Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    hint: "Email",
                    prefxicon: AssetsPath.email,
                    controller: controller.emailCtrl,
                    validator: (value) => Validation.validateEmail(value),
                  ),
                  SizedBox(height: 15.h),

                  // Password field
                  Obx(
                    () => CustomTextField(
                      hint: "Password",
                      prefxicon: AssetsPath.password,
                      isSuffixIcon: true,
                      isObscure: controller.isObscure.value,
                      validator: (value) => Validation.validatePassword(value),
                      controller: controller.passwordCtrl,
                      suffixIcon: GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: Icon(
                          controller.isObscure.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.blackColor.withValues(alpha: 0.4),
                          size: 25.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Confirm password field
                  Obx(
                    () => CustomTextField(
                      hint: "Confirm Password",
                      prefxicon: AssetsPath.password,
                      isSuffixIcon: true,
                      controller: controller.confirmPasswordCtrl,
                      validator: (value) => Validation.validateConfirmPassword(
                        value,
                        controller.passwordCtrl.text,
                      ),
                      onchange: (value) => Validation.validateConfirmPassword(
                        value,
                        controller.passwordCtrl.text,
                      ),
                      isObscure: controller.isAlsoObscure.value,
                      suffixIcon: GestureDetector(
                        onTap: controller.toggleConfirmPasswordVisibility,
                        child: Icon(
                          controller.isAlsoObscure.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.blackColor.withValues(alpha: 0.4),
                          size: 25.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  Obx(
                    () => Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: CustomButton(
                        onTap: () => controller.handleSignUp(context),
                        text: "Sign Up",
                        isLoading: controller.isLoading.value,
                        borderColor: AppColors.blackColor,
                        verticalPadding: 20.h,
                        horizontalPadding: 10.w,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),

                  // Checkbox + Terms
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Checkbox(
                              value: controller.isChecked.value,
                              checkColor: AppColors.yellow2,
                              onChanged: controller.toggleTerms,
                              fillColor: WidgetStateProperty.all(
                                AppColors.yellow1.withValues(alpha: 0.2),
                              ),
                              side: BorderSide(
                                color: AppColors.yellow2,
                                width: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 330.w,
                            child: RichText(
                              softWrap: true,
                              text: TextSpan(
                                text: "By sign-in you agree to our ",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.blackColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.blackColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " & ",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.blackColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  socialLoginButton(
                    // onTap: controller.signInWithGoogle,
                    icon: AssetsPath.google,
                    buttonColor: Colors.red,
                    text: "Sign Up with Google",
                  ),
                  SizedBox(height: 20.h),

                  Platform.isIOS
                      ? socialLoginButton(
                          onTap: controller.signInWithApple,
                          icon: AssetsPath.apple,
                          buttonColor: AppColors.blackColor,
                          text: "Sign Up with Apple",
                        )
                      : const Offstage(),

                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 35.h,
                      top: Platform.isIOS ? 30.h : 60.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Already have an account?\t\t",
                          fontSize: 22.sp,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: CustomText(
                            text: "Sign In",
                            fontSize: 22.sp,
                            underlined: true,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget socialLoginButton({
    VoidCallback? onTap,
    String? text,
    Color? buttonColor,
    String? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
          color: buttonColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon!, width: 22.w),
              SizedBox(width: 10.w),
              CustomText(
                text: text,
                weight: FontWeight.bold,
                fontColor: AppColors.whiteColor,
                fontSize: 18.sp,
                fontFamily: AppFonts.ralewayBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
