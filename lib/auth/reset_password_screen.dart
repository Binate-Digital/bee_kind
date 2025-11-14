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
import '../../controllers/auth_controller.dart'; // adjust path if needed

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return CustomScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: controller.resetFormKey,
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

              // Password field
              Obx(
                () => CustomTextField(
                  hint: "Password",
                  prefxicon: AssetsPath.password,
                  controller: controller.resetPasswordCtrl,
                  validator: (value) => Validation.validatePassword(value),
                  isSuffixIcon: true,
                  isObscure: controller.resetIsObscure.value,
                  suffixIcon: GestureDetector(
                    onTap: controller.toggleResetPasswordVisibility,
                    child: Icon(
                      controller.resetIsObscure.value
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
                  controller: controller.resetConfirmPasswordCtrl,
                  validator: (value) => Validation.validateConfirmPassword(
                    value,
                    controller.resetPasswordCtrl.text,
                  ),
                  isSuffixIcon: true,
                  isObscure: controller.resetIsAlsoObscure.value,
                  suffixIcon: GestureDetector(
                    onTap: controller.toggleResetConfirmPasswordVisibility,
                    child: Icon(
                      controller.resetIsAlsoObscure.value
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
                  padding: EdgeInsets.only(bottom: 215.h),
                  child: CustomButton(
                    onTap: controller.handleResetPassword,
                    text: "Reset Password",
                    isLoading: controller.isLoading.value,
                    borderColor: AppColors.blackColor,
                    verticalPadding: 20.h,
                    horizontalPadding: 10.w,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
