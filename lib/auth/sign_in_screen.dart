import 'package:bee_kind/auth/create_account_screen.dart';
import 'package:bee_kind/auth/forgot_password_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/validation.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_scaffold.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/create_profile_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailCtrl = TextEditingController();

  final TextEditingController passwordCtrl = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isObscure = true;

  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
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
                text: "Sign In",
                fontSize: 22.sp,
                weight: FontWeight.bold,
              ),
            ),
            Form(
              key: loginFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    hint: "Email",
                    prefxicon: AssetsPath.email,
                    validator: (value) => Validation.validateEmail(value),
                    controller: emailCtrl,
                  ),
                  SizedBox(height: 15.h),
                  CustomTextField(
                    hint: "Password",
                    prefxicon: AssetsPath.password,
                    isSuffixIcon: true,
                    isObscure: isObscure,
                    controller: passwordCtrl,
                    validator: (value) => Validation.validatePassword(value),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: CustomButton(
                      onTap: () {
                        if (loginFormKey.currentState!.validate()) {
                          setState(() {
                            globalEmail = emailCtrl.text;
                          });
                          debugPrint("global email 2: $globalEmail");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfileScreen()),
                          );
                        } else {
                          debugPrint("Form validation failed");
                        }
                      },
                      borderColor: AppColors.blackColor,
                      text: "Sign In",
                      verticalPadding: 20.h,
                      horizontalPadding: 10.w,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: CustomText(
                      text: "Forgot your password?",
                      fontSize: 22.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 250.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Don't have an account?\t\t",
                          fontSize: 20.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateAccountScreen(),
                              ),
                            );
                          },
                          child: CustomText(
                            text: "Sign Up",
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
}
