// import 'package:bee_kind/common/notifications.dart';
// import 'package:bee_kind/common/profile/profile_screen.dart';
// import 'package:bee_kind/controllers/base_view_controller.dart';
// import 'package:bee_kind/core/user/home_screen.dart';
// import 'package:bee_kind/core/user/store/cart_screen.dart';
// import 'package:bee_kind/core/user/store/orders_list_screen.dart';
// import 'package:bee_kind/core/vendor/dashboard_screen.dart';
// import 'package:bee_kind/core/vendor/my_orders_screen.dart';
// import 'package:bee_kind/core/vendor/order_requests_screen.dart';
// import 'package:bee_kind/utils/app_colors.dart';
// import 'package:bee_kind/utils/assets_path.dart';
// import 'package:bee_kind/widgets/custom_drawer.dart';
// import 'package:bee_kind/widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class BaseView extends StatelessWidget {
//   BaseView({super.key});
//
//   final controller = Get.put(BaseViewController());
//
//   /// Build screen based on current tab + role
//   Widget _buildCurrentScreen() {
//     final isVendor = controller.isVendor.value;
//
//     final screens = [
//       isVendor ? DashboardScreen() : UserHomeScreen(),
//       isVendor ? OrderRequestsScreen() : CartScreen(),
//       isVendor ? MyOrdersScreen() : OrdersListScreen(),
//       SettingsScreen(),
//     ];
//
//     return screens[controller.currentIndex.value];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Obx(() {
//         final isVendor = controller.isVendor.value;
//         final tabs = controller.tabs(isVendor);
//
//         return Scaffold(
//           key: controller.scaffoldKey,
//           extendBody: true,
//
//           drawer: CustomDrawer(
//             scaffoldKey: controller.scaffoldKey,
//             isVendor: isVendor,
//           ),
//
//           // ----------------------- APP BAR -----------------------
//           appBar: AppBar(
//             leading: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: GestureDetector(
//                 onTap: () => controller.scaffoldKey.currentState?.openDrawer(),
//                 child: Image.asset(AssetsPath.drawer),
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//                 child: GestureDetector(
//                   onTap: () {
//                    controller. getNotifications();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => NotificationsScreen()),
//                     );
//                   } ,
//                   child: Image.asset(AssetsPath.notifications),
//                 ),
//               ),
//             ],
//             backgroundColor: AppColors.whiteColor,
//             elevation: 0.0,
//             centerTitle: true,
//
//             /// Reactive title
//             title: CustomText(
//               text: tabs[controller.currentIndex.value].label,
//               fontSize: 22.sp,
//               weight: FontWeight.bold,
//               fontColor: AppColors.blackColor,
//             ),
//           ),
//
//           // ----------------------- BODY -----------------------
//           body: _buildCurrentScreen(),
//
//           // ----------------------- BOTTOM NAV -----------------------
//           bottomNavigationBar: CustomBottomNavigationBar(
//             tabs: tabs,
//             controller: controller,
//           ),
//         );
//       }),
//     );
//   }
// }
//





import 'package:bee_kind/common/notifications.dart';
import 'package:bee_kind/common/profile/profile_screen.dart';
import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/core/user/home_screen.dart';
import 'package:bee_kind/core/user/store/cart_screen.dart';
import 'package:bee_kind/core/user/store/orders_list_screen.dart';
import 'package:bee_kind/core/vendor/dashboard_screen.dart';
import 'package:bee_kind/core/vendor/my_orders_screen.dart';
import 'package:bee_kind/core/vendor/order_requests_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_drawer.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BaseView extends StatefulWidget {
  final int initialIndex;

  const BaseView({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  late final BaseViewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BaseViewController());

    // Set the starting tab once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isVendor = controller.isVendor.value;
      final tabsLength = controller.tabs(isVendor).length;

      final safeIndex = widget.initialIndex.clamp(0, tabsLength - 1);
      controller.currentIndex.value = safeIndex;
    });
  }

  /// Build screen based on current tab + role
  Widget _buildCurrentScreen() {
    final isVendor = controller.isVendor.value;

    final screens = [
      isVendor ? DashboardScreen() : UserHomeScreen(),
      isVendor ? OrderRequestsScreen() : CartScreen(),
      isVendor ? MyOrdersScreen() : OrdersListScreen(),
      SettingsScreen(),
    ];

    return screens[controller.currentIndex.value];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Obx(() {
        final isVendor = controller.isVendor.value;
        final tabs = controller.tabs(isVendor);

        return Scaffold(
          key: controller.scaffoldKey,
          extendBody: true,
          drawer: CustomDrawer(
            scaffoldKey: controller.scaffoldKey,
            isVendor: isVendor,
          ),
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GestureDetector(
                onTap: () => controller.scaffoldKey.currentState?.openDrawer(),
                child: Image.asset(AssetsPath.drawer),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: GestureDetector(
                  onTap: () {
                    controller.getNotifications();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationsScreen()),
                    );
                  },
                  child: Image.asset(AssetsPath.notifications),
                ),
              ),
            ],
            backgroundColor: AppColors.whiteColor,
            elevation: 0.0,
            centerTitle: true,
            title: CustomText(
              text: tabs[controller.currentIndex.value].label,
              fontSize: 22.sp,
              weight: FontWeight.bold,
              fontColor: AppColors.blackColor,
            ),
          ),
          body: _buildCurrentScreen(),
          bottomNavigationBar: CustomBottomNavigationBar(
            tabs: tabs,
            controller: controller,
          ),
        );
      }),
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

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final List<BottomTab> tabs;
  final BaseViewController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
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
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isSelected = controller.currentIndex.value == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.yellow2 : Colors.transparent,
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
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
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
    );
  }
}