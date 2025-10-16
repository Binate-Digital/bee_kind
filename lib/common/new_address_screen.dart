import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_google_maps.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  GoogleMapController? mapController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((value) {
      showAddAddressBottomSheet();
    });
    super.initState();
  }

  void showAddAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: widget.isEdit
                      ? "Edit Address Details"
                      : "Address Details",
                  fontSize: 20.sp,
                  weight: FontWeight.bold,
                  fontColor: Colors.black87,
                ),
                SizedBox(height: 20.h),

                // Address Name
                CustomTextField(hint: "Address Name"),
                SizedBox(height: 16.h),

                // Zip Code Row
                Row(
                  children: [
                    Expanded(child: CustomTextField(hint: "Zip Code")),
                  ],
                ),
                SizedBox(height: 16.h),

                // Street Address Line 1
                CustomTextField(hint: "Street Address (Line 1)"),
                SizedBox(height: 16.h),

                // Street Address Line 2
                CustomTextField(hint: "Street Address (Line 2)"),
                SizedBox(height: 16.h),

                // City and State Row
                Row(
                  children: [
                    Expanded(child: CustomTextField(hint: "City")),
                    SizedBox(width: 12.w),
                    Expanded(child: CustomTextField(hint: "State")),
                  ],
                ),
                SizedBox(height: 30.h),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    SizedBox(
                      width: 190.w,
                      child: CustomButton(
                        text: "Cancel",
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        // Assuming your CustomButton has gradient support
                        // If not, you might need to customize it
                        gradientColors: [
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                        ],
                        textColor: Colors.black,
                        borderColor: Colors.grey.shade400,
                      ),
                    ),

                    // Add Address Button
                    SizedBox(
                      width: 190.w,
                      child: CustomButton(
                        text: widget.isEdit ? "Save Address" : "Add Address",
                        onTap: () {
                          // Handle add address logic
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomGoogleMap(
      onMapCreated: (controller) => mapController = controller,
      initialCameraPosition: const CameraPosition(
        target: LatLng(24.861714457432807, 67.07000228675905),
        zoom: 15,
      ),
      widget: Container(),
    );
  }
}
