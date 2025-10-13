import 'dart:io';

import 'package:bee_kind/auth/pin_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_fonts.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailCtrl = TextEditingController();

  final TextEditingController passwordCtrl = TextEditingController();

  final TextEditingController confirmPasswordCtrl = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isObscure = true;

  bool isAlsoObscure = true;

  bool isChecked = false;

  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: CustomText(
                text: "Create Account",
                fontSize: 22.sp,
                weight: FontWeight.bold,
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    hint: "Email",
                    prefxicon: AssetsPath.email,
                    controller: emailCtrl,
                    validator: (value) => Validation.validateEmail(value),
                  ),
                  SizedBox(height: 15.h),
                  CustomTextField(
                    hint: "Password",
                    prefxicon: AssetsPath.password,
                    isSuffixIcon: true,
                    isObscure: isObscure,
                    validator: (value) => Validation.validatePassword(value),
                    controller: passwordCtrl,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.blackColor.withValues(alpha: 0.4),
                        size: 25.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  CustomTextField(
                    hint: "Confirm Password",
                    prefxicon: AssetsPath.password,
                    isSuffixIcon: true,
                    controller: confirmPasswordCtrl,
                    validator: (value) => Validation.validateConfirmPassword(
                      value,
                      passwordCtrl.text,
                    ),
                    isObscure: isAlsoObscure,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isAlsoObscure = !isAlsoObscure;
                        });
                      },
                      child: Icon(
                        isAlsoObscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.blackColor.withValues(alpha: 0.4),
                        size: 25.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: CustomButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          debugPrint("VALIDATION SUCCESSFUL");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PinScreen(isAccountCreate: true),
                            ),
                          );
                        } else {
                          debugPrint("VALIDATION failed");
                        }
                      },
                      text: "Sign Up",
                      borderColor: AppColors.blackColor,
                      verticalPadding: 20.h,
                      horizontalPadding: 10.w,
                      fontSize: 18.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Row(
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
                            side: BorderSide(
                              color: AppColors.yellow2,
                              width: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 330.w,
                          child: RichText(
                            softWrap: true,
                            text: TextSpan(
                              text: "By sign-in you agree to our ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.blackColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.blackColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  socialLoginButton(
                    onTap: () {},
                    icon: AssetsPath.google,
                    buttonColor: Colors.red,
                    text: "Sign Up with Google",
                  ),
                  SizedBox(height: 20.h),
                  Platform.isIOS
                      ? socialLoginButton(
                          onTap: () {},
                          icon: AssetsPath.apple,
                          buttonColor: AppColors.blackColor,
                          text: "Sign Up with Apple",
                        )
                      : Offstage(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 35.h,
                      top: Platform.isIOS ? 30.h : 60.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Already have an account?\t\t",
                          fontSize: 20.sp,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: CustomText(
                            text: "Sign In",
                            fontSize: 20.sp,
                            underlined: true,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget socialLoginButton({
    VoidCallback? onTap,
    String? text,
    Color? buttonColor,
    String? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
          color: buttonColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon!, width: 22.w),
              SizedBox(width: 10.w),
              CustomText(
                text: text,
                weight: FontWeight.bold,
                fontColor: AppColors.whiteColor,
                fontSize: 18.sp,
                fontFamily: AppFonts.ralewayBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
