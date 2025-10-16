import 'package:bee_kind/common/payment_accounts.dart';
import 'package:bee_kind/common/profile/address_screen.dart';
import 'package:bee_kind/common/profile/faq.dart';
import 'package:bee_kind/common/profile/help_and_support_screen.dart';
import 'package:bee_kind/core/user/edit_profile_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/delete_account_confirmation_dialog.dart';
import 'package:bee_kind/widgets/logout_confirmation_dialog.dart';
import 'package:bee_kind/widgets/profile_options_widget.dart';
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
            SizedBox(height: 20.h),
            ProfileOption(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddressScreen()),
              ),
              image: AssetsPath.location,
              text: "Address",
            ),
            SizedBox(height: 20.h),
            ProfileOption(
              onTap: () {},
              isNotification: true,
              image: AssetsPath.notifications,
              text: "Notifications",
            ),
            SizedBox(height: 20.h),
            ProfileOption(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PaymentAccountsScreen()),
              ),
              image: AssetsPath.card,
              text: "Payment Accounts",
            ),
            SizedBox(height: 20.h),
            ProfileOption(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HelpAndSupportScreen()),
              ),
              image: AssetsPath.help,
              text: "Help & Support",
            ),
            SizedBox(height: 20.h),
            ProfileOption(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FAQScreen()),
              ),
              image: AssetsPath.faq,
              text: "FAQs",
            ),
            SizedBox(height: 30.h),
            CustomButton(
              onTap: () => deleteAccountConfirmationDialog(context),
              text: "Delete Account",
              gradientColors: [AppColors.whiteColor, AppColors.whiteColor],
            ),
            SizedBox(height: 20.h),
            CustomButton(
              onTap: () => logoutConfirmationDialog(context),
              text: "Logout",
            ),
            SizedBox(height: 130.h),
          ],
        ),
      ),
    );
  }
}
