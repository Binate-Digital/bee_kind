import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/cancel_order_dialog.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_google_maps.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/location_bar.dart';
import 'package:bee_kind/widgets/order_item.dart';
import 'package:bee_kind/widgets/stepper_widget.dart';
import 'package:bee_kind/widgets/vertical_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  final int currentStep = 5;
  GoogleMapController? mapController;
  // Changed to 2 to show active states
  final Map steps = {
    "images": [
      AssetsPath.box,
      AssetsPath.truck,
      AssetsPath.carry,
      AssetsPath.openBox,
    ],
  };

  final Map differentSteps = {
    "progress": [
      "Order In Transit - Dec 17",
      "Order ... Customs Port - Dec 16",
      "Orders are ... Shipped - Dec 15",
      "Order is in Packing - Dec 15",
      "Verified Payments - Dec 15",
    ],
    "location": [
      "32 Manchester Ave. Ringgold, GA 30736",
      "45 Shipping Lane, Customs Port, NY 10001",
      "78 Distribution Center, Warehouse Zone, TX 75001",
      "32 Manchester Ave. Ringgold, GA 30736",
      "32 Manchester Ave. Ringgold, GA 30736",
    ],
    "time": ["03:20 PM", "02:45 PM", "12:30 PM", "10:15 AM", "09:00 AM"],
  };

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "",
      button: Container(
        decoration: BoxDecoration(color: AppColors.whiteColor),
        height: 250.h,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                HorizontalStepper(
                  currentStep: currentStep,
                  steps: steps["images"],
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () => cancelOrderDialog(context),
                  child: CustomText(
                    text: "Cancel Order",
                    underlined: true,
                    fontSize: 20.sp,
                    weight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                Container(color: AppColors.blackColor, height: 0.5.w),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    CustomText(
                      text: "Order Status Details",
                      fontSize: 18.sp,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                VerticalStepper(
                  currentStep: currentStep,
                  progressSteps: differentSteps["progress"],
                  locationSteps: differentSteps["location"],
                  timeSteps: differentSteps["time"],
                  activeColor: AppColors.blackColor,
                  inactiveColor: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomGoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.861714457432807, 67.07000228675905),
          zoom: 15,
        ),
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              LocationBar(
                onTap: () {},
                address: "USA New York, Lorem Ipsum Road",
                isPickup: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 330.w),
                width: 2.w,
                height: 30.h,
                child: VerticalDottedLine(
                  color: AppColors.yellow2,
                  strokeWidth: 2,
                  dashWidth: 2,
                  dashSpace: 3,
                  roundedDots: true,
                ),
              ),
              LocationBar(
                onTap: () {},
                address: "USA New York, Lorem Ipsum Road",
                isPickup: false,
              ),
              OrderItem(
                hideButton: true,
                onTap: () {},
                verticalPadding: 40.h,
                horizontalPadding: 40.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
