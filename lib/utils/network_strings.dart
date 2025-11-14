class NetworkStrings {
  ///BASE URL
  static const String baseUrl =
      "https://beekind-backend.deployment-uat.com/api/v1/";

  ///AUTHENTICATION
  static const String login = "auth/login";
  static const String signup = "auth/signup";
  static const String verifyOtp = "auth/verify-otp";
  static const String resendOtp = "auth/resend-otp";
  static const String forgotPassword = "auth/forget-password";
  static const String resetPassword = "auth/reset-password";
  static const String getProfile = "auth/get-profile";
  static const String completeProfile = "auth/complete-profile";
  static const String updateProfile = "auth/update-profile";
  static const String deleteAccount = "auth/delete-account";

  ///STATUS CODES
  static const int success = 200;
  static const int internalServerError = 500;
  static const int unauthorized = 401;
  static const int badRequest = 400;
  static const int forbidden = 403;

  /////////// API MESSAGES /////////////////
  static const int apiSuccessStatus = 1;

  /////// API HEADER TEXT ////////////////////////
  static const String accept = 'application/json';

  ///USER

  ///VENDOR
}
