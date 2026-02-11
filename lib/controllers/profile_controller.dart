import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bee_kind/auth/web_view.dart';
import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/controllers/base_view_controller.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../utils/global.dart';
import '../widgets/webview_flutter_widget.dart';

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

  /// Network image URLs (for displaying existing images during edit)
  RxString existingProfileImageUrl = ''.obs;
  RxString existingBusinessLicenseUrl = ''.obs;

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

  void resetProfileForm() {
    firstNameController.clear();
    lastNameController.clear();
    businessNameController.clear();
    businessDescriptionController.clear();
    // emailController.clear();
    phoneController.clear();
    streetAddressController.clear();
    apartmentNumberController.clear();
    floorNumberController.clear();

    selectedGender.value = null;
    selectedAddressType.value = null;
    selectedDate.value = null;
    openTime.value = null;
    closeTime.value = null;

    location = {};
    locationAddress.value = '';
    selectedOffDays.clear();
    currentRadius.value = 50.0;
    profileImage.value = null;
    businessLicense.value = null;

    // Reset errors
    dateError.value = '';
    genderError.value = '';
    addressError.value = '';
    locationAddressError.value = '';
    openTimeError.value = '';
    closeTimeError.value = '';
    licenseError.value = '';
    addresstypeError.value = '';
  }

  /// Load existing profile data for edit mode
  Future<void> loadProfileDataForEdit() async {
    try {
      // Get the base controller which has the profile data
      final baseController = Get.find<BaseViewController>();

      // Wait for profile to be loaded if it's not already
      if (baseController.profile.value == null) {
        await baseController.getProfile();
      }

      final profileData = baseController.profile.value?.data;

      if (profileData == null) {
        log("No profile data available");
        return;
      }

      log("Loading profile data for edit mode");

      // Load common fields
      phoneController.text = profileData.phoneNumber?.toString() ?? '';
      emailController.text = profileData.email?.toString() ?? '';

      // Load existing profile picture URL
      if (profileData.profilePicture != null &&
          profileData.profilePicture!.isNotEmpty) {
        String pic = profileData.profilePicture.toString();
        if (!pic.startsWith('http')) {
          pic =
              NetworkStrings.NETWORK_IMAGE_BASE_URL +
                  (pic.startsWith('/') ? pic.substring(1) : pic);
        }
        existingProfileImageUrl.value = pic;
        log(
          "Loaded existing profile picture URL: ${existingProfileImageUrl.value}",
        );
      }

      if (isVendor.value) {
        // Load vendor-specific fields
        businessNameController.text = profileData.businessName?.toString() ?? '';
        businessDescriptionController.text=profileData.businessDescription?.toString() ??"";
        // businessDescription is not in ProfileData, so we can't load it

        // Parse and set open/close times
        if (profileData.openTime != null) {
          final timeParts = profileData.openTime.toString().split(':');
          if (timeParts.length == 2) {
            openTime.value = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );
          }
        }

        if (profileData.closeTime != null) {
          final timeParts = profileData.closeTime.toString().split(':');
          if (timeParts.length == 2) {
            closeTime.value = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );
          }
        }

        // Load off days - convert dynamic list to String list and remove duplicates
        if (profileData.offDays != null) {
          selectedOffDays.value = profileData.offDays!
              .map((day) => day.toString())
              .toSet()
              .toList();
        } else {
          selectedOffDays.value = [];
        }

        // Load delivery radius
        currentRadius.value = profileData.deliveryRadius ?? 50.0;

        // Load business address from addressName
        if (profileData.addressName != null) {
          streetAddressController.text = profileData.addressName.toString();
          locationAddress.value = profileData.addressName?.toString() ?? '';
        }

        // Load location from vendorAddress coordinates if available, combined with addressName
        if (profileData.vendorAddress != null &&
            profileData.vendorAddress!.coordinates != null) {
          location = {
            "address":
            profileData.vendorAddress!.address ??
                profileData.addressName?.toString() ??
                '',
            "coordinates": profileData.vendorAddress!.coordinates ?? [],
            "type": profileData.vendorAddress!.type?.toString() ?? 'Point',
          };
          locationAddress.value =
              profileData.vendorAddress!.address ??
                  profileData.addressName?.toString() ??
                  '';

          // Try to extract floor and apartment numbers from previous location data if available
          // These might be stored in userAddress for vendors or in a different structure
          if (profileData.vendorAddress != null ) {
            final firstAddress = profileData.vendorAddress!;
            if (firstAddress.floorNumber != null) {
              floorNumberController.text = firstAddress.floorNumber.toString();
              location["floorNumber"] = firstAddress.floorNumber.toString();
            }
            if (firstAddress.officeUnit != null) {
              apartmentNumberController.text = firstAddress.officeUnit
                  .toString();
              location["apartmentNumber"] = firstAddress.officeUnit
                  .toString();
            }
          }
        } else if (profileData.userAddress != null &&
            profileData.userAddress!.isNotEmpty) {
          // Use first user address as fallback
          final firstAddress = profileData.userAddress!.first;
          location = {
            "address": firstAddress.address?.toString() ?? '',
            "coordinates": firstAddress.coordinates ?? [],
            "type": firstAddress.type?.toString() ?? 'Point',
          };
          locationAddress.value = firstAddress.address?.toString() ?? '';

          // Load floor and apartment numbers
          if (firstAddress.floorNumber != null) {
            floorNumberController.text = firstAddress.floorNumber.toString();
            location["floorNumber"] = firstAddress.floorNumber.toString();
          }
          if (firstAddress.apartmentNumber != null) {
            apartmentNumberController.text = firstAddress.apartmentNumber
                .toString();
            location["apartmentNumber"] = firstAddress.apartmentNumber
                .toString();
          }
        } else if (profileData.vendorAddress?.address != null ||
            profileData.addressName != null) {
          // Fallback to just address name if no coordinates available
          final addr =
              profileData.vendorAddress?.address ??
                  profileData.addressName.toString();
          location = {"address": addr, "coordinates": [], "type": 'Point'};
          locationAddress.value = addr;
        }

        // Load business license from documents if available
        if (profileData.documents != null &&
            profileData.documents!.isNotEmpty) {
          String doc = profileData.documents!.first.toString();
          if (!doc.startsWith('http')) {
            doc =
                NetworkStrings.NETWORK_IMAGE_BASE_URL +
                    (doc.startsWith('/') ? doc.substring(1) : doc);
          }
          existingBusinessLicenseUrl.value = doc;
          log(
            "Loaded existing business license URL: ${existingBusinessLicenseUrl.value}",
          );
        }
      } else {
        // Load user-specific fields
        firstNameController.text = profileData.firstName?.toString() ?? '';
        lastNameController.text = profileData.lastName?.toString() ?? '';

        // Load gender
        selectedGender.value = profileData.gender?.toString();

        // Load date of birth
        if (profileData.dateOfBirth != null) {
          selectedDate.value = DateTime.tryParse(
            profileData.dateOfBirth.toString(),
          );
        }

        // Load address type - not directly available in ProfileData, use addressName as fallback
        selectedAddressType.value = profileData.addressName?.toString();

        // Load apartment and floor numbers from userAddress if available
        if (profileData.userAddress != null &&
            profileData.userAddress!.isNotEmpty) {
          final firstAddress = profileData.userAddress!.first;
          apartmentNumberController.text =
              firstAddress.apartmentNumber?.toString() ?? '';
          floorNumberController.text =
              firstAddress.floorNumber?.toString() ?? '';
        }

        // Load location from userAddress if available
        if (profileData.userAddress != null &&
            profileData.userAddress!.isNotEmpty) {
          final firstAddress = profileData.userAddress!.first;
          location = {
            "address": firstAddress.address?.toString() ?? '',
            "coordinates": firstAddress.coordinates ?? [],
            "type": firstAddress.type?.toString() ?? 'Point',
          };
          locationAddress.value = firstAddress.address?.toString() ?? '';
        }
      }

      log("Profile data loaded successfully for edit mode");
    } catch (e) {
      log("Error loading profile data for edit: $e");
      // Don't show error to user, just log it
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
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VeriffWebViewScreen(
              verificationUrl: verificationUrl,
              sessionId: sessionId,
            ),
          ),
        );

        // Handle the result when user returns from verification
        // if (result == true) {
        // Verification was successful
        AppDialogs.showToast("Verification completed successfully!");
        isVerifyLoading.value = false;

        // Check verification status with your backend
        await _checkVerificationStatus();
        // } else {
        //   // User cancelled or verification failed
        //   isVerifyLoading.value = false;
        //   // AppDialogs.showToast("Verification was not completed");
        // }
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
    // if (!validateForm(context, isEdit: isEdit)) {
    //   log("Validation Failed");
    //   return;
    // }

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

      final profilePictureFile = profileImage.value != null
          ? await dio.MultipartFile.fromFile(profileImage.value!.path, filename: 'profile_picture.jpg')
          : null;

      print("profilePictureFile${profilePictureFile}");

      final businessLicenseFile = businessLicense.value != null
          ? await dio.MultipartFile.fromFile(businessLicense.value!.path, filename: 'business_license.pdf')
          : null;
      print("businessLicenseFile${businessLicenseFile}");


      if (!isVendor.value) {
        // --------------------- USER MODEL ---------------------
        log("LOcation before creating USER model: ${profileImage.value}");
        model = UserProfileDataModel(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          gender: selectedGender.value?.toLowerCase(),
          // dateOfBirth: selectedDate.value?.toIso8601String(),
          appartmentNumber: apartmentNumberController.text.trim(),
          floorNumber: floorNumberController.text.trim(),
          deviceToken: Global.fcmToken,


          address: selectedAddressType.value,
          // location: location, // map
          location: location,
          // map
          profilePicture: profileImage.value,
        );
      } else {
        // --------------------- VENDOR MODEL ---------------------
        // Ensure phone number is properly formatted (remove any non-digit characters)
        final cleanedPhoneNumber = phoneController.text.trim().replaceAll(
          RegExp(r'[^0-9]'),
          '',
        );

        // Ensure location object includes floor and apartment numbers for vendor
        location["floorNumber"] = floorNumberController.text.trim();
        location["apartmentNumber"] = apartmentNumberController.text.trim();

        model = VendorProfileDataModel(
          businessName: businessNameController.text.trim(),
          businessDescription: businessDescriptionController.text.trim(),

          openTime: openTime.value != null
              ? "${openTime.value!.hour.toString().padLeft(2, '0')}:${openTime
              .value!.minute.toString().padLeft(2, '0')}"
              : null,

          closeTime: closeTime.value != null
              ? "${closeTime.value!.hour.toString().padLeft(2, '0')}:${closeTime
              .value!.minute.toString().padLeft(2, '0')}"
              : null,

          phoneNumber: cleanedPhoneNumber.isNotEmpty
              ? cleanedPhoneNumber
              : phoneController.text.trim(),

          offDays: selectedOffDays,
          deliveryRadius: currentRadius.value,

          businessLicense: businessLicense.value,
          profilePicture: profileImage.value,

          address: streetAddressController.text.trim(),
          location: location,
          // map
          // Add floor and apartment numbers as separate fields
          floorNumber: floorNumberController.text.trim(),
          officeUnit: apartmentNumberController.text.trim(),
            deviceToken: Global.fcmToken
        );

        // Debug log to check phone number
        log("Phone number being sent: ${model.phoneNumber}");
        log("Phone number controller text: ${phoneController.text}");
        log("Cleaned phone number: $cleanedPhoneNumber");
      }

      // ---------------------------------------------------------
      // CONVERT BASE MAP
      // ---------------------------------------------------------
      final Map<String, dynamic> baseMap = model.toFormDataMap()
        ..removeWhere(
              (key, value) =>
          value == null || (value is String && value.isEmpty),
        );

      if (profilePictureFile != null) {
        baseMap['profilePicture'] = profilePictureFile;
      }
      if (businessLicenseFile != null) {
        baseMap['businessLicense'] = businessLicenseFile;
      }

      print("businessLicenseFile${businessLicenseFile}");
      // Debug: ensure floor/apartment/location are present before sending
      log('Submitting vendor floorNumber: ${floorNumberController.text}');
      log(
        'Submitting vendor apartmentNumber: ${apartmentNumberController.text}',
      );
      log('Submitting vendor location map: $location');

      // ---------------------------------------------------------
      // BUILD FORMDATA
      // ---------------------------------------------------------
      final formData = dio.FormData.fromMap(baseMap);

      // ---------------- offDays (Vendor only) ----------------
      if (isVendor.value && selectedOffDays.isNotEmpty) {
        // Add offDays for both create and edit - ensure they are sent correctly
        for (final day in selectedOffDays) {
          formData.fields.add(MapEntry("offDays", day));
        }
      }

      // log("===== FINAL FORMDATA ===== ${jsonEncode(formData)}");
      log("===== FINAL FORMDATA FIELDS ===== ${formData.fields}");
      log("===== FINAL FORMDATA FILES ===== ${formData.files}");
      log("===== isEdit: $isEdit =====");

      // ---------------------------------------------------------
      // API CALL - Use POST for create, PATCH for update
      // ---------------------------------------------------------


      print("responseresponse${(isVendor.value)}");
      final response = isEdit
          ?
      // null




      await network.patchRequest(
        endPoint: NetworkStrings.updateProfile,
        data: formData,
        isHeaderRequire: true,
      )
          :

          // null;
      await network.postRequest(
        endPoint: NetworkStrings.completeProfile,
        data: formData,
        isHeaderRequire: true,
      );

      // if (isEdit == false) {
      //
      //   // _launchURL(response?.data['data']['onboardingUrl']);
      //   Get.to(
      //         () => StripeOnboardingWebView(
      //           onboardingUrl: response?.data['data']['onboardingUrl'],
      //     ),
      //   );
      // }
      // else {
      if (response == null) {

        // hhfhfj@gh.com
        isLoading.value = false;
        AppDialogs.showToast(
          isEdit
              ? "Unable to update profile. Please try again."
              : "Unable to complete profile. Please try again.",
        );
        return;
      }

      final data = response.data;
      log("${isEdit ? "Update" : "Create"} Profile Response: $data");

      if (data["status"] == true) {
        isLoading.value = false;
        AppDialogs.showToast(
          data["message"] ??
              (isEdit
                  ? "Profile updated successfully"
                  : "Profile submitted successfully"),
        );

        // For both create and edit, refresh the profile data to get updated info
        try {
          final baseController = Get.find<BaseViewController>();
          // Persist submitted floor/apartment into prefs immediately so UI updates
          await prefs.setString(
            'floorNumber',
            floorNumberController.text.trim(),
          );
          await prefs.setString(
            'apartmentNumber',
            apartmentNumberController.text.trim(),
          );
          await baseController.getProfile();
          log(
            "Profile refreshed successfully after ${isEdit ? 'update' : 'creation'}",
          );
        } catch (e) {
          log(
            "Failed to refresh profile after ${isEdit ? 'update' : 'creation'}: $e",
          );
          // Don't show error to user, just log it
        }

        if (!isEdit) {
          await prefs.isProfileComplete(
            data["data"]["user"]["isProfileCompleted"],
          );
          log("IS PROFILE COMPLETE: ${prefs.checkProfile()}");
        }

        if (!isEdit) {
          Get.offAll(() => BaseView());
        } else {
          Get.back();
        }
      } else {
        isLoading.value = false;
        AppDialogs.showToast(
          data["message"] ??
              (isEdit ? "Profile update failed" : "Profile submit failed"),
        );
      }
      // }
    }
    catch (e) {
      isLoading.value = false;
      log("CreateProfile Exception: $e");
      AppDialogs.showToast("Something went wrong. Please try again.");

    }
  }


  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
  bool validateForm(BuildContext context, {bool isEdit = false}) {
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

      // if (selectedDate.value == null) {
      //   log(" Validation Failed: Date of birth is missing");
      //   dateError.value = "Date of birth is required";
      //   isValid = false;
      // }

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

      // Only require business license if this is a new profile creation, not for edits
      if (!isEdit && businessLicense.value == null) {
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
    if (validateForm(context, isEdit: isEdit)) {
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

    // Get the network image URL based on which image we're displaying
    final networkImageUrl = isProfile
        ? existingProfileImageUrl.value
        : existingBusinessLicenseUrl.value;

    // Determine if we should show an image (either File or network URL)
    final hasImage = image != null || networkImageUrl.isNotEmpty;

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
        child: hasImage
            ? (image != null
            ? Image.file(image, fit: BoxFit.cover)
            : Image.network(networkImageUrl, fit: BoxFit.cover))
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