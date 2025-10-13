import 'package:bee_kind/common/notifications.dart';
import 'package:bee_kind/core/user/home_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_drawer.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserBaseView extends StatefulWidget {
  const UserBaseView({super.key, this.appBarTitle});
  final String? appBarTitle;

  @override
  State<UserBaseView> createState() => _UserBaseViewState();
}

class _UserBaseViewState extends State<UserBaseView> {
  int _currentIndex = 0;

  final List<BottomTab> _tabs = [
    BottomTab(
      label: 'Home',
      image: AssetsPath.home,
      selectedImage: AssetsPath.home,
    ),
    BottomTab(
      label: 'My Cart',
      image: AssetsPath.mycart,
      selectedImage: AssetsPath.mycart,
    ),
    BottomTab(
      label: 'My Order',
      image: AssetsPath.orders,
      selectedImage: AssetsPath.orders,
    ),
    BottomTab(
      label: 'Profile',
      image: AssetsPath.profile,
      selectedImage: AssetsPath.profile,
    ),
  ];

  Widget _buildCurrentScreen() {
    final screens = [
      UserHomeScreen(),
      Placeholder(),
      Placeholder(),
      Placeholder(),
    ];
    return screens[_currentIndex];
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.whiteColor,
      drawer: CustomDrawer(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GestureDetector(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            child: Image.asset(AssetsPath.drawer),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationsScreen()),
              ),
              child: Image.asset(AssetsPath.notifications),
            ),
          ),
        ],
        backgroundColor: AppColors.whiteColor,
        elevation: 0.0,
        title: CustomText(
          text: widget.appBarTitle ?? "Home",
          fontSize: 22.sp,
          weight: FontWeight.bold,
          fontColor: AppColors.blackColor,
        ),
        centerTitle: true,
      ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Container(
          height: 90.h,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(35.r),
            border: Border.all(color: AppColors.blackColor, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.15),
                blurRadius: 25.r,
                offset: const Offset(0, 5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final isSelected = _currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.yellow2
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(35.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isSelected ? tab.selectedImage : tab.image,
                          width: 25.w,
                          height: 25.h,
                          color: isSelected
                              ? AppColors.blackColor
                              : AppColors.yellow2,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: "Raleway",
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class BottomTab {
  final String label;
  final String image;
  final String selectedImage;

  BottomTab({
    required this.label,
    required this.image,
    required this.selectedImage,
  });
}
