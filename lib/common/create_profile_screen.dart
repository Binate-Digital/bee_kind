import 'dart:developer';
import 'dart:io';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_constants.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/bottom_sheets/image_picker_bottom_sheet.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_slider.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/dialogs/error_dialog.dart';
import 'package:bee_kind/widgets/dialogs/success_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_location_picker/map_location_picker.dart';

String globalEmail = "";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final prefs = SharedPrefs();

  String? selectedGender;
  String? selectedCity;
  String? selectedState;
  String? selectedOffDay;
  DateTime? selectedDate;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  List<String> selectedOffDays = [];

  String location = "";
  bool isVendor = false;

  // Error strings
  String dateError = "";
  String genderError = "";
  String cityError = "";
  String stateError = "";
  String addressError = "";
  String openTimeError = "";
  String closeTimeError = "";
  String licenseError = "";

  final double minRadius = 0.5;
  final double maxRadius = 100.0;
  double currentRadius = 50.0;

  bool isChecked = false;
  bool isDeliveryChecked = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessDescriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController streetAddress1Controller = TextEditingController();
  TextEditingController streetAddress2Controller = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? profileImage;
  File? businessLisence;


  Widget buildImageContainer({
    required File? image,
    required bool isCircular,
    required String placeholderText,
    bool isProfile = false,
  }) {
    final borderRadius = isCircular
        ? BorderRadius.circular(100.r)
        : BorderRadius.circular(20.r);

    return Container(
      width: isCircular ? 150.w : double.infinity,
      height: isCircular ? 150.h : 180.h,
      margin: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.yellow1.withValues(alpha: 0.2),
        border: Border.all(color: AppColors.yellow2, width: 2),
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : borderRadius,
      ),
      child: ClipRRect(
        borderRadius: isCircular ? BorderRadius.circular(100.r) : borderRadius,
        child: image != null
            ? Image.file(image, fit: BoxFit.cover, width: double.infinity)
            : Center(
                child: isProfile
                    // 👇 Profile placeholder (camera icon)
                    ? Icon(
                        Icons.camera_alt_rounded,
                        size: 40.w,
                        color: AppColors.yellow2,
                      )
                    // 👇 License placeholder (text)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetsPath.image,
                            color: AppColors.yellow2,
                            width: 40.w,
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            width: 150.w,
                            child: CustomText(
                              text: placeholderText,
                              textAlign: TextAlign.center,
                              fontColor: AppColors.yellow2,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      dateError = "";
      genderError = "";
      cityError = "";
      stateError = "";
      addressError = "";
      openTimeError = "";
      closeTimeError = "";
    });

    if (!isVendor) {
      if (selectedDate == null) {
        dateError = "Date of birth is required";
        isValid = false;
      }
      if (selectedGender == null || selectedGender!.isEmpty) {
        genderError = "Gender is required";
        isValid = false;
      }

      if (!isChecked) {
        errorSnackBar(
          "You must consent to upload your ID and confirm your age.",
          context,
        );
        isValid = false;
      }
      if (!isDeliveryChecked) {
        errorSnackBar(
          "You must confirm that your delivery address matches your ID address.",
          context,
        );
        isValid = false;
      }
    }

    if (selectedCity == null || selectedCity!.isEmpty) {
      cityError = "City is required";
      isValid = false;
    }
    if (selectedState == null || selectedState!.isEmpty) {
      stateError = "State is required";
      isValid = false;
    }

    if (isVendor) {
      if (location.isEmpty) {
        addressError = "Location is required";
        isValid = false;
      }
      if (openTime == null) {
        openTimeError = "Opening time required";
        isValid = false;
      }
      if (closeTime == null) {
        closeTimeError = "Closing time required";
        isValid = false;
      }

      if (businessLisence == null) {
        licenseError = "Business license image is required";
        isValid = false;
      } else {
        licenseError = "";
      }
    }

    if (!formKey.currentState!.validate()) isValid = false;

    return isValid;
  }

  Future<void> pickTime({required bool isOpenTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          openTime = picked;
          openTimeError = "";
        } else {
          closeTime = picked;
          closeTimeError = "";
        }
      });
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "Select Time";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
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
    emailController.text = globalEmail;
    isVendor = prefs.getString("role") == "vendor";
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Create Profile",

      isLeading: false,
      button: Container(
        color: AppColors.whiteColor,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: CustomButton(
          onTap: () {
            if (_validateForm()) {
              debugPrint("validated!");
              showSuccessDialog(context, isVendor: isVendor);
            }
          },
          text: "Continue",
          borderColor: AppColors.blackColor,
          verticalPadding: 20.h,
          horizontalPadding: 10.w,
          fontSize: 18.sp,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showImagePickerBottomSheet(
                      context: context,
                      title: "Upload Profile Picture",
                      target: "profile",
                      onImagePicked: (file) =>
                          setState(() => profileImage = file),
                    );
                  },
                  child: buildImageContainer(
                    image: profileImage,
                    isCircular: true,
                    placeholderText: "Upload Profile Picture",
                    isProfile: true,
                  ),
                ),

                CustomText(text: isVendor ? "Upload Business Logo" : "Upload Image", fontSize: 22.sp),
                SizedBox(height: 30.h),
                if (!isVendor) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: CustomTextField(
                          hint: "First Name",
                          controller: firstNameController,
                          validator: (v) =>
                              Validation.validateName(v, "First Name"),
                        ),
                      ),
                      SizedBox(
                        width: 180.w,
                        child: CustomTextField(
                          hint: "Last Name",
                          controller: lastNameController,
                          validator: (v) =>
                              Validation.validateName(v, "Last Name"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],

                if (isVendor) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomTextField(
                      hint: "Business Name",
                      controller: businessNameController,
                      validator: (v) =>
                          Validation.validateName(v, "Business Name"),
                      prefxicon: AssetsPath.person,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomTextField(
                      hint: "Business Description",
                      controller: businessDescriptionController,
                      validator: (v) =>
                          Validation.validateName(v, "Business Name"),
                      prefxicon: AssetsPath.person,
                    ),
                  ),
                ],

                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: CustomTextField(
                    hint: "Email",
                    isEditable: false,
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
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

                if (!isVendor) ...[
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
                            border: Border.all(
                              color: AppColors.yellow2,
                              width: 1,
                            ),
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

                  SizedBox(height: 20.h),

                  CustomText(
                    text: "Address Details",
                    fontSize: 20.sp,
                    weight: FontWeight.bold,
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "Address Name",
                          controller: addressNameController,
                          validator: (value) =>
                              Validation.validateAddressName(value),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: CustomTextField(
                          hint: "Zip Code",
                          controller: zipCodeController,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validation.validateZipCode(value),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  CustomTextField(
                    hint: "Street Address (Line 1)",
                    controller: streetAddress1Controller,
                    validator: (value) => Validation.validateStreetAddress(
                      value,
                      "Street Address (Line 1)",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    hint: "Street Address (Line 2)",
                    controller: streetAddress2Controller,
                    validator: (value) => Validation.validateStreetAddress(
                      value,
                      "Street Address (Line 2)",
                    ),
                  ),
                ],

                if (isVendor)
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
                                    floatingControlsIconColor:
                                        AppColors.yellow1,
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
                                            title: const Text(
                                              "Selected Location",
                                            ),
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
                                      log(
                                        'long ${loc?.geometry?.location.lng}',
                                      );
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
                            border: Border.all(
                              color: AppColors.yellow2,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: location.isEmpty
                                      ? "Location"
                                      : location,
                                  textAlign: TextAlign.start,
                                  fontColor: AppColors.yellow2,
                                  fontSize: 18.sp,
                                ),
                              ),
                              Icon(Icons.location_on, color: AppColors.yellow2),
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

                SizedBox(height: 10.h),

                if (isVendor)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => pickTime(isOpenTime: true),
                              child: SizedBox(
                                width: 180.w,
                                child: CustomTextField(
                                  hint: "Open Time",
                                  isEditable: false,
                                  controller: TextEditingController(
                                    text: openTime != null
                                        ? formatTime(openTime)
                                        : "Open Time",
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: openTimeError.isNotEmpty,
                              child: Container(
                                width: 180.w,
                                padding: EdgeInsets.only(
                                  bottom: 10.h,
                                  top: 4.h,
                                  right: 50.w,
                                ),
                                child: CustomText(
                                  text: openTimeError,
                                  fontColor: AppColors.errorColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => pickTime(isOpenTime: false),
                              child: SizedBox(
                                width: 180.w,
                                child: CustomTextField(
                                  hint: "Close Time",
                                  isEditable: false,
                                  controller: TextEditingController(
                                    text: closeTime != null
                                        ? formatTime(closeTime)
                                        : "Close Time",
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: closeTimeError.isNotEmpty,
                              child: Container(
                                width: 180.w,
                                padding: EdgeInsets.only(
                                  bottom: 10.h,
                                  top: 4.h,
                                  right: 50.w,
                                ),
                                child: CustomText(
                                  text: closeTimeError,
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

                // ===================== OFF DAYS =====================

                // City and State with errors
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 180.w,
                                child: CustomDropdown(
                                  items: [
                                    "New York City",
                                    "Chicago",
                                    "Houston",
                                  ],
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

                if (isVendor) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdown(
                        items: const [
                          "Monday",
                          "Tuesday",
                          "Wednesday",
                          "Thursday",
                          "Friday",
                          "Saturday",
                          "Sunday",
                        ],
                        initialValue: selectedOffDay,
                        onChanged: (value) {
                          if (value != null &&
                              !selectedOffDays.contains(value)) {
                            setState(() {
                              selectedOffDays.add(value);
                            });
                          }
                        },
                        hintText: "Select Off Day",
                      ),
                      if (selectedOffDays.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: selectedOffDays
                              .map(
                                (day) => Chip(
                                  backgroundColor: AppColors.yellow1.withValues(
                                    alpha: 0.25,
                                  ),
                                  label: Text(day),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () => setState(
                                    () => selectedOffDays.remove(day),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomSliderWidget(
                      label: "Delivery Radius",
                      min: minRadius,
                      max: maxRadius,
                      initialValue: currentRadius,
                      unit: "mi", // ✅
                      onChanged: (value) {
                        setState(() => currentRadius = value);
                      },
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showImagePickerBottomSheet(
                            context: context,
                            title: "Upload Business License",
                            target: "license",
                            onImagePicked: (file) =>
                                setState(() => businessLisence = file),
                          );
                        },
                        child: buildImageContainer(
                          image: businessLisence,
                          isCircular: false,
                          placeholderText:
                              "Upload License\nBusiness Registration",
                        ),
                      ),
                      Visibility(
                        visible: licenseError.isNotEmpty,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 4.h),
                          child: CustomText(
                            text: licenseError,
                            fontColor: AppColors.errorColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (!isVendor) ...[
                  CustomText(
                    text: "Identity & Age Verification",
                    fontSize: 20.sp,
                    weight: FontWeight.bold,
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      SizedBox(
                        width: 40.w,
                        child: Checkbox(
                          value: isChecked,
                          checkColor: AppColors.yellow2,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          fillColor: WidgetStateProperty.all(
                            AppColors.yellow1.withValues(alpha: 0.2),
                          ),
                          side: BorderSide(color: AppColors.yellow2, width: 1),
                        ),
                      ),
                      SizedBox(
                        width: 350.w,
                        child: CustomText(
                          text:
                              "I consent to upload my government ID and a live selfie for identity and age verification. I confirm that I am 21 years or older",
                          fontSize: 15.sp,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: CustomButton(
                      onTap: () {
                        if (_validateForm()) {
                          showSuccessDialog(context);
                        }
                      },
                      text: "Verify Age & Id",
                      borderColor: AppColors.blackColor,
                      verticalPadding: 20.h,
                      horizontalPadding: 10.w,
                      fontSize: 18.sp,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 80.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: Checkbox(
                            value: isDeliveryChecked,
                            checkColor: AppColors.yellow2,
                            onChanged: (value) {
                              setState(() {
                                isDeliveryChecked = value!;
                              });
                            },
                            fillColor: WidgetStateProperty.all(
                              AppColors.yellow1.withValues(alpha: 0.2),
                            ),
                            side: BorderSide(
                              color: AppColors.yellow2,
                              width: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 350.w,
                          child: CustomText(
                            text:
                                "My delivery address matches the address on my ID.",
                            fontSize: 15.sp,
                            textAlign: TextAlign.start,
                            maxLines: 3,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (isVendor)
                  SizedBox(height: 150.h)
                else
                  SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
