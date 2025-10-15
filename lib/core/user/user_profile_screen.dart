import 'dart:developer';
import 'dart:io';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_constants.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/success_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:permission_handler/permission_handler.dart';

String globalEmail = "";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedGender;
  String? selectedCity;
  String? selectedState;
  DateTime? selectedDate;
  String location = "";

  // Error strings
  String dateError = "";
  String genderError = "";
  String cityError = "";
  String stateError = "";
  String addressError = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? profileImage;
  final ImagePicker imagePicker = ImagePicker();

  void showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.yellow2),
                title: CustomText(
                  text: "Take Photo",
                  fontSize: 18.sp,
                  textAlign: TextAlign.start,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.yellow2),
                title: CustomText(
                  text: "Choose from Gallery",
                  fontSize: 18.sp,
                  textAlign: TextAlign.start,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      // Request camera permission
      final permissionStatus = await Permission.camera.request();

      if (permissionStatus.isGranted) {
        final XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 80,
        );

        if (image != null) {
          setState(() {
            profileImage = File(image.path);
          });
        }
      } else {
        showPermissionDeniedDialog('Camera');
      }
    } catch (e) {
      debugPrint("Camera error: $e");
      showErrorDialog("Failed to capture image");
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      // Request photo library permission

      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          profileImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Gallery error: $e");
      showErrorDialog("Failed to select image from gallery");
    }
  }

  void showPermissionDeniedDialog(String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(text: "Permission Required"),
        content: CustomText(
          text:
              "Please grant $permission permission to select a profile picture",
          fontSize: 14.sp,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText(text: "Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: CustomText(text: "Open Settings"),
          ),
        ],
      ),
    );
  }

  // Show error dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(text: "Error"),
        content: CustomText(text: message, fontSize: 14.sp),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText(text: "OK"),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    bool isValid = true;

    // Clear previous errors
    setState(() {
      dateError = "";
      genderError = "";
      cityError = "";
      stateError = "";
      addressError = "";
    });

    // Validate date of birth
    if (selectedDate == null) {
      setState(() {
        dateError = "Date of birth is required";
      });
      isValid = false;
    }

    // Validate gender
    if (selectedGender == null || selectedGender!.isEmpty) {
      setState(() {
        genderError = "Gender is required";
      });
      isValid = false;
    }

    // Validate city
    if (selectedCity == null || selectedCity!.isEmpty) {
      setState(() {
        cityError = "City is required";
      });
      isValid = false;
    }

    // Validate state
    if (selectedState == null || selectedState!.isEmpty) {
      setState(() {
        stateError = "State is required";
      });
      isValid = false;
    }

    // Validate address
    if (location.isEmpty) {
      setState(() {
        addressError = "Address is required";
      });
      isValid = false;
    }

    // Validate form fields (first name, last name, phone)
    if (formKey.currentState?.validate() != true) {
      isValid = false;
    }

    return isValid;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.yellow2),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateError = ""; // Clear error when date is selected
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Date of Birth";
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  void initState() {
    super.initState();
    debugPrint("global email: $globalEmail");
    emailController.text = globalEmail;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isProfile: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 70.h),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Create Profile",
                fontSize: 22.sp,
                weight: FontWeight.bold,
              ),
              GestureDetector(
                onTap: showImageSourceBottomSheet,
                child: Container(
                  width: 150.w,
                  height: 150.h,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  child: ClipOval(
                    child: profileImage != null
                        ? Image.file(
                            profileImage!,
                            width: 150.w,
                            height: 150.h,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: AppColors.yellow1.withValues(alpha: 0.2),
                              border: Border.all(
                                color: AppColors.yellow2,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 30,
                              color: AppColors.yellow2,
                            ),
                          ),
                  ),
                ),
              ),
              CustomText(text: "Upload Image", fontSize: 22.sp),
              Padding(
                padding: EdgeInsets.only(top: 30.h, bottom: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 180.w,
                      child: CustomTextField(
                        hint: "First Name",
                        controller: firstNameController,
                        validator: (value) =>
                            Validation.validateName(value, "First Name"),
                        prefxicon: AssetsPath.person,
                      ),
                    ),
                    SizedBox(
                      width: 180.w,
                      child: CustomTextField(
                        hint: "Last Name",
                        controller: lastNameController,
                        validator: (value) =>
                            Validation.validateName(value, "Last Name"),
                        prefxicon: AssetsPath.person,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: CustomTextField(
                  hint: "Email",
                  isEditable: false,
                  controller: emailController,
                  prefxicon: AssetsPath.email,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: CustomTextField(
                  hint: "Phone",
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => Validation.validatePhoneNumber(value),
                  inputFormatters: [
                    USPhoneNumberFormatter(),
                    LengthLimitingTextInputFormatter(16),
                  ],
                  prefxicon: AssetsPath.phone,
                ),
              ),

              // Date of Birth with error
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                        horizontal: 15.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.yellow1.withValues(alpha: 0.2),
                        border: Border.all(color: AppColors.yellow2, width: 1),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: formatDate(selectedDate),
                            fontColor: AppColors.yellow2,
                            fontSize: 18.sp,
                          ),
                          Image.asset(AssetsPath.calendar, width: 18.w),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: dateError.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h, left: 15.w),
                      child: CustomText(
                        text: dateError,
                        fontColor: AppColors.errorColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),

              // Gender with error
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: CustomDropdown(
                      items: ["Male", "Female"],
                      initialValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                          genderError =
                              ""; // Clear error when selection changes
                        });
                        debugPrint("Selected $selectedGender");
                      },
                      hintText: "Gender",
                    ),
                  ),
                  Visibility(
                    visible: genderError.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.h,
                        left: 15.w,
                        top: 4.h,
                      ),
                      child: CustomText(
                        text: genderError,
                        fontColor: AppColors.errorColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),

              // City and State with errors
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 180.w,
                              child: CustomDropdown(
                                items: ["New York City", "Chicago", "Houston"],
                                initialValue: selectedCity,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCity = value;
                                    cityError =
                                        ""; // Clear error when selection changes
                                  });
                                  debugPrint("Selected $selectedCity");
                                },
                                hintText: "City",
                              ),
                            ),
                            Visibility(
                              visible: cityError.isNotEmpty,
                              child: Container(
                                width: 180.w,
                                padding: EdgeInsets.only(
                                  bottom: 10.h,
                                  top: 4.h,
                                  right: 80.w,
                                ),
                                child: CustomText(
                                  text: cityError,
                                  fontColor: AppColors.errorColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 180.w,
                              child: CustomDropdown(
                                items: ["New York", "California", "Texas"],
                                initialValue: selectedState,
                                onChanged: (value) {
                                  setState(() {
                                    selectedState = value;
                                    stateError =
                                        ""; // Clear error when selection changes
                                  });
                                  debugPrint("Selected $selectedState");
                                },
                                hintText: "State",
                              ),
                            ),
                            Visibility(
                              visible: stateError.isNotEmpty,
                              child: Container(
                                width: 180.w,
                                padding: EdgeInsets.only(
                                  bottom: 10.h,
                                  top: 4.h,
                                  right: 80.w,
                                ),
                                child: CustomText(
                                  text: stateError,
                                  fontColor: AppColors.errorColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Address with error
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      debugPrint("Location tapped");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Theme(
                            data: ThemeData.light(),
                            child: MapLocationPicker(
                              config: MapLocationPickerConfig(
                                floatingControlsColor: AppColors.whiteColor,
                                floatingControlsIconColor: AppColors.yellow1,
                                apiKey: AppConstants.googleApiKey,
                                initialPosition: const LatLng(
                                  38.7945952,
                                  -106.5348379,
                                ),
                                bottomCardBuilder:
                                    (
                                      context,
                                      place,
                                      places,
                                      formattedAddress,
                                      isLoading,
                                      onPlaceSelected,
                                      searchBar,
                                    ) {
                                      return CupertinoActionSheet(
                                        title: const Text("Selected Location"),
                                        actions: [
                                          CupertinoActionSheetAction(
                                            onPressed: onPlaceSelected,
                                            child: Text(
                                              formattedAddress,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                onNext: (loc) async {
                                  setState(() {
                                    location = loc?.formattedAddress ?? '';
                                    addressError =
                                        ""; // Clear error when address is selected
                                  });
                                  log('address ${loc?.formattedAddress}');
                                  log('lat ${loc?.geometry?.location.lat}');
                                  log('long ${loc?.geometry?.location.lng}');
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 15.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.yellow1.withValues(alpha: 0.2),
                        border: Border.all(color: AppColors.yellow2, width: 1),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: AppColors.yellow2),
                          Expanded(
                            child: CustomText(
                              text: location.isEmpty ? "Address" : location,
                              textAlign: TextAlign.start,
                              fontColor: AppColors.yellow2,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: addressError.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h, left: 15.w),
                      child: CustomText(
                        text: addressError,
                        fontColor: AppColors.errorColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: CustomButton(
                  onTap: () {
                    if (_validateForm()) {
                      showSuccessDialog(context);
                    }
                  },
                  text: "Continue",
                  borderColor: AppColors.blackColor,
                  verticalPadding: 20.h,
                  horizontalPadding: 10.w,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
