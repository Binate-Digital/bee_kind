import 'dart:developer';

import 'package:bee_kind/auth/pin_screen.dart';
import 'package:bee_kind/auth/sign_in_screen.dart';
import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/models/data_models/login_data_model.dart';
import 'package:bee_kind/models/response_models/login_response_model.dart';
import 'package:bee_kind/models/data_models/sign_up_data_model.dart';
import 'package:bee_kind/models/response_models/signup_response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  final SharedPrefs prefs = SharedPrefs();
  final network = Network();

  // ---------------- CREATE ACCOUNT ----------------
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxBool isObscure = true.obs;
  RxBool isAlsoObscure = true.obs;
  RxBool isChecked = false.obs;

  RxBool isLoading = false.obs;

  String role = "";

  void togglePasswordVisibility() => isObscure.toggle();
  void toggleConfirmPasswordVisibility() => isAlsoObscure.toggle();
  void toggleTerms(bool? value) => isChecked.value = value ?? false;

  @override
  void onInit() async {
    // Load role
    role = prefs.getString('role') ?? "";
    log("ONINT TOKEN ${prefs.getUserToken()}"); // For debugging
    super.onInit();
  }

  void handleSignUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (!isChecked.value) {
      AppDialogs.showToast("Please accept the terms and conditions.");
      return;
    }

    try {
      isLoading.value = true;
      final model = SignUpDataModel(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
        role: role,
      );

      log(" Signup body: ${model.toJson()}");

      final response = await network.postRequest(
        endPoint: NetworkStrings.signup,
        data: model.toJson(),
      );

      if (response != null && response.statusCode == NetworkStrings.success) {
        final signUpResponse = SignUpResponseModel.fromJson(response.data);

        log(" Signup Response Parsed: ${signUpResponse.toJson()}");

        if (signUpResponse.status == true) {
          //  Save important info locally
          await prefs.setGlobalEmail(signUpResponse.data?.email ?? "");
          await prefs.setuserId(signUpResponse.data?.userId ?? "");
          await prefs.setRole(model.role);

          log(
            " Stored user info -> "
            "Email: ${signUpResponse.data?.email}, "
            "UserId: ${signUpResponse.data?.userId}, "
            "Role: ${model.role}",
          );

          isLoading.value = false;

          Get.off(() => const PinScreen(isAccountCreate: true));
        } else {
          isLoading.value = false;
          log(" Signup API returned status=false");
        }
      } else {
        log(" Signup failed with response: ${response?.data}");
        AppDialogs.showToast(response?.data["message"]);
        isLoading.value = false;
      }
    } catch (e) {
      log("Signup exception: $e");
      isLoading.value = false;
      AppDialogs.showToast("Something went wrong. Please try again.");
    }
  }

  // ---------------- SIGN IN ----------------
  final loginEmailCtrl = TextEditingController();
  final loginPasswordCtrl = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  RxBool loginObscure = true.obs;

  void toggleLoginPasswordVisibility() => loginObscure.toggle();

  void handleSignIn() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final model = LoginDataModel(
        email: loginEmailCtrl.text.trim(),
        password: loginPasswordCtrl.text.trim(),
        role: role,
      );

      log("Login body: ${model.toJson()}");

      final response = await network.postRequest(
        endPoint: NetworkStrings.login,
        data: model.toJson(),
      );

      final loginResponse = LoginResponseModel.fromJson(response?.data);

      if (response != null && response.statusCode == NetworkStrings.success) {
        log("Login Response Parsed: ${loginResponse.toJson()}");

        if (loginResponse.status == true) {
          // Save user data locally
          await prefs.setGlobalEmail(loginResponse.data?.email ?? "");
          await prefs.setuserId(loginResponse.data?.sId ?? "");
          await prefs.isProfileComplete(
            loginResponse.data?.isProfileCompleted ?? false,
          );
          await prefs.setuserToken(loginResponse.data?.userAuthToken ?? "");
          log("token is during sign in: ${prefs.getUserToken()}");

          log(
            "Stored user data -> "
            "Email: ${loginResponse.data?.email}, "
            "Role: ${loginResponse.data?.role}, "
            "isProfileCompleted: ${loginResponse.data?.isProfileCompleted}"
            "Token: ${loginResponse.data?.userAuthToken}",
          );

          isLoading.value = false;

          Get.off(() => BaseView());
        } else {
          isLoading.value = false;
          AppDialogs.showToast(
            loginResponse.message ?? "Login failed. Check credentials.",
          );
        }
      } else {
        isLoading.value = false;
        AppDialogs.showToast(
          loginResponse.message ?? "Login failed. Check credentials.",
        );
      }
    } catch (e) {
      log("Login exception: $e");
      isLoading.value = false;
    }
  }

  // ---------------- FORGOT PASSWORD ----------------
  final forgotEmailCtrl = TextEditingController();
  final forgotFormKey = GlobalKey<FormState>();

  void handleForgotPassword(BuildContext context) async {
    log('forgot password token: ${prefs.getUserToken()}');
    if (!forgotFormKey.currentState!.validate()) {
      log("Invalid email for password reset");
      return;
    }

    try {
      isLoading.value = true;
      final body = {"email": forgotEmailCtrl.text.trim()};

      log("Forgot Password body: $body");

      final response = await network.postRequest(
        endPoint: NetworkStrings.forgotPassword,
        data: body,
      );

      if (response != null && response.statusCode == NetworkStrings.success) {
        final responseData = response.data;

        log("Forgot Password Response: $responseData");

        if (responseData['status'] == true) {
          isLoading.value = false;
          AppDialogs.showToast(responseData['message'] ?? "");
          Get.to(() => const PinScreen());
        } else {
          isLoading.value = false;
          AppDialogs.showToast(responseData['message'] ?? "Failed to send OTP");
        }
      } else {
        log("Forgot Password failed: ${response?.data}");
        isLoading.value = false;
        AppDialogs.showToast("Failed to send OTP. Please try again.");
      }
    } catch (e) {
      log("Forgot Password exception: $e");
      isLoading.value = false;
      AppDialogs.showToast("Something went wrong. Please try again.");
    }
  }

  // ---------------- RESET PASSWORD ----------------
  final resetPasswordCtrl = TextEditingController();
  final resetConfirmPasswordCtrl = TextEditingController();
  final resetFormKey = GlobalKey<FormState>();

  RxBool resetIsObscure = true.obs;
  RxBool resetIsAlsoObscure = true.obs;

  void toggleResetPasswordVisibility() => resetIsObscure.toggle();
  void toggleResetConfirmPasswordVisibility() => resetIsAlsoObscure.toggle();

  void handleResetPassword() async {
    log('message ${prefs.getUserToken()}');
    if (!resetFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final userId = prefs.getUserId() ?? "";

      log("USER ID RESET PASSWORD: $userId");

      if (userId.isEmpty) {
        isLoading.value = false;
        AppDialogs.showToast("User ID not found. Please log in again.");
        return;
      }

      final body = {
        "userId": userId,
        "newPassword": resetPasswordCtrl.text.trim(),
      };

      log("Reset Password body: $body");

      final response = await network.postRequest(
        endPoint: NetworkStrings.resetPassword,
        data: body,
      );

      if (response != null && response.statusCode == NetworkStrings.success) {
        final responseData = response.data;

        log("Reset Password Response: $responseData");

        if (responseData['status'] == true) {
          isLoading.value = false;
          AppDialogs.showToast(responseData['message'] ?? "");
          Get.offAll(() => const SignInScreen());
        } else {
          isLoading.value = false;
          AppDialogs.showToast(
            responseData['message'] ?? "Password reset failed",
          );
        }
      } else {
        log("Reset Password failed: ${response?.data}");
        isLoading.value = false;
        AppDialogs.showToast("Password reset failed. Please try again.");
      }
    } catch (e) {
      log("Reset Password exception: $e");
      isLoading.value = false;
      AppDialogs.showToast("Something went wrong. Please try again.");
    }
  }

  // ---------------- SOCIAL LOGIN ----------------
  Future<void> signInWithGoogle() async {
    try {
      // Singleton instance from the new API
      final google = GoogleSignIn.instance;

      // Safe to call multiple times; if you've already initialized in main(),
      // this just returns quickly.
      await google.initialize();

      if (!google.supportsAuthenticate()) {
        log('GoogleSignIn.authenticate() is not supported on this platform');
        return;
      }

      log('Starting Google Sign-In...');

      await GoogleSignIn.instance.disconnect();
      await GoogleSignIn.instance.signOut();

      // New API: authenticate()
      final GoogleSignInAccount user = await google.authenticate();

      // ---- User details ----
      log('Google user details:');
      log('  displayName: ${user.displayName}');
      log('  email      : ${user.email}');
      log('  id         : ${user.id}');
      log('  photoUrl   : ${user.photoUrl}');

      // ---- Token (only idToken exists in v7+) ----
      final GoogleSignInAuthentication auth = user.authentication;
      log('Google idToken: ${auth.idToken}');

      log('Google Login Successful ✔');
    }
    // on GoogleSignInException catch (e) {
    //   // Nice error handling for cancel vs other errors
    //   // if (e.code == GoogleSignInExceptionCode.canceled) {
    //   //   log('Google Sign-In cancelled by user');
    //   // } else {
    //   //   log('GoogleSignInException ${e.code}: ${e.description}');
    //   // }
    // }
    catch (e) {
      log('Google Sign-In Error: $e');
    }
  }

  Future<void> signInWithApple() async {
    try {
      log('Starting Apple Sign-In...');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // ---- User details ----
      log('Apple user details:');
      log('  userIdentifier : ${credential.userIdentifier}');
      log('  email          : ${credential.email}');
      log('  givenName      : ${credential.givenName}');
      log('  familyName     : ${credential.familyName}');

      // ---- Tokens ----
      log('Apple identityToken    : ${credential.identityToken}');
      log('Apple authorizationCode: ${credential.authorizationCode}');

      log('Apple Login Successful ✔');
    } on SignInWithAppleAuthorizationException catch (e) {
      log('Apple Sign-In error: ${e.code} – ${e.message}');
    } catch (e) {
      log('Apple Sign-In error: $e');
    }
  }

  // clear fields
  clearAll() {
    emailCtrl.clear();
    passwordCtrl.clear();
    confirmPasswordCtrl.clear();
    loginEmailCtrl.clear();
    loginPasswordCtrl.clear();
    forgotEmailCtrl.clear();
    resetPasswordCtrl.clear();
    resetConfirmPasswordCtrl.clear();
  }

  @override
  void onClose() {
    clearAll();
    super.onClose();
  }
}
