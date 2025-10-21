import 'package:bee_kind/common/notifications.dart';
import 'package:bee_kind/common/profile/profile_screen.dart';
import 'package:bee_kind/core/user/home_screen.dart';
import 'package:bee_kind/core/user/store/cart_screen.dart';
import 'package:bee_kind/core/user/store/orders_list_screen.dart';
import 'package:bee_kind/core/vendor/dashboard_screen.dart';
import 'package:bee_kind/core/vendor/my_orders_screen.dart';
import 'package:bee_kind/core/vendor/order_requests_screen.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_drawer.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key, this.appBarTitle, this.currIndex});
  final String? appBarTitle;
  final int? currIndex;

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _currentIndex = 0;

  final prefs = SharedPrefs();

  bool isVendor = false;

  List<BottomTab> _tabs = [];

  @override
  void initState() {
    super.initState();

    isVendor = prefs.getString("role") == "vendor";

    _tabs = [
      BottomTab(
        label: isVendor ? "Dashboard" : 'Home',
        image: AssetsPath.home,
        selectedImage: AssetsPath.home,
      ),
      BottomTab(
        label: isVendor ? "Order\nRequests" : 'My Cart',
        image: isVendor ? AssetsPath.orderRequests : AssetsPath.mycart,
        selectedImage: isVendor ? AssetsPath.orderRequests : AssetsPath.mycart,
      ),
      BottomTab(
        label: 'My Orders',
        image: AssetsPath.orders,
        selectedImage: AssetsPath.orders,
      ),
      BottomTab(
        label: 'Settings',
        image: AssetsPath.settings,
        selectedImage: AssetsPath.settings,
      ),
    ];
    // Set initial index from widget parameter if provided
    if (widget.currIndex != null) {
      _currentIndex = widget.currIndex!;
    }
  }

  @override
  void didUpdateWidget(BaseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update current index when widget parameter changes
    if (widget.currIndex != null && widget.currIndex != oldWidget.currIndex) {
      setState(() {
        _currentIndex = widget.currIndex!;
      });
    }
  }

  Widget _buildCurrentScreen() {
    final screens = [
      isVendor ? DashboardScreen() : UserHomeScreen(),
      isVendor ? OrderRequestsScreen() : CartScreen(),
      isVendor ? MyOrdersScreen() : OrdersListScreen(),
      ProfileViewScreen(),
    ];
    return screens[_currentIndex];
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: scaffoldKey,
        extendBody: true,
        drawer: CustomDrawer(scaffoldKey: scaffoldKey, isVendor: isVendor),
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
            text: _tabs[_currentIndex].label,
            fontSize: 22.sp,
            weight: FontWeight.bold,
            fontColor: AppColors.blackColor,
          ),
          centerTitle: true,
        ),
        body: _buildCurrentScreen(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
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
