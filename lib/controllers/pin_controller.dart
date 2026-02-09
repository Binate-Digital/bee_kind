import 'dart:async';
import 'dart:developer';
import 'package:bee_kind/auth/reset_password_screen.dart';
import 'package:bee_kind/common/create_profile_screen.dart';
import 'package:bee_kind/controllers/profile_controller.dart';
import 'package:bee_kind/models/data_models/otp_verification_data_model.dart';
import 'package:bee_kind/models/response_models/otp_verification_response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class PinController extends GetxController {
  final bool isAccountCreate;

  PinController(this.isAccountCreate);

  final SharedPrefs prefs = SharedPrefs();
  final network = Network();

  final otpPinFieldKey = GlobalKey<OtpPinFieldState>();

  Timer? _timer;
  RxInt countdown = 60.obs;
  RxDouble progress = 1.0.obs;
  RxBool isTimerActive = false.obs;
  RxBool showError = false.obs;
  RxString errorMessage = ''.obs;

  RxBool isLoading = false.obs;

  // Computed formatted time
  RxString formattedTime = '1:00'.obs;

  @override
  void onInit() {
    super.onInit();
    log("IS ACCOUNT CREATE: $isAccountCreate");
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    countdown.value = 60;
    progress.value = 1.0;
    isTimerActive.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
        progress.value = countdown.value / 60;
        formattedTime.value =
            '${countdown.value ~/ 60}:${(countdown.value % 60).toString().padLeft(2, '0')}';
      } else {
        timer.cancel();
        isTimerActive.value = false;
        progress.value = 0.0;
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
  }

  void clearError() {
    showError.value = false;
    errorMessage.value = '';
  }

  void showOTPSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "An OTP has been sent to you!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.yellow1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.all(20),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  Future<void> validateAndContinue() async {
    final currentOtp = otpPinFieldKey.currentState?.controller.text;

    clearError();
    // _timer?.cancel();

    try {
      final userId = prefs.getUserId() ?? "";
      log("USER ID PIN SCREEN: $userId");
      if (userId.isEmpty) {
        AppDialogs.showToast("User ID not found. Please try signing up again.");
        return;
      }

      final model = isAccountCreate
          ? OtpVerificationDataModel(
              userId: userId,
              otp: currentOtp,
              purpose: "signup",
            )
          : OtpVerificationDataModel(userId: userId, otp: currentOtp);

      isLoading.value = true;

      log("Verify OTP body: ${model.toJson()}");

      final response = await network.postRequest(
        endPoint: NetworkStrings.verifyOtp,
        data: model.toJson(),
        isHeaderRequire: false,
      );

      final responseData = OtpVerificationResponseModel.fromJson(
        response?.data,
      );

      if (response != null && response.statusCode == NetworkStrings.success) {
        log("Verify OTP Response: $responseData");

        if (responseData.status == true) {
          isLoading.value = false;

          prefs.setuserToken(responseData.data?.userAuthToken ?? "");
          log("USER AUTH TOKEN: ${prefs.getUserToken()}");
          AppDialogs.showToast(
            responseData.message ?? "OTP verified successfully",
          );

          if (isAccountCreate) {
            ProfileController profileController=Get.put(ProfileController());
            profileController.resetProfileForm();
            Get.offAll(() => CreateProfileScreen());
          } else {
            Get.offAll(() => const ResetPasswordScreen());
          }
        } else {
          isLoading.value = false;
          AppDialogs.showToast(responseData.message ?? "Invalid OTP");
        }
      } else {
        log("Verify OTP failed: ${response?.data}");
        isLoading.value = false;
        AppDialogs.showToast(responseData.message ?? "Invalid OTP");
      }
    } catch (e) {
      log("Verify OTP exception: $e");
      isLoading.value = false;
      AppDialogs.showToast("Something went wrong. Please try again.");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
