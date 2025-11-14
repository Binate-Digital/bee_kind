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
import '../../controllers/auth_controller.dart'; // adjust import path as needed

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

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
              key: controller.forgotFormKey,
              child: CustomTextField(
                hint: "Email",
                prefxicon: AssetsPath.email,
                validator: (value) => Validation.validateEmail(value),
                controller: controller.forgotEmailCtrl,
              ),
            ),

            SizedBox(height: 15.h),

            Obx(
              () => Padding(
                padding: EdgeInsets.only(bottom: 215.h),
                child: CustomButton(
                  onTap: () => controller.handleForgotPassword(context),
                  text: "Continue",
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
    );
  }
}
