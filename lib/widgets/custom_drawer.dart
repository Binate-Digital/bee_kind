import 'package:bee_kind/common/payment_accounts.dart';
import 'package:bee_kind/common/terms_and_conditions_screen.dart';
import 'package:bee_kind/core/user/store/orders_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      margin: EdgeInsets.only(right: 100.w),
      child: Column(
        children: [
          // Header Container with profile
          Container(
            height: 280.h,
            decoration: BoxDecoration(
              color: AppColors.yellow2,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30.r)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState?.closeDrawer(),
                        child: Icon(
                          Icons.close,
                          size: 27.w,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: 20.w),
                    ],
                  ),
                ),
                // Profile Picture
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  child: ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow1.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppColors.blackColor,
                          width: 2.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 30,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Name and Phone Number
                CustomText(
                  text: "John Doe",
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.blackColor,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "+1 (555) 123-4567",
                  fontSize: 18.sp,
                  fontColor: AppColors.blackColor,
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: AssetsPath.home,
                  title: "Home",
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to home page
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: AssetsPath.orders,
                  title: "Order History",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrdersHistoryScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: AssetsPath.payment,
                  title: "Payment Accounts",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentAccountsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: AssetsPath.terms,
                  title: "Terms & Conditions",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TermsAndConditionsView(
                          screenTitle: 'Terms & Conditions',
                        ),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: AssetsPath.privacy,
                  title: "Privacy Policy",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TermsAndConditionsView(
                          screenTitle: 'Privacy Policy',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: _buildLogoutButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(right: 150.w, top: 15.h, bottom: 15.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.yellow1, AppColors.yellow2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: AppColors.blackColor, width: 0.5.w),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Row(
              children: [
                Image.asset(
                  AssetsPath.logout,
                  width: 22.w,
                  color: AppColors.blackColor,
                ),
                SizedBox(width: 10),
                CustomText(
                  text: "Logout",
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.blackColor,
                ),
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15.w, left: 15.w),
              child: Image.asset(icon, width: 24.w, color: AppColors.yellow2),
            ),
            CustomText(
              text: title,
              fontSize: 18.sp,
              weight: FontWeight.bold,
              fontColor: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
