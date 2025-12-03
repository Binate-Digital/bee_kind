// live_tracking.dart

import 'dart:developer';

import 'package:bee_kind/models/response_models/single_order_response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_constants.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/dialogs/cancel_order_dialog.dart';
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
import 'package:url_launcher/url_launcher.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key, required this.orderId});

  final String orderId;

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  final network = Network();

  GoogleMapController? mapController;

  bool isLoading = true;
  String? errorMessage;
  Order? _order;
  List<dynamic> _statusTimeline = [];

  /// Horizontal stepper icons
  final Map steps = {
    "images": [AssetsPath.box, AssetsPath.truck, AssetsPath.carry],
  };

  /// Map data
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  /// Coordinates (based on API)
  LatLng? pickupLatLng; // store
  LatLng? dropoffLatLng; // user

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchOrderDetails();
      await _calculateETA();
    });
  }

  String? estimatedTimeText;
  bool isCalculatingEta = false;

  Future<void> _calculateETA() async {
    if (pickupLatLng == null || dropoffLatLng == null) return;

    try {
      setState(() => isCalculatingEta = true);

      final origin = "${pickupLatLng!.latitude},${pickupLatLng!.longitude}";
      final destination =
          "${dropoffLatLng!.latitude},${dropoffLatLng!.longitude}";

      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=${AppConstants.googleApiKey}";

      final response = await network.getDirect(url); // ⬅️ ADD helper below

      if (response == null) {
        estimatedTimeText = "ETA unavailable";
        setState(() => isCalculatingEta = false);
        return;
      }

      final data = response.data;

      if (data["routes"] != null &&
          data["routes"].length > 0 &&
          data["routes"][0]["legs"] != null &&
          data["routes"][0]["legs"].length > 0) {
        final leg = data["routes"][0]["legs"][0];

        final duration = leg["duration"]["text"]; // e.g. "18 mins"
        estimatedTimeText = "ETA: $duration";
      } else {
        estimatedTimeText = "ETA unavailable";
      }

      setState(() => isCalculatingEta = false);
    } catch (e) {
      log("ETA error: $e");
      estimatedTimeText = "ETA unavailable";
      setState(() => isCalculatingEta = false);
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getSingleOrder}/${widget.orderId}",
        isHeaderRequire: true,
        isToast: false,
      );

      if (response == null) {
        setState(() {
          isLoading = false;
          errorMessage = "Unable to fetch order details.";
        });
        return;
      }

      log("SINGLE ORDER RESPONSE: ${response.data}");

      final model = SingleOrderResponseModel.fromJson(response.data);

      if (model.status != true || model.data?.order == null) {
        setState(() {
          isLoading = false;
          errorMessage = model.message ?? "Order not found.";
        });
        return;
      }

      final order = model.data!.order!;
      final statusTimeline = model.data!.statusTimeline ?? [];

      // Init map-related data
      _setupLocationsFromOrder(order);
      await _loadMapMarkersAndPolyline();

      setState(() {
        _order = order;
        _statusTimeline = statusTimeline;
        isLoading = false;
      });
    } catch (e) {
      log("fetchSingleOrder Exception: $e");
      setState(() {
        isLoading = false;
        errorMessage = "Something went wrong while loading order.";
      });
    }
  }

  /// ---------------------------------------------------
  /// Initialize pickup & dropoff from store + user address
  /// coordinates are [lat, lng]
  /// ---------------------------------------------------
  void _setupLocationsFromOrder(Order order) {
    // Default fallback if coordinates are missing
    const fallbackPickup = LatLng(24.861714457432807, 67.07000228675905);
    const fallbackDropoff = LatLng(24.873714457432807, 67.08200228675905);

    // Store (pickup)
    final storeCoords = order.storeAddress?.coordinates;
    if (storeCoords != null && storeCoords.length >= 2) {
      final lat = storeCoords[0];
      final lng = storeCoords[1];
      pickupLatLng = LatLng(lat, lng);
    } else {
      pickupLatLng = fallbackPickup;
    }

    // User (dropoff)
    final userCoords = order.userAddress?.coordinates;
    if (userCoords != null && userCoords.length >= 2) {
      final lat = userCoords[0];
      final lng = userCoords[1];
      dropoffLatLng = LatLng(lat, lng);
    } else {
      dropoffLatLng = fallbackDropoff;
    }
  }

  /// ---------------------------------------------------
  /// Load markers & polyline once we know pickup/dropoff
  /// ---------------------------------------------------
  Future<void> _loadMapMarkersAndPolyline() async {
    if (pickupLatLng == null || dropoffLatLng == null) return;

    final BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 35)),
      AssetsPath.marker,
    );

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId("pickup"),
          position: pickupLatLng!,
          infoWindow: const InfoWindow(title: "Store Location"),
          icon: customIcon,
        ),
        Marker(
          markerId: const MarkerId("dropoff"),
          position: dropoffLatLng!,
          infoWindow: const InfoWindow(title: "Delivery Location"),
          icon: customIcon,
        ),
      };

      _polylines = {
        Polyline(
          polylineId: const PolylineId("route"),
          color: AppColors.yellow2,
          width: 5,
          points: [pickupLatLng!, dropoffLatLng!],
        ),
      };
    });
  }

  /// ---------------------------------------------------
  /// Call driver / support (static phone for now)
  /// ---------------------------------------------------
  Future<void> launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// ---------------------------------------------------
  /// Map order status → step index (1–3)
  /// ---------------------------------------------------
  int _stepFromStatus(String? status) {
    final s = (status ?? "").toLowerCase();

    if (s.contains("delivered") || s.contains("completed")) {
      return 3;
    } else if (s.contains("shipped") ||
        s.contains("out_for_delivery") ||
        s.contains("in_delivery") ||
        s.contains("in transit")) {
      return 2;
    }
    // pending / accepted / preparing / default
    return 1;
  }

  /// ---------------------------------------------------
  /// Build vertical status lists from statusTimeline / statusHistory
  /// ---------------------------------------------------
  List<String> get _progressSteps {
    if (_statusTimeline.isNotEmpty) {
      return _statusTimeline.map((e) => e.toString()).toList();
    }

    if (_order?.statusHistory != null && _order!.statusHistory!.isNotEmpty) {
      return _order!.statusHistory!.map((e) => e.toString()).toList();
    }

    // Fallback: single step with current status
    return [_order?.status ?? "Order placed"];
  }

  List<String> get _locationSteps {
    final userAddress = _order?.userAddress?.address ?? "Unknown address";
    return List<String>.filled(_progressSteps.length, userAddress);
  }

  List<String> get _timeSteps {
    // No per-step timestamps → placeholder
    return List<String>.filled(_progressSteps.length, "--");
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Track Order")),
        body: Center(
          child: Text(
            errorMessage!,
            style: TextStyle(fontSize: 16.sp, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // At this point, _order is guaranteed non-nullx
    final order = _order!;
    final userAddress = order.userAddress;
    final storeAddress = order.storeAddress;

    final firstItem = (order.items != null && order.items!.isNotEmpty)
        ? order.items!.first
        : null;

    final currentStep = _stepFromStatus(order.status);

    return AppBarBaseView(
      title: estimatedTimeText ?? "Calculating ETA...",
      button: _buildTopContent(context, order, currentStep),
      body: _buildMapAndBottomContent(
        order,
        userAddress,
        storeAddress,
        firstItem,
      ),
    );
  }

  /// ---------------------------------------------------
  /// TOP: Horizontal stepper, cancel, summary, vertical stepper
  /// ---------------------------------------------------
  Widget _buildTopContent(BuildContext context, Order order, int currentStep) {
    return Container(
      decoration: BoxDecoration(color: AppColors.whiteColor),
      height: 250.h,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),

              /// HORIZONTAL STEPPER
              HorizontalStepper(
                currentStep: currentStep,
                steps: steps["images"],
              ),

              SizedBox(height: 20.h),

              /// CANCEL ORDER
              GestureDetector(
                onTap: () => cancelOrderDialog(context, widget.orderId),
                child: CustomText(
                  text: "Cancel Order",
                  underlined: true,
                  fontSize: 23.sp,
                  weight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30.h),

              /// ORDER SUMMARY / CONTACT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Delivery personnel name: N/A",
                        fontSize: 18.sp,
                      ),
                      SizedBox(height: 10.h),
                      CustomText(text: "Car: Not available", fontSize: 16.sp),
                      SizedBox(height: 10.h),
                      CustomText(
                        text: "Phone: Not available!",
                        fontSize: 16.sp,
                        fontColor: AppColors.yellow2,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),

                  // Right
                  CustomButton(
                    width: 100.w,
                    text: "Call",
                    onTap: () {
                      launchCaller("+1 919-555-8247");
                    },
                  ),
                ],
              ),

              SizedBox(height: 30.h),
              Container(color: AppColors.blackColor, height: 0.5.w),
              SizedBox(height: 30.h),

              /// ORDER STATUS DETAILS TITLE
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

              /// VERTICAL STEPPER
              VerticalStepper(
                currentStep: currentStep,
                progressSteps: _progressSteps,
                locationSteps: _locationSteps,
                timeSteps: _timeSteps,
                activeColor: AppColors.blackColor,
                inactiveColor: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------------------------------------------
  /// BODY: Google Map + pickup/dropoff + order card
  /// ---------------------------------------------------
  Widget _buildMapAndBottomContent(
    Order order,
    UserAddress? userAddress,
    StoreAddress? storeAddress,
    Items? firstItem,
  ) {
    final pickupAddress =
        storeAddress?.address ?? "Store address not available";
    final dropoffAddress =
        userAddress?.address ?? "Delivery address not available";

    return CustomGoogleMap(
      onMapCreated: (controller) => mapController = controller,
      initialCameraPosition: CameraPosition(
        target:
            pickupLatLng ?? const LatLng(24.861714457432807, 67.07000228675905),
        zoom: 14,
      ),
      markers: _markers,
      circles: const {},
      polylines: _polylines,
      myLocationEnabled: false,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
      buildingsEnabled: true,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),

            /// PICKUP (store)
            // LocationBar(onTap: () {}, address: pickupAddress, isPickup: true),

            // Container(
            //   margin: EdgeInsets.only(left: 330.w),
            //   width: 2.w,
            //   height: 30.h,
            //   child: VerticalDottedLine(
            //     color: AppColors.yellow2,
            //     strokeWidth: 2,
            //     dashWidth: 2,
            //     dashSpace: 3,
            //     roundedDots: true,
            //   ),
            // ),

            /// DROPOFF (user)
            // LocationBar(onTap: () {}, address: dropoffAddress, isPickup: false),

            /// ORDER SUMMARY CARD
            OrderItem(
              hideButton: true,
              onTap: () {},
              verticalPadding: 45.h,
              horizontalPadding: 45.w,
              productName: firstItem?.productName,
              quantity: firstItem?.quantity,
              price: firstItem?.price,
              status: order.status,
              imageUrl: firstItem?.productImage,
            ),
          ],
        ),
      ),
    );
  }
}
