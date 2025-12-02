// ignore_for_file: constant_identifier_names

class NetworkStrings {
  ///BASE URL
  static const String baseUrl =
      "https://beekind-backend.deployment-uat.com/api/v1/";
  // static const String baseUrl =
  //     "https://3dsr3m62-5000.uks1.devtunnels.ms/api/v1/";

  static const String NETWORK_IMAGE_BASE_URL =
      "https://beekind-backend.deployment-uat.com/";

  ///Stripe key and Cards
  static const String ADD_NEW_CARD_ENDPOINT = "auth/add-card";
  static const String getAllCards = "auth/get-all-cards";
  static const String deleteCard = "auth/delete-card";
  static const String setDefaultCard = "auth/set-default-card";
  static const String STRIPE_KEY =
      "pk_test_51SD602EF5AumznfWxP9Rio1Fv3oo0LaoLHcBl64s1hJohMJeE1Qmqjg2ivwIqLrzY17bwj9ArJwLLVemgZbP0M3V007MdBvFrR";

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
  static const String verifyVeriff = 'auth/create-veriff-session';
  static const String USER_SUCCESS_URL =
      'https://beekind-backend.deployment-uat.com/api/v1/veriff/callback';

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
  static const String getAddresses = "user/get-user-addresses";
  static const String addAddress = "user/add-address";
  static const String updateUserAddress = "user/update-user-address";

  ///STORE
  static const String getCategories = "user/categories";
  static const String getStores = "user/stores";
  static const String createOrder = "user/create-order";
  static const String fetchOrders = "user/orders";
  static const String getSingleOrder = "user/get-order";
  static const String cancelOrder = "user/cancel-order";
  static const String getStoreDetail = "user/store-details";
  static const String getProductsByCategory = "user/products-by-category";
  static const String getSingleProduct = "user/product";
  static const String getProductReviews = "user/product-reviews";

  ///VENDOR
}
