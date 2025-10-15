import 'dart:async';

import 'package:bee_kind/auth/reset_password_screen.dart';
import 'package:bee_kind/core/user/user_profile_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/circular_timer.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key, this.isAccountCreate = false});
  final bool isAccountCreate;

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  Timer? _timer;
  int countdown = 60;
  double progress = 1.0;
  bool isTimerActive = false;
  bool showError = false;
  String errorMessage = "";

  final otpPinFieldController = GlobalKey<OtpPinFieldState>();

  void showOTPSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "An OTP has been sent to you!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color:
                AppColors.blackColor, // Assuming you want black text on yellow
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.yellow1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        margin: EdgeInsets.all(20),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void validateAndContinue() {
    final currentOtp = otpPinFieldController.currentState?.controller.text;

    final validationError = Validation.validateOtp(currentOtp);

    if (validationError == null) {
      setState(() {
        showError = false;
        errorMessage = '';
      });
      _timer?.cancel();
      widget.isAccountCreate
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ResetPasswordScreen()),
            );
    } else {
      setState(() {
        showError = true;
        errorMessage = validationError;
      });
    }
  }

  void clearError() {
    setState(() {
      showError = false;
      errorMessage = '';
    });
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      countdown = 60;
      progress = 1.0;
      isTimerActive = true;

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          setState(() {
            countdown--;
            progress = countdown / 60;
          });
        } else {
          setState(() {
            timer.cancel();
            isTimerActive = false;
            progress = 0.0;
          });
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      _timer?.cancel();
      startTimer();
    });
  }

  String get formattedTime {
    final seconds = countdown;
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: CustomText(
                  text: "Verification",
                  fontSize: 22.sp,
                  weight: FontWeight.bold,
                ),
              ),
              OtpPinField(
                autoFocus: false,
                autoFillEnable: false,
                key: otpPinFieldController,
                textInputAction: TextInputAction.done,
                onSubmit: (text) {},
                onChange: (text) {},

                onCodeChanged: (code) {
                  debugPrint('onCodeChanged is $code');
                  if (showError && code.isNotEmpty) {
                    clearError();
                  }
                },
                otpPinFieldStyle: OtpPinFieldStyle(
                  showHintText: false,
                  fieldBorderRadius: 30.r,
                  fieldBorderWidth: 1.5,
                  fieldPadding: 8.w,
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
              ),
              Visibility(
                visible: showError,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 16.sp),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          errorMessage,
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
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.only(bottom: 45.h),
                child: CustomButton(
                  onTap: () => validateAndContinue(),
                  text: "Continue",
                  borderColor: AppColors.blackColor,
                  verticalPadding: 20.h,
                  horizontalPadding: 10.w,
                  fontSize: 18.sp,
                ),
              ),
              CircularTimer(
                size: 150,
                formattedTime: formattedTime,
                strokeWidth: 2.5,
                progress: progress,
              ),
              SizedBox(height: 50.h),
              isTimerActive == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Didn't recieve the code?\t\t\t",
                          fontSize: 18.sp,
                        ),
                        GestureDetector(
                          onTap: () => showOTPSnackBar(context),
                          child: CustomText(
                            text: "Resend",
                            underlined: true,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    )
                  : Offstage(),
            ],
          ),
        ),
      ),
    );
  }
}
