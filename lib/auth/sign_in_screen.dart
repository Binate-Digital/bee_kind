import 'package:bee_kind/auth/create_account_screen.dart';
import 'package:bee_kind/auth/forgot_password_screen.dart';
import 'package:bee_kind/controllers/auth_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    return CustomScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: CustomText(
                text: "Sign In",
                fontSize: 22.sp,
                weight: FontWeight.bold,
              ),
            ),
            Form(
              key: controller.loginFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    hint: "Email",
                    prefxicon: AssetsPath.email,
                    validator: (value) => Validation.validateEmail(value),
                    controller: controller.loginEmailCtrl,
                  ),
                  SizedBox(height: 15.h),
                  Obx(
                    () => CustomTextField(
                      hint: "Password",
                      prefxicon: AssetsPath.password,
                      isSuffixIcon: true,
                      isObscure: controller.loginObscure.value,
                      controller: controller.loginPasswordCtrl,
                      validator: (value) => Validation.validatePassword(value),
                      suffixIcon: GestureDetector(
                        onTap: controller.toggleLoginPasswordVisibility,
                        child: Icon(
                          controller.loginObscure.value
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
                        onTap: controller.handleSignIn,
                        borderColor: AppColors.blackColor,
                        text: "Sign In",
                        isLoading: controller.isLoading.value,
                        verticalPadding: 20.h,
                        horizontalPadding: 10.w,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () => Get.to(() => ForgotPasswordScreen()),
                    child: CustomText(
                      text: "Forgot your password?",
                      fontSize: 22.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 250.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Don't have an account?\t\t",
                          fontSize: 22.sp,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Get.to(() => const CreateAccountScreen()),
                          child: CustomText(
                            text: "Sign Up",
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
}
