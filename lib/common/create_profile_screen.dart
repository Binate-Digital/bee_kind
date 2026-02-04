import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_keyboard_action_widget.dart';
import 'package:bee_kind/widgets/custom_slider.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../controllers/base_view_controller.dart';

class CreateProfileScreen extends StatelessWidget {
  CreateProfileScreen({super.key, this.isEdit = false});

  final bool isEdit;

  final focusNode = FocusNode();
  final anotherFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    Get.put(
      BaseViewController(),
    ); // Initialize BaseViewController for dependencies

    // Load existing profile data if in edit mode
    if (isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.loadProfileDataForEdit();
      });
    }

    return Obx(
      () => AppBarBaseView(
        title: isEdit ? "Edit Profile" : "Create Profile",
        isLeading: isEdit,
        // button: Container(
        //   color: AppColors.whiteColor,
        //   height: 100.h,
        //   padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        //   child: CustomButton(
        //     onTap: () =>
        //         controller.handleCreateProfile(context, isEdit: isEdit),
        //     text: isEdit ? "Edit Profile" : "Continue",
        //     borderColor: AppColors.blackColor,
        //     isLoading: controller.isLoading.value,
        //     verticalPadding: 20.h,
        //     horizontalPadding: 10.w,
        //     fontSize: 18.sp,
        //   ),
        // ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// -------------------- PROFILE IMAGE --------------------
                  GestureDetector(
                    onTap: () => controller.pickImage(context, isProfile: true),
                    child: controller.buildImageContainer(
                      image: controller.profileImage.value,
                      isCircular: true,
                      placeholderText: "Upload Profile Picture",
                      isProfile: true,
                    ),
                  ),
                  CustomText(
                    text: controller.isVendor.value
                        ? "Upload Business Logo"
                        : "Upload Image",
                    fontSize: 22.sp,
                  ),
                  SizedBox(height: 30.h),

                  /// -------------------- USER FIELDS --------------------
                  if (!controller.isVendor.value) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 180.w,
                          child: CustomTextField(
                            hint: "First Name",
                            controller: controller.firstNameController,
                            validator: (v) =>
                                Validation.validateName(v, "First Name"),
                          ),
                        ),
                        SizedBox(
                          width: 180.w,
                          child: CustomTextField(
                            hint: "Last Name",
                            controller: controller.lastNameController,
                            validator: (v) =>
                                Validation.validateName(v, "Last Name"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],

                  /// -------------------- VENDOR FIELDS --------------------
                  if (controller.isVendor.value) ...[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CustomTextField(
                        hint: "Business Name",
                        controller: controller.businessNameController,
                        validator: (v) =>
                            Validation.validateName(v, "Business Name"),
                        prefxicon: AssetsPath.person,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CustomTextField(
                        hint: "Business Description",
                        controller: controller.businessDescriptionController,
                        validator: (v) =>
                            Validation.validateName(v, "Business Description"),
                        prefxicon: AssetsPath.person,
                      ),
                    ),
                  ],

                  /// -------------------- EMAIL --------------------
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomTextField(
                      hint: "Email",
                      isEditable: false,
                      controller: controller.emailController,
                    ),
                  ),

                  /// -------------------- PHONE --------------------
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomTextField(
                      hint: "Phone",
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          Validation.validatePhoneNumber(value),
                      inputFormatters: [
                        USPhoneNumberFormatter(),
                        LengthLimitingTextInputFormatter(16),
                      ],
                      prefxicon: AssetsPath.phone,
                    ),
                  ),

                  /// -------------------- USER-SPECIFIC FIELDS --------------------
                  if (!controller.isVendor.value) ...[
                    /// DOB
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () => controller.selectDate(context),
                    //       child: Container(
                    //         padding: EdgeInsets.symmetric(
                    //           vertical: 20.h,
                    //           horizontal: 15.w,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: AppColors.yellow1.withValues(alpha: 0.2),
                    //           border: Border.all(
                    //             color: AppColors.yellow2,
                    //             width: 1,
                    //           ),
                    //           borderRadius: BorderRadius.circular(30.r),
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             CustomText(
                    //               text: controller.formatDate(
                    //                 controller.selectedDate.value,
                    //               ),
                    //               fontColor: AppColors.yellow2,
                    //               fontSize: 18.sp,
                    //             ),
                    //             Image.asset(AssetsPath.calendar, width: 18.w),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Visibility(
                    //       visible: controller.dateError.value.isNotEmpty,
                    //       child: Padding(
                    //         padding: EdgeInsets.only(top: 4.h, left: 15.w),
                    //         child: CustomText(
                    //           text: controller.dateError.value,
                    //           fontColor: AppColors.errorColor,
                    //           fontSize: 14.sp,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    /// Gender
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.h),
                          child: CustomDropdown(
                            items: controller.genders,
                            initialValue: controller.selectedGender.value,
                            onChanged: (value) {
                              controller.selectedGender.value = value ?? '';
                              controller.genderError.value = '';
                            },
                            hintText: "Gender",
                          ),
                        ),
                        Visibility(
                          visible: controller.genderError.value.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: 10.h,
                              left: 15.w,
                              top: 4.h,
                            ),
                            child: CustomText(
                              text: controller.genderError.value,
                              fontColor: AppColors.errorColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    /// -------------------- ADDRESS TYPE (USER ONLY) --------------------
                    CustomText(
                      text: "Address Details",
                      fontSize: 20.sp,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: 10.h),

                    CustomDropdown(
                      items: ["home", "work", "other"],
                      initialValue: controller.selectedAddressType.value,
                      onChanged: (value) {
                        controller.selectedAddressType.value = value ?? '';
                        controller.addresstypeError.value = '';
                      },
                      hintText: "Address Type (Home, Work, etc.)",
                    ),
                    Visibility(
                      visible: controller.addresstypeError.value.isNotEmpty,
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 10.h,
                          top: 10.h,
                          right: 210.w,
                        ),
                        child: CustomText(
                          text: controller.addresstypeError.value,
                          fontColor: AppColors.errorColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],

                  /// -------------------- ADDRESS (VENDOR ONLY) --------------------
                  // if (controller.isVendor.value) ...[
                  //   CustomTextField(
                  //     hint: "Business Address",
                  //     controller: controller.streetAddressController,
                  //     validator: Validation.validateAddressName,
                  //   ),
                  //   SizedBox(height: 10.h),
                  // ],

                  /// -------------------- LOCATION --------------------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => controller.pickLocation(context),
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
                                child: Obx(
                                  () => CustomText(
                                    text:
                                        controller
                                            .locationAddress
                                            .value
                                            .isNotEmpty
                                        ? controller.locationAddress.value
                                        : "Location",
                                    textAlign: TextAlign.start,
                                    fontColor: AppColors.yellow2,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                              Icon(Icons.location_on, color: AppColors.yellow2),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            controller.locationAddressError.value.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.h, left: 15.w),
                          child: CustomText(
                            text: controller.locationAddressError.value,
                            fontColor: AppColors.errorColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  /// -------------------- VENDOR HOURS --------------------
                  if (controller.isVendor.value)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// OPEN TIME
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => controller.pickTime(
                                  context,
                                  isOpenTime: true,
                                ),
                                child: SizedBox(
                                  width: 180.w,
                                  child: CustomTextField(
                                    hint: "Open Time",
                                    isEditable: false,
                                    controller: TextEditingController(
                                      text: controller.openTime.value != null
                                          ? controller.formatTime(
                                              controller.openTime.value,
                                            )
                                          : "Open Time",
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    controller.openTimeError.value.isNotEmpty,
                                child: Container(
                                  width: 180.w,
                                  padding: EdgeInsets.only(
                                    bottom: 10.h,
                                    top: 4.h,
                                    right: 50.w,
                                  ),
                                  child: CustomText(
                                    text: controller.openTimeError.value,
                                    fontColor: AppColors.errorColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// CLOSE TIME
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => controller.pickTime(
                                  context,
                                  isOpenTime: false,
                                ),
                                child: SizedBox(
                                  width: 180.w,
                                  child: CustomTextField(
                                    hint: "Close Time",
                                    isEditable: false,
                                    controller: TextEditingController(
                                      text: controller.closeTime.value != null
                                          ? controller.formatTime(
                                              controller.closeTime.value,
                                            )
                                          : "Close Time",
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    controller.closeTimeError.value.isNotEmpty,
                                child: Container(
                                  width: 180.w,
                                  padding: EdgeInsets.only(
                                    bottom: 10.h,
                                    top: 4.h,
                                    right: 50.w,
                                  ),
                                  child: CustomText(
                                    text: controller.closeTimeError.value,
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

                  /// -------------------- APT + FLOOR --------------------
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomKeyboardActionWidget(
                            focusNode: focusNode,
                            child: CustomTextField(
                              focusNode: focusNode,
                              hint: "Apt/Suite/Unit",
                              onEditingComplete: () =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              keyboardType: TextInputType.number,
                              controller: controller.apartmentNumberController,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomKeyboardActionWidget(
                            focusNode: anotherFocusNode,
                            child: CustomTextField(
                              hint: "Floor Number",
                              focusNode: anotherFocusNode,
                              onEditingComplete: () =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              keyboardType: TextInputType.number,
                              controller: controller.floorNumberController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// -------------------- OFF DAYS + DELIVERY RADIUS (VENDOR) --------------------
                  if (controller.isVendor.value) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown(
                          items: controller.days
                              .where(
                                (day) =>
                                    !controller.selectedOffDays.contains(day),
                              )
                              .toList(),
                          initialValue: null,
                          onChanged: (value) {
                            if (value != null &&
                                !controller.selectedOffDays.contains(value)) {
                              controller.selectedOffDays.add(value);
                            }
                          },
                          hintText: "Select Off Day",
                        ),
                        if (controller.selectedOffDays.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: controller.selectedOffDays
                                .map(
                                  (day) => Chip(
                                    backgroundColor: AppColors.yellow1
                                        .withValues(alpha: 0.25),
                                    label: Text(day),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onDeleted: () =>
                                        controller.selectedOffDays.remove(day),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CustomText(
                        text: "Delivery Radius",
                        fontFamily: "Raleway",
                        weight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: CustomSliderWidget(
                        min: controller.minRadius,
                        max: controller.maxRadius,
                        initialValue: controller.currentRadius.value,
                        unit: "mi",
                        onChanged: (value) =>
                            controller.currentRadius.value = value,
                      ),
                    ),

                    Column(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              controller.pickImage(context, isProfile: false),
                          child: controller.buildImageContainer(
                            image: controller.businessLicense.value,
                            isCircular: false,
                            placeholderText:
                                "Upload License\nBusiness Registration",
                          ),
                        ),
                        Visibility(
                          visible: controller.licenseError.value.isNotEmpty,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 4.h),
                            child: CustomText(
                              text: controller.licenseError.value,
                              fontColor: AppColors.errorColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  /// -------------------- VENDOR SAVE BUTTON --------------------
                  if (controller.isVendor.value)
                    Container(
                      color: AppColors.whiteColor,
                      height: 100.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                        horizontal: 20.w,
                      ),
                      child: CustomButton(
                        onTap: () => controller.handleCreateProfile(
                          context,
                          isEdit: isEdit,
                        ),
                        text: isEdit ? "Update Profile" : "Create Profile",
                        borderColor: AppColors.blackColor,
                        isLoading: controller.isLoading.value,
                        verticalPadding: 20.h,
                        horizontalPadding: 10.w,
                        fontSize: 18.sp,
                      ),
                    ),

                  /// -------------------- USER CONSENT --------------------
                  if (!controller.isVendor.value) ...[
                    SizedBox(height: 10.h),
                    CustomText(
                      text: "Identity & Age Verification",
                      fontSize: 20.sp,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: 10.h),

                    /// AGE CONSENT
                    Row(
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: Checkbox(
                            value: controller.isChecked.value,
                            checkColor: AppColors.yellow2,
                            onChanged: (value) =>
                                controller.isChecked.value = value!,
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
                                "I consent to upload my government ID and a live selfie for identity and age verification. I confirm that I am 21 years or older",
                            fontSize: 15.sp,
                            textAlign: TextAlign.start,
                            maxLines: 3,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    /// VERIFY ID BUTTON
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: CustomButton(
                        onTap: () =>
                            controller.launchVeriffVerification(context),
                        text: "Verify Age & Id",
                        borderColor: AppColors.blackColor,
                        isLoading: controller.isVerifyLoading.value,
                        verticalPadding: 20.h,
                        horizontalPadding: 10.w,
                        fontSize: 18.sp,
                      ),
                    ),

                    /// DELIVERY CONFIRMATION
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Checkbox(
                              value: controller.isDeliveryChecked.value,
                              checkColor: AppColors.yellow2,
                              onChanged: (value) =>
                                  controller.isDeliveryChecked.value = value!,
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
                    Container(
                      color: AppColors.whiteColor,
                      height: 100.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                        // horizontal: 20.w,
                      ),
                      child: CustomButton(
                        onTap: () => controller.handleCreateProfile(
                          context,
                          isEdit: isEdit,
                        ),
                        text: isEdit ? "Edit Profile" : "Continue",
                        borderColor: AppColors.blackColor,
                        isLoading: controller.isLoading.value,
                        verticalPadding: 20.h,
                        horizontalPadding: 10.w,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],

                  /// Extra space at bottom
                  SizedBox(height: controller.isVendor.value ? 150.h : 60.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
