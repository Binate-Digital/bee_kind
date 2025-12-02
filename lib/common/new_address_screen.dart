import 'dart:convert';
import 'dart:developer';

import 'package:bee_kind/models/data_models/address_data_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_constants.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_google_maps.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key, this.isEdit = false, this.address});
  final bool isEdit;
  final AddressDataModel? address;

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  GoogleMapController? mapController;

  /// -------------------------------
  /// UI & INPUT CONTROLLERS
  /// -------------------------------
  TextEditingController apartmentNumberController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();

  /// -------------------------------
  /// ADDRESS TYPE
  /// -------------------------------
  String selectedAddressType = "home";
  String addressTypeError = "";

  /// -------------------------------
  /// LOCATION PICKER
  /// -------------------------------
  String locationAddress = "";
  LocationModel? pickedLocationModel;

  /// -------------------------------
  /// LOADING STATE
  /// -------------------------------
  bool isLoading = false;

  final network = Network();

  /// -------------------------------
  /// PICK LOCATION
  /// -------------------------------
  Future<void> pickLocation(
    BuildContext context,
    Function setSheetState,
  ) async {
    try {
      LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlacePicker(AppConstants.googleApiKey),
        ),
      );

      log("RESULT: ${result.formattedAddress}");

      pickedLocationModel = LocationModel(
        addressName: selectedAddressType,
        type: "Point",
        address: result.formattedAddress ?? "",
        coordinates: result.latLng != null
            ? [result.latLng!.latitude, result.latLng!.longitude]
            : [],
      );

      setSheetState(() {
        locationAddress = pickedLocationModel?.address ?? "";
      });
    } catch (e) {
      log("Error picking location: $e");
    }
  }

  /// -------------------------------
  /// SAVE ADDRESS TO API
  /// -------------------------------
  Future<void> saveAddress() async {
    if (pickedLocationModel == null) {
      AppDialogs.showToast("Please select location.");
      return;
    }

    setState(() => isLoading = true);

    /// Build final model
    AddressDataModel model = AddressDataModel(
      addressId: null,
      isDefault: true,
      addressName: selectedAddressType,
      apartmentNumber: apartmentNumberController.text.trim(),
      floorNumber: floorNumberController.text.trim(),
      location: pickedLocationModel,
    );

    /// API body
    final body = model.toJson();

    log("FINAL BODY => ${jsonEncode(body)}");

    final response = await network.postRequest(
      endPoint: NetworkStrings.addAddress,
      data: body,
      isHeaderRequire: true,
    );

    setState(() => isLoading = false);

    if (response == null) {
      AppDialogs.showToast("Something went wrong.");
      return;
    }

    if (response.data["status"] == true) {
      AppDialogs.showToast("Address Added Successfully");

      Navigator.pop(context); // close sheet
      Navigator.pop(context);
    } else {
      AppDialogs.showToast(response.data["message"] ?? "Failed");
    }
  }

  /// -------------------------------
  /// UPDATE ADDRESS API
  /// -------------------------------
  Future<void> updateAddress() async {
    if (pickedLocationModel == null) {
      AppDialogs.showToast("Please select location.");
      return;
    }

    setState(() => isLoading = true);

    AddressDataModel model = AddressDataModel(
      addressId: widget.address?.addressId, // <---- VERY IMPORTANT
      isDefault: true,
      addressName: selectedAddressType,
      apartmentNumber: apartmentNumberController.text.trim(),
      floorNumber: floorNumberController.text.trim(),
      location: pickedLocationModel,
    );

    final body = model.toJson();
    log("FINAL UPDATE BODY => ${jsonEncode(body)}");

    final response = await network.patchRequest(
      endPoint: NetworkStrings.updateUserAddress,
      data: body,
      isHeaderRequire: true,
    );

    setState(() => isLoading = false);

    if (response == null) {
      AppDialogs.showToast("Something went wrong.");
      return;
    }

    if (response.data["status"] == true) {
      AppDialogs.showToast("Address Updated Successfully");

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      AppDialogs.showToast(response.data["message"] ?? "Update failed");
    }
  }

  @override
  void initState() {
    super.initState();

    /// Prefill for edit mode
    if (widget.isEdit && widget.address != null) {
      selectedAddressType = widget.address!.addressName ?? "home";
      apartmentNumberController.text = widget.address!.apartmentNumber ?? "";
      floorNumberController.text = widget.address!.floorNumber ?? "";
      locationAddress = widget.address!.location?.address ?? "";
      pickedLocationModel = widget.address!.location;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAddAddressBottomSheet();
    });
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
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// ----- HEADER -----
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

                    /// ----- ADDRESS TYPE -----
                    CustomDropdown(
                      items: ["home", "work", "other"],
                      initialValue: selectedAddressType,
                      onChanged: (value) {
                        setSheetState(() {
                          selectedAddressType = value ?? "";
                          addressTypeError = "";
                        });
                      },
                      hintText: "Address Type (Home, Work, etc.)",
                    ),

                    SizedBox(height: 20.h),

                    /// ----- LOCATION PICKER -----
                    GestureDetector(
                      onTap: () => pickLocation(context, setSheetState),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.yellow1.withValues(alpha: 0.2),
                          border: Border.all(
                            color: AppColors.yellow2,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 330.w,
                              child: Align(
                                alignment: AlignmentGeometry.centerLeft,
                                child: CustomText(
                                  text: locationAddress.isNotEmpty
                                      ? locationAddress
                                      : "Location",
                                  overflow: TextOverflow.ellipsis,
                                  fontColor: AppColors.yellow2,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                            Icon(Icons.location_on, color: AppColors.yellow2),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// ----- APT + FLOOR -----
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hint: "Apt/Suite/Unit",
                            keyboardType: TextInputType.number,
                            controller: apartmentNumberController,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomTextField(
                            hint: "Floor Number",
                            keyboardType: TextInputType.number,
                            controller: floorNumberController,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    /// ----- BUTTONS -----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Cancel
                        SizedBox(
                          width: 190.w,
                          child: CustomButton(
                            text: "Cancel",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            gradientColors: [
                              AppColors.whiteColor,
                              AppColors.whiteColor,
                            ],
                            textColor: Colors.black,
                            borderColor: Colors.grey.shade400,
                          ),
                        ),

                        CustomButton(
                          width: 190.w,
                          text: widget.isEdit
                              ? "Update Address"
                              : "Add Address",
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () {
                                  if (widget.isEdit) {
                                    updateAddress();
                                  } else {
                                    saveAddress();
                                  }
                                },
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
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
