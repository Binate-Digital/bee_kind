// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer' as dev;
import 'dart:io';
import 'package:bee_kind/utils/app_navigation.dart';
import 'package:bee_kind/widgets/bottom_sheets/image_picker_bottom_sheet.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:dio/dio.dart' as dio;
import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/core/user/store/product_categories_list.dart';
import 'package:bee_kind/core/user/store/selected_store.dart';
import 'package:bee_kind/main.dart';
import 'package:bee_kind/models/data_models/user_profile_data_model.dart';
import 'package:bee_kind/models/response_models/get_categories_response_model.dart';
import 'package:bee_kind/models/response_models/get_products_by_category_response_model.dart';
import 'package:bee_kind/models/response_models/get_profile_response_model.dart';
import 'package:bee_kind/models/response_models/get_stores_response_model.dart'
    show StoreInformation, GetStoresResponseModel;
import 'package:bee_kind/models/response_models/store_detail_response_model.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/widgets/dialogs/show_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bee_kind/utils/user_location_permission.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:intl/intl.dart';

class BaseViewController extends GetxController {
  final prefs = SharedPrefs();
  final network = Network();
  final searchFocusNode = FocusNode();

  /// -------------------- BOTTOM NAV --------------------
  final RxInt currentIndex = 0.obs;
  final RxBool isVendor = false.obs;

  Rxn<File> profileImage = Rxn(null);

  String? address;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final Rxn<GetProfileResponseModel> profile = Rxn<GetProfileResponseModel>();

  Rxn<GetProductsByCategoriesResponseModel> productsByCategory =
      Rxn<GetProductsByCategoriesResponseModel>();

  final Rxn<GetCategoriesResponseModel> categories =
      Rxn<GetCategoriesResponseModel>();
  RxList<StoreInformation> storesList = <StoreInformation>[].obs;

  List<Products> allProducts = [];
  List<PopularProducts> allPopularProducts = [];

  final Rxn<StoreDetail> storeData = Rxn<StoreDetail>();

  final Rxn<StoreDetailResponseModel> storeDetail =
      Rxn<StoreDetailResponseModel>();

  final searchController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minPriceController = TextEditingController();

  List<LatLng> coordinates = [];

  RxString selectedCategoryId = "".obs;
  RxString selectedCategoryName = "".obs;

  Widget buildImageContainer({
    required File? image,
    required bool isCircular,
    required String placeholderText,
    String? networkImage,
    bool isProfile = false,
  }) {
    final borderRadius = isCircular
        ? BorderRadius.circular(100)
        : BorderRadius.circular(20);

    return Container(
      width: isCircular ? 150 : double.infinity,
      height: isCircular ? 150 : 180,
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.yellow1.withValues(alpha: 0.2),
        border: Border.all(color: AppColors.yellow2, width: 2),
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : borderRadius,
      ),
      child: ClipRRect(
        borderRadius: isCircular ? BorderRadius.circular(100) : borderRadius,
        child: image != null
            ? Image.file(image, fit: BoxFit.cover)
            // NEW: show network image if exists
            : (networkImage != null && networkImage.isNotEmpty)
            ? Image.network(networkImage, fit: BoxFit.cover)
            // placeholder
            : Center(
                child: isProfile
                    ? Icon(
                        Icons.camera_alt_rounded,
                        size: 40,
                        color: AppColors.yellow2,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            size: 40,
                            color: AppColors.yellow2,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: placeholderText,
                            fontColor: AppColors.yellow2,
                            fontSize: 14,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
      ),
    );
  }

  void pickImage(BuildContext context, {required bool isProfile}) {
    showImagePickerBottomSheet(
      context: context,
      title: isProfile ? "Upload Profile Picture" : "Upload Business License",
      target: isProfile ? "profile" : "license",
      onImagePicked: (file) {
        // if (isProfile) {
        profileImage.value = file;
        // } else {
        //   businessLicense.value = file;
        // }
      },
    );
  }

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isVendor.value = prefs.getString("role") == "vendor";

      await getProfile();
      await getCategories();
      await fetchStores();
      await loadUserLocation();
      await showStoreMarkers();
    });
  }

  void updateRadius(double value) {
    currentRadius.value = value;
  }

  String formatRadius(double value) {
    return value.toStringAsFixed(2);
  }

  void updateSelectedCategory(String? id, String? name) {
    selectedCategoryId.value = id ?? "";
    selectedCategoryName.value = name ?? "";
  }

  String formatPrice(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  List<BottomTab> tabs(bool isVendor) => [
    BottomTab(
      label: isVendor ? "Dashboard" : "Home",
      image: AssetsPath.home,
      selectedImage: AssetsPath.home,
    ),
    BottomTab(
      label: isVendor ? "Order\nRequests" : "My Cart",
      image: isVendor ? AssetsPath.orderRequests : AssetsPath.mycart,
      selectedImage: isVendor ? AssetsPath.orderRequests : AssetsPath.mycart,
    ),
    BottomTab(
      label: 'My Orders',
      image: AssetsPath.orders,
      selectedImage: AssetsPath.orders,
    ),
    BottomTab(
      label: 'Settings',
      image: AssetsPath.settings,
      selectedImage: AssetsPath.settings,
    ),
  ];

  Future<void> fetchStores() async {
    showWindow.value = false;
    dev.log(
      "latitude: ${currentLatLng.value?.latitude} longitude: ${currentLatLng.value?.longitude}",
    );
    dev.log(
      "QUERY PARAMETERS: ${{"search": searchController.text, "lat": currentLatLng.value?.latitude, "lng": currentLatLng.value?.longitude, "categoryId": selectedCategoryId.value, "radius": currentRadius.value, "minPrice": maxPriceController.text, "maxPrice": minPriceController.text}}",
    );
    try {
      showLoadingDialog(StaticData.navigatorKey.currentContext!);

      final response = await network.getRequest(
        endPoint: NetworkStrings.getStores,
        queryParameters: {
          "search": searchController.text,
          "lat": currentLatLng.value?.latitude,
          "lng": currentLatLng.value?.longitude,
          "categoryId": selectedCategoryId.value,
          "radius": currentRadius.value,
          "minPrice": maxPriceController.text,
          "maxPrice": minPriceController.text,
        },
        isHeaderRequire: true,
        isToast: false,
      );

      if (response == null) {
        Navigator.pop(StaticData.navigatorKey.currentContext!);
        AppDialogs.showToast("Unable to load stores.");
        return;
      }

      final data = response.data;

      if (data["status"] == true && data["data"] != null) {
        final model = GetStoresResponseModel.fromJson(data);

        storesList.value = model.data ?? [];
        coordinates.clear();

        for (final store in storesList) {
          final coords = store.vendorAddress?.coordinates;

          if (coords != null && coords.length == 2) {
            final lng = coords[0];
            final lat = coords[1];

            coordinates.add(LatLng(lat, lng));
          }
        }

        await showStoreMarkers();
      } else {
        Navigator.pop(StaticData.navigatorKey.currentContext!);
        AppDialogs.showToast(data["message"] ?? "Failed to load stores");
      }
    } catch (e) {
      Navigator.pop(StaticData.navigatorKey.currentContext!);
      dev.log("fetching stores error: $e");
      AppDialogs.showToast("Something went wrong while fetching stores.");
    } finally {
      Navigator.pop(StaticData.navigatorKey.currentContext!);
      isLoading.value = false;
    }
  }

  Future<void> showStoreMarkers() async {
    markers.removeWhere((m) => m.markerId != const MarkerId('user_location'));

    final BitmapDescriptor storeIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(60, 70)),
      AssetsPath.marker, // <-- add a store pin asset or use default
    );

    for (int i = 0; i < storesList.length; i++) {
      final store = storesList[i];
      final coords = store.vendorAddress?.coordinates;

      if (coords == null || coords.length < 2) continue;

      final position = LatLng(coords[1], coords[0]); // lat, lng

      markers.add(
        Marker(
          markerId: MarkerId(store.sId ?? "store_$i"),
          position: position,
          icon: storeIcon,
          onTap: () {
            selectStore(store);
          },
        ),
      );

      markers.refresh();
    }
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return "";

    try {
      // Parse 24-hour format
      final parsedTime = DateFormat("HH:mm").parse(time);

      // Convert to 12-hour AM/PM format
      return DateFormat("h:mm a").format(parsedTime);
    } catch (e) {
      return time; // fallback
    }
  }

  Rxn<StoreInformation> selectedStore = Rxn<StoreInformation>();

  void selectStore(StoreInformation store) {
    dev.log("selectedStore: ${store.businessName}");
    selectedStore.value = store;
    showWindow.value = true;
  }

  Future<void> fetchStoreDetail(String? storeId, BuildContext context) async {
    debugPrint("fetch store detail");
    try {
      showLoadingDialog(context);

      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getStoreDetail}/$storeId",
        isHeaderRequire: true,
        isToast: false,
      );

      Navigator.pop(context);

      if (response == null) {
        return;
      }

      final data = response.data;

      if (kDebugMode) {
        AppDialogs.showToast(data["message"]);
      }

      if (data["status"] == true && data["data"] != null) {
        storeDetail.value = StoreDetailResponseModel.fromJson(data);
        storeData.value = storeDetail.value?.data;

        allProducts = storeData.value?.products ?? [];
        allPopularProducts = storeData.value?.popularProducts ?? [];

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StoreScreen(data: storeData.value)),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      dev.log("StoreDetailResponseModel Exception: $e");
    }
  }

  Future<void> getCategories() async {
    try {
      isLoading.value = true;
      dev.log("Fetching categories...");

      final response = await network.getRequest(
        endPoint: NetworkStrings.getCategories,
        isHeaderRequire: true,
        isToast: false,
      );

      if (response == null) {
        AppDialogs.showToast("Unable to fetch categories");
        isLoading.value = false;
        return;
      }

      final data = response.data;
      dev.log("Categories API Response: $data");

      if (data["status"] == true && data["data"] != null) {
        categories.value = GetCategoriesResponseModel.fromJson(data);
        dev.log("Categories parsed successfully ✔");
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to fetch categories");
        dev.log("Failed: ${data['message']}");
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      dev.log("getCategories Exception: $e");
      AppDialogs.showToast("Something went wrong while fetching categories.");
    }
  }

  Future<void> getProductsByCategory(
    String? categoryId,
    String? categoryName,
    BuildContext context,
  ) async {
    try {
      // SHOW LOADING
      showLoadingDialog(context);

      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getProductsByCategory}/$categoryId",
        isHeaderRequire: true,
        isToast: false,
      );

      // HIDE LOADING
      Navigator.pop(context);

      if (response == null) {
        AppDialogs.showToast("Unable to fetch products");
        return;
      }

      final data = response.data;

      if (data["status"] == true) {
        productsByCategory.value =
            GetProductsByCategoriesResponseModel.fromJson(data);

        dev.log("Products Loaded Successfully");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryWiseProductsList(
              fromHome: true,
              products: productsByCategory.value?.data ?? [],
              categoryName: categoryName,
            ),
          ),
        );
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to fetch products");
        dev.log("Products Load Failed: ${data['message']}");
      }
    } catch (e) {
      // HIDE LOADING if crash occurs
      Navigator.pop(context);

      dev.log("getProductsByCategory Exception: $e");
      AppDialogs.showToast("Something went wrong while fetching products.");
    }
  }

  /// -------------------- LOADING --------------------
  final RxBool isLoading = false.obs;

  /// -------------------- USER HOME SCREEN LOGIC --------------------
  RxString location = "".obs;
  RxString differentLocation = "".obs;
  RxBool showWindow = false.obs;

  GoogleMapController? mapController;

  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;

  Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);

  RxDouble currentRadius = 10.0.obs;
  RxDouble minRadius = 0.5.obs;
  RxDouble maxRadius = 100.0.obs;

  /// -------------------- LOCATION LOADING --------------------

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      final place = placemarks.first;

      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      return address;
    } catch (e) {
      dev.log("Error in reverse geocoding: $e");
      return "Unknown location";
    }
  }

  Future<void> loadUserLocation() async {
    final position = await UserPermissions.getCurrentLocation();

    if (position != null) {
      currentLatLng.value = LatLng(position.latitude, position.longitude);
      address = await getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      prefs.setString("address", address.toString());

      // ⭐ Add the default red Google Maps marker
      markers.removeWhere((m) => m.markerId == const MarkerId("user_location"));

      markers.add(
        Marker(
          markerId: const MarkerId("user_location"),
          position: currentLatLng.value!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      markers.refresh();

      // Move map camera
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng.value!, 15),
        );
      }
    }
  }

  /// -------------------- DELIVERY RADIUS CIRCLE --------------------
  void updateCircle(LatLng center, double radiusMiles) {
    circles.value = {
      Circle(
        circleId: const CircleId('delivery_radius'),
        center: center,
        radius: radiusMiles * 1609.34,
        fillColor: AppColors.yellow2.withValues(alpha: 0.2),
        strokeColor: AppColors.yellow2,
        strokeWidth: 2,
      ),
    };
  }

  void fitCameraToCircle(LatLng center, double radiusMiles) {
    final southwest = LatLng(
      center.latitude - radiusMiles / 69.0,
      center.longitude - radiusMiles / (69.0 * cos(center.latitude * pi / 180)),
    );

    final northeast = LatLng(
      center.latitude + radiusMiles / 69.0,
      center.longitude + radiusMiles / (69.0 * cos(center.latitude * pi / 180)),
    );

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: southwest, northeast: northeast),
        50,
      ),
    );
  }

  /// -------------------- PROFILE FETCH --------------------

  void changeTab(int index) => currentIndex.value = index;

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      dev.log("Fetching profile...");

      final response = await network.getRequest(
        endPoint: NetworkStrings.getProfile,
        isHeaderRequire: true,
        isToast: false,
      );

      if (response == null) {
        AppDialogs.showToast("Unable to fetch profile");
        isLoading.value = false;
        return;
      }

      final data = response.data;

      if (data["status"] == true && data["data"] != null) {
        profile.value = GetProfileResponseModel.fromJson(data);

        String firstName = profile.value?.data?.firstName ?? "";
        String lastName = profile.value?.data?.lastName ?? "";
        String cellNo = profile.value?.data?.phoneNumber ?? "";
        String picture = profile.value?.data?.profilePicture ?? "";
        String businessName = profile.value?.data?.businessName ?? "";

        await prefs.isProfileComplete(
          profile.value?.data?.isProfileCompleted ?? false,
        );

        dev.log("first name: $firstName");
        dev.log("last name:  $lastName");
        dev.log("cell phone: $cellNo");
        dev.log("picture:    $picture");
        dev.log("business:   $businessName");

        prefs.setString("firstName", firstName);
        prefs.setString("lastName", lastName);
        prefs.setString("businessName", businessName);
        prefs.setString("phone", cellNo);
        prefs.setString("profileImage", picture);
        prefs.setString("email", profile.value?.data?.email ?? "");
        prefs.setString("dob", profile.value?.data?.dateOfBirth ?? "");
        prefs.setString("gender", profile.value?.data?.gender ?? "");

        dev.log("First Name: ${prefs.getString("firstName")}");
        dev.log("Last Name: ${prefs.getString("lastName")}");
        dev.log("Business Name: ${prefs.getString("businessName")}");
        dev.log("Phone: ${prefs.getString("phone")}");
        dev.log("Profile Image: ${prefs.getString("profileImage")}");
        dev.log("Email: ${prefs.getString("email")}");
        dev.log("DOB: ${prefs.getString("dob")}");
        dev.log("Gender: ${prefs.getString("gender")}");
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to fetch profile");
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      dev.log("GetProfile Exception: $e");
      AppDialogs.showToast("Something went wrong while fetching profile.");
    }
  }

  Future<void> updateProfile(
    BuildContext context,
    Map<String, dynamic> body,
  ) async {
    try {
      showLoadingDialog(context);

      // final dynamic profileImage = body["profileImage"];
      // final bool hasNewImage = profileImage is File;

      // -------------------------
      // MULTIPART REQUEST
      // -------------------------
      final model = UserProfileDataModel(
        firstName: body["firstName"],
        lastName: body["lastName"],
        phoneNumber: body["phone"],
        gender: body["gender"],
        dateOfBirth: body["dateOfBirth"],
        profilePicture: body["profileImage"],
      );
      dev.log("profile image: ${body["profileImage"]}");

      final Map<String, dynamic> baseMap = model.toFormDataMap()
        ..removeWhere((key, value) => value == null);

      final formData = dio.FormData.fromMap(baseMap);

      dev.log("FORM DATA: ${formData.fields}");
      dev.log("FORM DATA: ${formData.files}");

      final response = await network.patchRequest(
        endPoint: NetworkStrings.updateProfile,
        data: formData,
        isHeaderRequire: true,
      );

      await _handleUpdateResponse(response, body, context);
    } catch (e) {
      AppDialogs.showToast("Something went wrong while updating profile.");
      dev.log("updateProfile Exception: $e");
    }
  }

  Future<void> _handleUpdateResponse(
    dio.Response? response,
    Map<String, dynamic> body,
    BuildContext context,
  ) async {
    if (response == null) {
      AppDialogs.showToast("Failed to update profile.");
      return;
    }

    final data = response.data;

    if (data["status"] == true) {
      AppDialogs.showToast("Profile updated successfully!");

      // Save updated profile basic info
      prefs.setString("firstName", body["firstName"]);
      prefs.setString("lastName", body["lastName"]);
      prefs.setString("email", body["email"]);
      prefs.setString("dob", body["dateOfBirth"]);
      prefs.setString("gender", body["gender"]);
      // Save updated profile image url

      // NEW: get new image url from backend response
      final uploadedImageUrl = data["data"]["profilePicture"];

      dev.log("upload image: $uploadedImageUrl");

      // NEW: always replace with backend updated image URL
      if (uploadedImageUrl != null) {
        prefs.setString("profileImage", uploadedImageUrl);
      }

      // Reset selected image
      profileImage.value = null;

      // REFRESH PROFILE FROM API
      await getProfile();

      // GO BACK
      AppNavigation.navigatorPop(context);
    } else {
      AppDialogs.showToast(data["message"] ?? "Update failed.");
    }
  }
}
