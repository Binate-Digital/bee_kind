import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Import your existing widgets and utilities
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? selectedGender;
  DateTime? selectedDate;

  // Error strings
  String dateError = "";
  String genderError = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Edit Profile",
      button: // Save Button
      Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
        child: CustomButton(
          onTap: () {},
          text: "Save",
          borderColor: AppColors.blackColor,
          verticalPadding: 20.h,
          horizontalPadding: 10.w,
          fontSize: 18.sp,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Static Profile Picture
              Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.yellow1.withValues(alpha: 0.2),
                  border: Border.all(color: AppColors.yellow2, width: 2),
                ),
                margin: EdgeInsets.symmetric(vertical: 15.h),
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Image.asset(AssetsPath.camera),
                ),
              ),
              CustomText(text: "Profile Picture", fontSize: 18.sp),

              // First Name and Last Name
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

              // Email
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: CustomTextField(
                  hint: "Email",
                  controller: emailController,
                  validator: (value) => Validation.validateEmail(value),
                  prefxicon: AssetsPath.email,
                ),
              ),

              // Phone
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: CustomTextField(
                  hint: "Phone",
                  controller: phoneController,
                  validator: (value) => Validation.validatePhoneNumber(value),
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
                      items: ["Male", "Female", "Other", "Prefer not to say"],
                      initialValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                          genderError =
                              ""; // Clear error when selection changes
                        });
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
            ],
          ),
        ),
      ),
    );
  }
}
