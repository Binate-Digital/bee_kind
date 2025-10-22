import 'dart:math';

import 'package:bee_kind/core/user/store/product_categories_list.dart';
import 'package:bee_kind/core/user/store/selected_store.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/user_location_permission.dart';
import 'package:bee_kind/widgets/address_bar.dart';
import 'package:bee_kind/widgets/categories.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_google_maps.dart';
import 'package:bee_kind/widgets/custom_slider.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/selected_store_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String location = "";
  String differentLocation = "";
  bool showWindow = false;

  GoogleMapController? mapController;
  late CameraPosition initialPosition;
  Set<Marker> markers = {};

  double? latitude;
  double? longitude;
  LatLng? currentLatLng;
  double? zoom;
  bool showMarker = true;

  Future<void> loadUserLocation() async {
    final position = await UserLocation.getCurrentLocation();

    final BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(50, 55)), // you can adjust this size
      AssetsPath.marker, // your static constant
    );

    if (position != null) {
      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
        markers = {
          Marker(
            markerId: const MarkerId('user_location'),
            position: currentLatLng ?? LatLng(24.870912, 67.0826496),
            icon: customIcon,
            onTap: () {
              setState(() {
                showWindow = true;
              });
            },
          ),
        };
        debugPrint("latitude: ${currentLatLng!.latitude} longitude: ${currentLatLng!.longitude}");
      });

      // Move camera to user's location once map is created
      if (mapController != null) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            currentLatLng ?? LatLng(24.870912, 67.0826496),
            15,
          ),
        );
      }
    } else {
      debugPrint("⚠️ Unable to fetch user location.");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserLocation(); // fetch user's live location
    });
  }

  double currentValue = 50.0;

  double currentRadius = 10.0;

  final double minValue = 1.0;
  final double maxValue = 100.0;

  final double minRadius = 0.5;
  final double maxRadius = 100.0;

  Set<Circle> circles = {};

  void updateCircle(LatLng center, double radiusMiles) {
    setState(() {
      circles = {
        Circle(
          circleId: const CircleId('delivery_radius'),
          center: center,
          radius: radiusMiles * 1609.34, // ✅ miles → meters
          fillColor: AppColors.yellow2.withValues(alpha: 0.2),
          strokeColor: AppColors.yellow2,
          strokeWidth: 2,
        ),
      };
    });
  }

  void fitCameraToCircle(LatLng center, double radiusMiles) async {
    final southwest = LatLng(
      center.latitude - radiusMiles / 69.0,
      center.longitude - radiusMiles / (69.0 * cos(center.latitude * pi / 180)),
    );
    final northeast = LatLng(
      center.latitude + radiusMiles / 69.0,
      center.longitude + radiusMiles / (69.0 * cos(center.latitude * pi / 180)),
    );

    await mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: southwest, northeast: northeast),
        50,
      ),
    );
  }

  String formatPrice(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  String formatRadius(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return CustomGoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(24.870912, 67.0826496),
        zoom: 10,
      ),
      markers: markers,
      circles: circles,
      onMapCreated: (controller) => mapController = controller,
      widget: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomTextField(
              hint: "Search",
              bgColor: AppColors.whiteColor,
              bdColor: AppColors.yellow2,
              hintColor: AppColors.blackColor.withValues(alpha: 0.3),
              prefxicon: AssetsPath.search,
              isSuffixIcon: true,
              suffixIcon: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20.h,
                              horizontal: 20.w,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDropdown(
                                  items: [
                                    "Category 1",
                                    "Category 2",
                                    "Category 3",
                                  ],
                                  hintText: "Product Category",
                                ),
                                SizedBox(height: 30.h),

                                CustomSliderWidget(
                                  label: "Price Range",
                                  min: minValue,
                                  max: maxValue,
                                  initialValue: currentValue,
                                  unit: "\$",
                                  formatValue: (value) =>
                                      '\$${value.toStringAsFixed(2)}',
                                  onChanged: (value) {
                                    debugPrint("Selected price: $value");
                                  },
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: CustomSliderWidget(
                                    label: "Delivery Radius",
                                    min: minRadius,
                                    max: maxRadius,
                                    initialValue: currentRadius,
                                    unit: "mi", // ✅
                                    onChanged: (value) {
                                      setState(() => currentRadius = value);
                                      if (currentLatLng != null) {
                                        updateCircle(
                                          currentLatLng!,
                                          currentRadius,
                                        );
                                        fitCameraToCircle(
                                          currentLatLng!,
                                          currentRadius,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30.h),
                                  child: CustomButton(
                                    onTap: () => Navigator.pop(context),
                                    text: "Search",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Image.asset(AssetsPath.filter, color: AppColors.yellow2),
              ),
            ),
          ),
          AddressBar(onTap: () {}),
          showWindow
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => StoreScreen()),
                    );
                  },
                  child: SelectedStoreLocation(),
                )
              : SizedBox(width: 90.w, height: 163.h),
          Container(
            margin: EdgeInsets.only(top: 170.h),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            color: AppColors.whiteColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.w, right: 30.w),
                  child: Row(
                    children: [
                      CustomText(
                        text: "Categories",
                        fontColor: AppColors.blackColor,
                        fontSize: 22.sp,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 140.h,
                  child: ListView.builder(
                    itemCount: 6,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryWiseProductsList(fromHome: true),
                          ),
                        ),
                        child: Categories(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
