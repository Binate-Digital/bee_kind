import 'dart:developer';
import 'dart:io';

import 'package:bee_kind/auth/pin_screen.dart';
import 'package:bee_kind/auth/sign_in_screen.dart';
import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/common/create_profile_screen.dart';
import 'package:bee_kind/models/data_models/login_data_model.dart';
import 'package:bee_kind/models/response_models/login_response_model.dart';
import 'package:bee_kind/models/data_models/sign_up_data_model.dart';
import 'package:bee_kind/models/response_models/signup_response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../utils/global.dart';
import '../widgets/webview_flutter_widget.dart';
import 'firebase_services.dart';

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

          Get.offAll(() => const PinScreen(isAccountCreate: true));
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




  Future<void> debugFcm() async {
    final messaging = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print("iOS permission: ${settings.authorizationStatus}");

      // Try to read APNs token
      final apns = await messaging.getAPNSToken();
      print("APNs token: $apns");
    }

    final fcm = await messaging.getToken();
    print("FCM token: $fcm");
  }


  Future<String?> regenerateFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.deleteToken();   // delete old
    newToken = await messaging.getToken();

    print("Regenerated Token: $newToken");
    
    return newToken;
  }


    void handleSignIn() async {
      if (!loginFormKey.currentState!.validate()) return;

      try {
        isLoading.value = true;




        final model = LoginDataModel(
          email: loginEmailCtrl.text.trim(),
          password: loginPasswordCtrl.text.trim(),
          role: role,
          deviceToken: Global.fcmToken.toString(),
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
            print("loginResponse.message");
            print(loginResponse.message);
            //Save user data locally
            await prefs.setGlobalEmail(loginResponse.data?.email ?? "");
            await prefs.setuserId(loginResponse.data?.sId ?? "");
            await prefs.isProfileComplete(
              loginResponse.data?.isProfileCompleted ?? false,
            );

            log("Is Profile Complete Sign In: ${prefs.checkProfile()}");
            await prefs.setuserToken(loginResponse.data?.userAuthToken ?? "");
            log("token is during sign in: ${prefs.getUserToken()}");
            log("user Id: ${prefs.getUserId()}");
            log(
              "Stored user data -> "
              "Email: ${loginResponse.data?.email}, "
              "Role: ${loginResponse.data?.role}, "
              "isProfileCompleted: ${loginResponse.data?.isProfileCompleted}"
              "Token: ${loginResponse.data?.userAuthToken}",
            );
            //
            isLoading.value = false;
            //

            print("loginResponse.data?.stripeCustomerId");
            print(loginResponse.data?.stripeCustomerId);


            Global.access_token=loginResponse.data?.userAuthToken;


            print("Global.access_tokenGlobal.access_token${Global.access_token}");
            if (!prefs.checkProfile()) {
              if (loginResponse.message == "Vendor onboarding required") {
                AppDialogs.showToast(
                  loginResponse.message ?? "Something Went Wrong",
                );
                Get.to(
                  () => StripeOnboardingWebView(
                     onboardingUrl: response.data['data']['onboardingUrl'],
                  ),
                );
              } else {
                Get.to(() => CreateProfileScreen(Token: prefs.getUserToken().toString(),));
              }
            } else {
              Get.offAll(() => BaseView());
            }
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
          prefs.setuserId(responseData["data"]["userId"]);
          log("USER ID FORGOT PASSWORD: ${prefs.getUserId()}");
          Get.to(() => const PinScreen(isAccountCreate: false));
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

  String? newToken;

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

  // ---------------- SOCIAL SIGN-UP ----------------
  Future<void> signUpWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '665813359634-v0ibbh2ve7a4puuoi73nc0ikmresnh2v.apps.googleusercontent.com',
      );

      log('Starting Google Sign-Up...');

      await googleSignIn.signOut();

      final GoogleSignInAccount? user = await googleSignIn.signIn();

      if (user == null) {
        log('Google Sign-Up cancelled by user');
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication auth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final userData = userCredential.user;

      log('Firebase Sign-Up Success ✔');
      log('uid: ${userData?.uid}');
      log('email: ${userData?.email}');
      log('name: ${userData?.displayName}');
      log('photo: ${userData?.photoURL}');

      // Save Google email to SharedPrefs (same as regular signup)
      if (userData?.email != null) {
        await prefs.setGlobalEmail(userData!.email!);
        log('Google email saved: ${userData.email}');

        isLoading.value = false;

        // Navigate directly to Create Profile screen (skip OTP verification for Google)
        Get.offAll(() => CreateProfileScreen(Token: prefs.getUserToken().toString(),));
      } else {
        isLoading.value = false;
        AppDialogs.showToast("Failed to get email from Google account");
      }
    } catch (e) {
      log('Google Sign-Up Error: $e');
      isLoading.value = false;
      AppDialogs.showToast("Google sign-up failed. Please try again.");
    }
  }

  // ---------------- SOCIAL LOGIN ----------------
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '665813359634-v0ibbh2ve7a4puuoi73nc0ikmresnh2v.apps.googleusercontent.com',
      );

      log('Starting Google Sign-In...');

      await googleSignIn.signOut();

      final GoogleSignInAccount? user = await googleSignIn.signIn();

      if (user == null) {
        log('Google Sign-In cancelled by user');
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication auth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, // IMPORTANT
        idToken: auth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final userData = userCredential.user;

      log('Firebase Login Success ✔');
      log('uid: ${userData?.uid}');
      log('email: ${userData?.email}');
      log('name: ${userData?.displayName}');
      log('photo: ${userData?.photoURL}');
      log('idToken: ${auth.idToken}');

      // Call the social login API
      if (auth.idToken != null) {
        final socialLoginBody = {
          // "idToken": auth.idToken,
          "idToken": await userData?.getIdToken(),
          "provider": "google",
          "role": role.isNotEmpty ? role : "user",
          // Default to "user" if role is empty
        };

        log("Social Login API body: $socialLoginBody");

        final response = await network.postRequest(
          endPoint: NetworkStrings.firebaseSocialLogin,
          data: socialLoginBody,
        );

        if (response != null && response.statusCode == NetworkStrings.success) {
          final responseData = response.data;
          log("Social Login API Response: $responseData");

          if (responseData['status'] == true) {
            // Save user data locally (similar to regular login)
            final userData = responseData['data'];
            if (userData != null) {
              await prefs.setGlobalEmail(userData['email'] ?? "");
              await prefs.setuserId(
                userData['_id'] ?? userData['userId'] ?? "",
              );
              await prefs.isProfileComplete(
                userData['isProfileCompleted'] ?? false,
              );
              await prefs.setuserToken(userData['userAuthToken'] ?? "");

              log(
                "Social Login - Is Profile Complete: ${prefs.checkProfile()}",
              );
              log("Social Login - Token: ${prefs.getUserToken()}");
              log("Social Login - User ID: ${prefs.getUserId()}");

              if (!prefs.checkProfile()) {
                // Use offAll to prevent back navigation to undefined state
                Get.offAll(() => CreateProfileScreen(Token: prefs.getUserToken().toString(),));
              } else {
                Get.offAll(() => BaseView());
              }
            } else {
              AppDialogs.showToast("Invalid response from server");
            }
          } else {
            AppDialogs.showToast(
              responseData['message'] ?? "Social login failed",
            );
          }
        } else {
          log("Social Login API failed: ${response?.data}");
          AppDialogs.showToast(
            response?.data?['message'] ?? "Social login failed",
          );
        }
      } else {
        AppDialogs.showToast("Failed to get authentication token");
      }

      isLoading.value = false;
    } catch (e) {
      log('Google Sign-In Error: $e');
      isLoading.value = false;
      AppDialogs.showToast("Google sign-in failed. Please try again.");
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     // Google Sign-In instance with client ID
  //     final google = GoogleSignIn(
  //       clientId: '665813359634-v0ibbh2ve7a4puuoi73nc0ikmresnh2v.apps.googleusercontent.com',
  //     );

  //     log('Starting Google Sign-In...');

  //     await google.disconnect();
  //     await google.signOut();

  //     // Sign in
  //     final GoogleSignInAccount? user = await google.signIn();

  //     if (user == null) {
  //       log('Google Sign-In cancelled by user');
  //       return;
  //     }

  //     // ---- User details ----
  //     log('Google user details:');
  //     log('  displayName: ${user.displayName}');
  //     log('  email      : ${user.email}');
  //     log('  id         : ${user.id}');
  //     log('  photoUrl   : ${user.photoUrl}');

  //     // ---- Token ----
  //     final GoogleSignInAuthentication auth = await user.authentication;
  //     log('Google idToken: ${auth.idToken}');

  //     // Sign in to Firebase with Google credential
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       idToken: auth.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     final User? firebaseUser = userCredential.user;

  //     log('Firebase user signed in:');
  //     log('  uid       : ${firebaseUser?.uid}');
  //     log('  email     : ${firebaseUser?.email}');
  //     log('  displayName: ${firebaseUser?.displayName}');
  //     log('  photoURL  : ${firebaseUser?.photoURL}');

  //     log('Google Login Successful ✔');
  //   }
  //   // on GoogleSignInException catch (e) {
  //   //   // Nice error handling for cancel vs other errors
  //   //   // if (e.code == GoogleSignInExceptionCode.canceled) {
  //   //   //   log('Google Sign-In cancelled by user');
  //   //   // } else {
  //   //   //   log('GoogleSignInException ${e.code}: ${e.description}');
  //   //   // }
  //   // }
  //   catch (e) {
  //     log('Google Sign-In Error: $e');
  //   }
  // }

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
