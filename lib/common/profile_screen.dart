import 'package:bee_kind/core/user/edit_profile_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.yellow2, width: 2.w),
                  image: DecorationImage(image: AssetImage(AssetsPath.dummy)),
                ),
              ),
            ),
            CustomText(
              text: "John Smith",
              fontSize: 18.sp,
              weight: FontWeight.bold,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetsPath.phone, width: 25.w),
                  SizedBox(width: 10.w),
                  CustomText(text: "+123-456-7890", fontSize: 18.sp),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            ProfileOption(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              image: AssetsPath.person,
              text: "Edit Profile",
            ),
            SizedBox(height: 20.w),
            ProfileOption(
              onTap: () {},
              image: AssetsPath.location,
              text: "Address",
            ),
            SizedBox(height: 20.w),
            ProfileOption(
              onTap: () {},
              isNotification: true,
              image: AssetsPath.notifications,
              text: "Notifications",
            ),
            SizedBox(height: 20.w),
            ProfileOption(
              onTap: () {},
              image: AssetsPath.card,
              text: "Payment Accounts",
            ),
            SizedBox(height: 20.w),
            ProfileOption(
              onTap: () {},
              image: AssetsPath.help,
              text: "Help & Support",
            ),
            SizedBox(height: 20.w),
            ProfileOption(onTap: () {}, image: AssetsPath.faq, text: "FAQs"),
            SizedBox(height: 30.w),
            CustomButton(
              onTap: () {},
              text: "Delete Account",
              gradientColors: [AppColors.whiteColor, AppColors.whiteColor],
            ),
            SizedBox(height: 20.w),
            CustomButton(onTap: () {}, text: "Logout"),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatefulWidget {
  const ProfileOption({
    super.key,
    required this.onTap,
    required this.image,
    required this.text,
    this.isNotification = false,
  });
  final VoidCallback onTap;
  final String image;
  final String text;
  final bool isNotification;

  @override
  State<ProfileOption> createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<ProfileOption> {
  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 40.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(widget.image, height: 30.h, width: 30.h),
                    SizedBox(width: 10.w),
                    CustomText(text: widget.text, fontSize: 18.sp),
                  ],
                ),
                widget.isNotification
                    ? slidingToggleButton(
                        value: isToggled,
                        onChanged: (newValue) {
                          setState(() {
                            isToggled = newValue;
                          });
                        },
                      )
                    : Icon(Icons.arrow_forward_rounded),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.blackColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30.r),
              ),
              height: 2.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget slidingToggleButton({
    required bool value,
    ValueChanged<bool>? onChanged,
    double width = 40,
    double height = 25,
    Duration animationDuration = const Duration(milliseconds: 200),
    Key? key,
  }) {
    return GestureDetector(
      key: key,
      onTap: () => onChanged?.call(!value),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? AppColors.yellow2 : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: height - 4,
            height: height - 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
