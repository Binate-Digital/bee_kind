import 'package:bee_kind/common/create_profile_screen.dart';
import 'package:bee_kind/common/payment_accounts.dart';
import 'package:bee_kind/common/profile/address_screen.dart';
import 'package:bee_kind/common/profile/faq.dart';
import 'package:bee_kind/common/profile/help_and_support_screen.dart';
import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/core/user/edit_profile_screen.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/delete_account_confirmation_dialog.dart';
import 'package:bee_kind/widgets/dialogs/logout_confirmation_dialog.dart';
import 'package:bee_kind/widgets/profile_options_widget.dart';
import 'package:bee_kind/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final prefs = SharedPrefs();

  final baseController = Get.find<BaseViewController>();

  bool isVendor = false;

  @override
  void initState() {
    super.initState();
    isVendor = prefs.getString("role") == "vendor";
  }

  @override
  Widget build(BuildContext context) {
    print(baseController.profile.value?.data?.profilePicture);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Obx(() {
              final profilePicture = baseController.profile.value?.data?.profilePicture;
              return UserAvatarWidget(
                selectedImgPath: profilePicture,
                placeHolder: AssetsPath.dummy,
                isViewOnly: true,
                radius: 130.r,
              );
            }),

            SizedBox(height: 20.h),
            Obx(() {
              final data = baseController.profile.value?.data;
              return CustomText(
                text: isVendor
                    ? data?.businessName ?? ""
                    : "${data?.firstName ?? ''} ${data?.lastName ?? ''}",
                fontSize: 18.sp,
                weight: FontWeight.bold,
              );
            }),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Obx(() {
                final data = baseController.profile.value?.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetsPath.phone, width: 25.w),
                    SizedBox(width: 10.w),
                    CustomText(
                      text: data?.phoneNumber ?? "N/A",
                      fontSize: 18.sp,
                    ),
                  ],
                );
              }),
            ),
            if (isVendor) ...[
              SizedBox(height: 20.h),
              Obx(() {
                final hide =
                    baseController.profile.value?.data?.hideProfile ?? false;
                return ProfileOption(
                  onTap: () {},
                  isNotification: true,
                  image: AssetsPath.notifications,
                  text: "Hide Profile",
                  initialToggleValue: hide,
                  onToggleChanged: (newVal) async {
                    await baseController.toggleHideProfile(context);
                  },
                );
              }),
            ],
            SizedBox(height: 30.h),
            ProfileOption(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => isVendor
                        ? CreateProfileScreen(isEdit: true, Token: prefs.getUserToken().toString(),)
                        : EditProfileScreen(),
                  ),
                );
              },
              image: AssetsPath.person,
              text: "Edit Profile",
            ),

            prefs.getString("role")=="user"?
                Column(
                  children: [
                    SizedBox(height: 20.h),
                    ProfileOption(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddressScreen()),
                      ),
                      image: AssetsPath.location,
                      text: "Address",
                    ),
                  ],
                ):SizedBox(),

            SizedBox(height: 20.h),
            ProfileOption(
              onTap: () {
                if (baseController.profile.value?.data?.isNotificationEnabled ==
                    false) {
                  baseController.profile.value?.data?.isNotificationEnabled =
                      true;
                } else {
                  baseController.profile.value?.data?.isNotificationEnabled =
                      false;
                }
              },
              isNotification: true,
              initialToggleValue:
                  baseController.profile.value?.data?.isNotificationEnabled ??
                  false,
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
