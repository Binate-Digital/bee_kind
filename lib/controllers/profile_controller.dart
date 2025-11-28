import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bee_kind/auth/web_view.dart';
import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/models/data_models/user_profile_data_model.dart';
import 'package:bee_kind/models/data_models/vendor_profile_data_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_constants.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/app_navigation.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/widgets/bottom_sheets/image_picker_bottom_sheet.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/success_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class ProfileController extends GetxController {
  final prefs = SharedPrefs();

  final network = Network();

  /// Reactive state
  RxBool isVendor = false.obs;
  RxBool isLoading = false.obs;
  RxBool isVerifyLoading = false.obs;
  Map<String, dynamic> location = {};
  // = {
  //   "type": "Point",
  //   "coordinates": [67.0152705, 24.8109828],
  //   "address": "Dolmen Mall, Block 4 Clifton, Karachi, 75600",
  // };

  /// Dropdown / date / time fields
  RxnString selectedGender = RxnString(null);
  RxnString selectedOffDay = RxnString(null);
  RxnString selectedAddressType = RxnString(null);

  List<String> genders = const ["Male", "Female"];

  List<String> days = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  RxList<String> selectedOffDays = <String>[].obs;
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  Rxn<TimeOfDay> openTime = Rxn<TimeOfDay>();
  Rxn<TimeOfDay> closeTime = Rxn<TimeOfDay>();

  /// Error fields
  RxString dateError = ''.obs;
  RxString genderError = ''.obs;
  RxString addressError = ''.obs;
  RxString locationAddressError = ''.obs;
  RxString openTimeError = ''.obs;
  RxString closeTimeError = ''.obs;
  RxString licenseError = ''.obs;
  RxString addresstypeError = ''.obs;

  /// Other flags
  RxBool isChecked = false.obs;
  RxBool isDeliveryChecked = false.obs;

  /// Slider values
  final double minRadius = 0.5;
  final double maxRadius = 100.0;
  RxDouble currentRadius = 50.0.obs;

  /// Files
  Rxn<File> profileImage = Rxn(null);
  Rxn<File> businessLicense = Rxn(null);

  /// Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessDescriptionController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final streetAddressController = TextEditingController();
  final apartmentNumberController = TextEditingController();
  final floorNumberController = TextEditingController();
  final RxString locationAddress = ''.obs;

  /// Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Initialize data
  @override
  void onInit() {
    super.onInit();

    // Load role
    final role = prefs.getRole();
    isVendor.value = role == 'vendor';

    // Load global email from SharedPrefs
    final storedEmail = prefs.getGlobalEmail();
    if (storedEmail != null) {
      emailController.text = storedEmail;
    }
  }

  /// Launch Veriff verification
  Future<void> launchVeriffVerification(BuildContext context) async {
    log("INSIDE VERIFF FUNCTION");
    if (!isChecked.value) {
      log(" Validation Failed: Age verification consent missing");
      AppDialogs.showToast(
        "You must consent to upload your ID and confirm your age.",
      );
      return;
    }
    try {
      isVerifyLoading.value = true;

      // Call your API to create Veriff session
      final response = await network.postRequest(
        endPoint: NetworkStrings.verifyVeriff,
        isHeaderRequire: true,
      );

      isVerifyLoading.value = false;

      if (response == null) {
        AppDialogs.showToast("Failed to connect to verification service");
        return;
      }

      final data = response.data;
      log("Veriff API Response: $data");

      if (data["status"] == true) {
        final verificationUrl = data["data"]["url"];
        final sessionId = data["data"]["sessionId"];

        // Store session ID for later reference
        await prefs.setVeriffSessionId(sessionId);

        // Navigate to WebView screen
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VeriffWebViewScreen(
              verificationUrl: verificationUrl,
              sessionId: sessionId,
            ),
          ),
        );

        // Handle the result when user returns from verification
        if (result == true) {
          // Verification was successful
          AppDialogs.showToast("Verification completed successfully!");
          isVerifyLoading.value = false;

          // Check verification status with your backend
          await _checkVerificationStatus();
        } else {
          // User cancelled or verification failed
          isVerifyLoading.value = false;
          AppDialogs.showToast("Verification was not completed");
        }
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to start verification");
      }
    } catch (e) {
      isVerifyLoading.value = false;
      log("Veriff verification error: $e");
      AppDialogs.showToast("Something went wrong during verification");
    }
  }

  /// Check verification status with your backend
  Future<void> _checkVerificationStatus() async {
    try {
      final sessionId = await prefs.getVeriffSessionId();
      if (sessionId == null) return;

      final response = await network.getRequest(
        endPoint:
            'auth/verification-status/$sessionId', // Adjust endpoint as needed
        isHeaderRequire: true,
      );

      if (response?.data['status'] == true) {
        final verificationData = response?.data['data'];
        final isVerified = verificationData['isVerified'];
        final status = verificationData['status'];

        log("Verification status: $status, Verified: $isVerified");

        // Update UI or state based on verification status
        if (isVerified == true) {
          // You might want to update a flag in your controller
          // or refresh the user profile
        }
      }
    } catch (e) {
      log("Error checking verification status: $e");
    }
  }

  Future<void> handleCreateProfile(
    BuildContext context, {
    bool isEdit = false,
  }) async {
    if (!validateForm(context)) {
      log("Validation Failed");
      return;
    }

    try {
      isLoading.value = true;

      final userId = prefs.getUserId();
      if (userId == null || userId.isEmpty) {
        isLoading.value = false;
        AppDialogs.showToast("User ID not found. Please sign in again.");
        return;
      }

      // ---------------------------------------------------------
      // SELECT MODEL BASED ON USER OR VENDOR
      // ---------------------------------------------------------
      dynamic model;

      if (!isVendor.value) {
        // --------------------- USER MODEL ---------------------
        log("LOcation before creating USER model: $location");
        model = UserProfileDataModel(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          gender: selectedGender.value?.toLowerCase(),
          dateOfBirth: selectedDate.value?.toIso8601String(),
          appartmentNumber: apartmentNumberController.text.trim(),
          floorNumber: floorNumberController.text.trim(),

          address: selectedAddressType.value,
          location: location, // map
          profilePicture: profileImage.value,
        );
      } else {
        // --------------------- VENDOR MODEL ---------------------
        model = VendorProfileDataModel(
          businessName: businessNameController.text.trim(),
          businessDescription: businessDescriptionController.text.trim(),

          openTime: openTime.value != null
              ? "${openTime.value!.hour.toString().padLeft(2, '0')}:${openTime.value!.minute.toString().padLeft(2, '0')}"
              : null,

          closeTime: closeTime.value != null
              ? "${closeTime.value!.hour.toString().padLeft(2, '0')}:${closeTime.value!.minute.toString().padLeft(2, '0')}"
              : null,

          phoneNumber: phoneController.text.trim(),

          offDays: selectedOffDays,
          deliveryRadius: currentRadius.value,

          businessLicense: businessLicense.value,
          profilePicture: profileImage.value,

          address: streetAddressController.text.trim(),
          location: location, // map
        );
      }

      // ---------------------------------------------------------
      // CONVERT BASE MAP
      // ---------------------------------------------------------
      final Map<String, dynamic> baseMap = model.toFormDataMap()
        ..removeWhere((key, value) => value == null);

      // ---------------------------------------------------------
      // BUILD FORMDATA
      // ---------------------------------------------------------
      final formData = dio.FormData.fromMap(baseMap);

      // ---------------- offDays (Vendor only) ----------------
      if (isVendor.value) {
        for (final day in selectedOffDays) {
          formData.fields.add(MapEntry("offDays", day));
        }
      }

      // log("===== FINAL FORMDATA ===== ${jsonEncode(formData)}");
      log("===== FINAL FORMDATA FIELDS ===== ${formData.fields}");
      log("===== FINAL FORMDATA FILES ===== ${formData.files}");

      // ---------------------------------------------------------
      // API CALL
      // ---------------------------------------------------------

      final response = await network.postRequest(
        endPoint: NetworkStrings.completeProfile,
        data: formData,
        isHeaderRequire: true,
      );

      if (response == null) {
        isLoading.value = false;
        AppDialogs.showToast("Unable to complete profile. Please try again.");
        return;
      }

      final data = response.data;
      log("Create Profile Response: $data");

      if (data["status"] == true) {
        isLoading.value = false;
        AppDialogs.showToast(
          data["message"] ?? "Profile submitted successfully",
        );

        await prefs.isProfileComplete(
          data["data"]["user"]["isProfileCompleted"],
        );

        log("IS PROFILE COMPLETE: ${prefs.checkProfile()}");

        if (!isEdit) {
          Get.offAll(() => BaseView());
        } else {
          Get.back();
        }
      } else {
        isLoading.value = false;
        AppDialogs.showToast(data["message"] ?? "Profile submit failed");
      }
    } catch (e) {
      isLoading.value = false;
      log("CreateProfile Exception: $e");
      AppDialogs.showToast("Something went wrong. Please try again.");
    }
  }

  /// Pick profile or license image
  void pickImage(BuildContext context, {required bool isProfile}) {
    showImagePickerBottomSheet(
      context: context,
      title: isProfile ? "Upload Profile Picture" : "Upload Business License",
      target: isProfile ? "profile" : "license",
      onImagePicked: (file) {
        if (isProfile) {
          profileImage.value = file;
        } else {
          businessLicense.value = file;
        }
      },
    );
  }

  /// Select Date of Birth
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.yellow2,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateError.value = '';
    }
  }

  /// Format date to display
  String formatDate(DateTime? date) {
    if (date == null) return "Date of Birth";
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  /// Pick open/close time
  Future<void> pickTime(
    BuildContext context, {
    required bool isOpenTime,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.yellow2,
                onPrimary: AppColors.whiteColor,
                onSurface: AppColors.blackColor,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      if (isOpenTime) {
        openTime.value = picked;
        openTimeError.value = '';
      } else {
        closeTime.value = picked;
        closeTimeError.value = '';
      }
    }
  }

  /// Format time to readable string
  String formatTime(TimeOfDay? time) {
    if (time == null) return "Select Time";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(Get.context!);
  }

  Map<String, dynamic> locationToJson(LocationResult result) {
    return {
      "formattedAddress": result.formattedAddress,
      "coordinates": [result.latLng!.latitude, result.latLng!.longitude],
      "placeId": result.placeId,
      "locality": result.locality,
      "country": result.country?.name,
      "postalCode": result.postalCode,
    };
  }

  Future<void> pickLocation(context) async {
    try {
      LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlacePicker(AppConstants.googleApiKey),
        ),
      );

      location = {
        "address": result.formattedAddress,
        "coordinates": [result.latLng?.latitude, result.latLng?.longitude],
        "type": "Point",
        "floorNumber": floorNumberController.text.trim(),
        "apartmentNumber": apartmentNumberController.text.trim(),
      };
      log("FULL RESULT: ${jsonEncode(locationToJson(result))}");
      locationAddress.value = result.formattedAddress ?? '';
      streetAddressController.text = result.formattedAddress ?? 'Dummy Address';
    } catch (e) {
      log('Error picking location: $e');
    }
  }

  /// Validate form data
  bool validateForm(BuildContext context) {
    log("====== VALIDATING PROFILE FORM ======");

    bool isValid = true;

    dateError.value = '';
    genderError.value = '';
    addressError.value = '';
    openTimeError.value = '';
    closeTimeError.value = '';
    licenseError.value = '';
    addresstypeError.value = '';

    log("isVendor: ${isVendor.value}");
    log("selectedGender: ${selectedGender.value}");
    log("selectedDate: ${selectedDate.value}");
    log("streetAddress: ${streetAddressController.text.trim()}");
    log("openTime: ${openTime.value}");
    log("closeTime: ${closeTime.value}");
    log("businessLicense: ${businessLicense.value}");
    log("Consent checked (isChecked): ${isChecked.value}");
    log("Delivery checked (isDeliveryChecked): ${isDeliveryChecked.value}");

    // ---------------------- USER VALIDATION ----------------------
    if (!isVendor.value) {
      log("Running USER validation...");

      if (selectedDate.value == null) {
        log(" Validation Failed: Date of birth is missing");
        dateError.value = "Date of birth is required";
        isValid = false;
      }

      if (selectedGender.value?.isEmpty ?? true) {
        log(" Validation Failed: Gender is missing");
        genderError.value = "Gender is required";
        isValid = false;
      }

      if (!isChecked.value) {
        log(" Validation Failed: Age verification consent missing");
        AppDialogs.showToast(
          "You must consent to upload your ID and confirm your age.",
        );
        isValid = false;
      }

      if (!isDeliveryChecked.value) {
        log(" Validation Failed: Delivery address confirmation missing");
        AppDialogs.showToast(
          "You must confirm that your delivery address matches your ID address.",
        );
        isValid = false;
      }
      // ---------------------- ADDRESS TYPE ----------------------
      if (selectedAddressType.value == null ||
          selectedAddressType.value!.trim().isEmpty) {
        addresstypeError.value = "Address Type is required";
        log("Validation Failed: Address Type missing");
        isValid = false;
      }

      if (locationAddress.value.isEmpty) {
        log("Validation Failed: Location address missing");
        locationAddressError.value = "Location address is required";
        isValid = false;
      }
    }

    // ---------------------- VENDOR VALIDATION ----------------------
    if (isVendor.value) {
      log("Running VENDOR validation...");

      if (openTime.value == null) {
        log(" Validation Failed: Opening time missing");
        openTimeError.value = "Opening time required";
        isValid = false;
      }

      if (closeTime.value == null) {
        log(" Validation Failed: Closing time missing");
        closeTimeError.value = "Closing time required";
        isValid = false;
      }

      if (streetAddressController.text.trim().isEmpty ||
          locationAddress.value.isEmpty) {
        log("Validation Failed: Street Address missing");
        addressError.value = "Street Address is required";
        isValid = false;
      }

      if (businessLicense.value == null) {
        log(" Validation Failed: Business license missing");
        licenseError.value = "Business license image is required";
        isValid = false;
      }
    }

    // ---------------------- FORM FIELDS VALIDATION ----------------------
    final bool formFieldsValid = formKey.currentState!.validate();
    log("Form fields validation: $formFieldsValid");

    if (!formFieldsValid) {
      log(" Validation Failed: Fields inside Form widget are invalid");
      isValid = false;
    }

    log("====== FINAL VALIDATION RESULT: $isValid ======");
    return isValid;
  }

  /// Handle submission
  void handleSubmit(BuildContext context, bool isEdit) {
    if (validateForm(context)) {
      log("Validation Successful");
      if (isEdit) {
        AppNavigation.navigatorPop(context);
      } else {
        showSuccessDialog(context, isVendor: isVendor.value);
      }
    } else {
      log("Validation Failed");
    }
  }

  /// Handle Verify ID
  // void handleVerifyID(BuildContext context) {
  //   if (validateForm(context)) {
  //     showSuccessDialog(context);
  //   }
  // }

  // ---------------- UI HELPERS ----------------
  Widget buildImageContainer({
    required File? image,
    required bool isCircular,
    required String placeholderText,
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

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    businessNameController.dispose();
    businessDescriptionController.dispose();
    emailController.dispose();
    phoneController.dispose();
    streetAddressController.dispose();
    super.onClose();
  }
}
