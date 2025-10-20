import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/order_item.dart';
import 'package:bee_kind/widgets/stepper_widget.dart';
import 'package:bee_kind/widgets/vertical_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackOrderScreen extends StatelessWidget {
  TrackOrderScreen({super.key, this.isTracking = false, this.onTap});
  final bool isTracking;
  final VoidCallback? onTap;

  final int currentStep = 5; // Changed to 2 to show active states
  final List<String> steps = [
      AssetsPath.box,
      AssetsPath.truck,
      AssetsPath.carry,
    ];

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
      title: "Track order",
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            OrderItem(hideButton: true, onTap: () {}),
            SizedBox(height: 20.h),
            HorizontalStepper(currentStep: currentStep, steps: steps),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: onTap ?? () {},
              child: CustomText(
                text: isTracking ? "Cancel Order" : "Track Rider",
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
    );
  }
}
