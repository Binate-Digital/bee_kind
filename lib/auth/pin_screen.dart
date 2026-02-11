import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/circular_timer.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../controllers/pin_controller.dart';
import '../services/shared_prefs_services.dart'; // adjust import path

class PinScreen extends StatelessWidget {
  const PinScreen({super.key, this.isAccountCreate = false});
  final bool isAccountCreate;

  @override
  Widget build(BuildContext context) {
    final PinController controller = Get.put(PinController(isAccountCreate));

    return CustomScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: GestureDetector(

                  onTap: (){
                    final SharedPrefs prefs = SharedPrefs();
                    print(prefs.getUserToken());
                  },
                  child: CustomText(
                    text: "Verification",
                    fontSize: 22.sp,
                    weight: FontWeight.bold,
                  ),
                ),
              ),

              // OTP Field
              OtpPinField(
                autoFocus: false,
                autoFillEnable: false,
                key: controller.otpPinFieldKey,
                textInputAction: TextInputAction.done,
                onCodeChanged: (code) {
                  if (controller.showError.value && code.isNotEmpty) {
                    controller.clearError();
                  }
                },
                otpPinFieldStyle: OtpPinFieldStyle(
                  showHintText: false,
                  fieldBorderRadius: 30.r,
                  fieldBorderWidth: 1.5,
                  fieldPadding: 5.w,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.blackColor,
                  ),
                  activeFieldBorderColor: AppColors.yellow2,
                  defaultFieldBorderColor: AppColors.yellow1.withValues(
                    alpha: 0.2,
                  ),
                  defaultFieldBackgroundColor: AppColors.yellow1.withValues(
                    alpha: 0.2,
                  ),
                  activeFieldBackgroundColor: AppColors.yellow1.withValues(
                    alpha: 0.2,
                  ),
                  filledFieldBackgroundColor: AppColors.yellow1.withValues(
                    alpha: 0.2,
                  ),
                  filledFieldBorderColor: AppColors.yellow2,
                ),
                maxLength: 6,
                showCursor: true,
                cursorColor: AppColors.yellow2,
                cursorWidth: 3,
                mainAxisAlignment: MainAxisAlignment.center,
                otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                onSubmit: (String text) {},
                onChange: (String text) {},
              ),

              // Error Text
              Obx(
                () => Visibility(
                  visible: controller.showError.value,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              // Continue button
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(bottom: 45.h),
                  child: CustomButton(
                    onTap: controller.validateAndContinue,
                    isLoading: controller.isLoading.value,
                    text: "Continue",
                    borderColor: AppColors.blackColor,
                    verticalPadding: 20.h,
                    horizontalPadding: 10.w,
                    fontSize: 18.sp,
                  ),
                ),
              ),

              // Circular timer
              Obx(
                () => CircularTimer(
                  size: 150,
                  formattedTime: controller.formattedTime.value,
                  strokeWidth: 2.5,
                  progress: controller.progress.value,
                ),
              ),

              SizedBox(height: 50.h),

              // Resend section
              Obx(
                () => controller.isTimerActive.value == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Didn't receive the code?\t\t\t",
                            fontSize: 18.sp,
                          ),
                          GestureDetector(
                            onTap: () => controller.showOTPSnackBar(context),
                            child: CustomText(
                              text: "Resend",
                              underlined: true,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      )
                    : const Offstage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
