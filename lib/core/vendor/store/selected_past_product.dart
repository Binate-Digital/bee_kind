// import 'package:bee_kind/common/base_view.dart';
// import 'package:bee_kind/utils/app_colors.dart';
// import 'package:bee_kind/utils/app_dialogs.dart';
// import 'package:bee_kind/utils/assets_path.dart';
// import 'package:bee_kind/widgets/custom_button.dart';
// import 'package:bee_kind/widgets/custom_text.dart';
// import 'package:bee_kind/widgets/dialogs/delivery_info_dialog.dart';
// import 'package:bee_kind/widgets/dialogs/order_complete_confirmation_dialog.dart';
// import 'package:bee_kind/widgets/stepper_widget.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:bee_kind/models/response_models/vendor_orders_response_model.dart'
//     as vorder;
// import 'package:bee_kind/controllers/store_controller.dart';
// // app_dialogs already imported above; avoid duplicate import
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/delivery_info_dialog.dart';
import 'package:bee_kind/widgets/dialogs/order_complete_confirmation_dialog.dart';
import 'package:bee_kind/widgets/stepper_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bee_kind/models/response_models/vendor_orders_response_model.dart'
    as vorder;
import 'package:bee_kind/controllers/store_controller.dart';
// app_dialogs already imported above; avoid duplicate import
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SelectedOrder extends StatefulWidget {
  SelectedOrder({
    super.key,
    this.vendorOrder,
    this.isCancelled = false,
    this.isCurrent = false,
    this.isAccepted = false,
    this.isComplete = false,
  });
  final vorder.VendorOrder? vendorOrder;
  final bool isCancelled;
  final bool isCurrent;
  final bool isAccepted;
  final bool isComplete;

  @override
  State<SelectedOrder> createState() => _SelectedOrderState();
}

class _SelectedOrderState extends State<SelectedOrder> {
  int currentCarouselIndex = 0;
  int currentStep = 0;
  bool isAccepted = false;
  bool isCurrent = false; // ✅ Local copy to modify dynamically
  bool isComplete = false;

  final List<String> steps = [
    AssetsPath.box,
    AssetsPath.truck,
    AssetsPath.carry,
  ];

  String text = "Ready for Pickup";

  List<String> _getCarouselImages() {
    // Get product images from order items
    if (widget.vendorOrder?.items != null &&
        widget.vendorOrder!.items!.isNotEmpty) {
      return widget.vendorOrder!.items!
          .map((item) => item.productImage ?? AssetsPath.store)
          .toList();
    }
    // Fallback to default store images if no items
    return [AssetsPath.store, AssetsPath.store, AssetsPath.store];
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.isEmpty || imageUrl == AssetsPath.store) {
      return AssetImage(AssetsPath.store);
    }
    return NetworkImage(imageUrl);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _getCustomerName() {
    // Try multiple possible data sources for customer name
    final user = widget.vendorOrder?.user;

    // Check if we have firstName and lastName available
    if ((user?.firstName?.isNotEmpty ?? false) &&
        (user?.lastName?.isNotEmpty ?? false)) {
      return "${user!.firstName} ${user.lastName}";
    }

    // Fallback to name field if available
    if (user?.name?.isNotEmpty ?? false) {
      return user!.name!;
    }

    // Fallback to phone number if name is not available
    if (user?.phoneNumber?.isNotEmpty ?? false) {
      return user!.phoneNumber!;
    }

    if (widget.vendorOrder?.phoneNumber?.isNotEmpty ?? false) {
      return widget.vendorOrder!.phoneNumber!;
    }

    // Final fallback
    return "Customer";
  }

  ImageProvider _getCustomerImage() {
    final user = widget.vendorOrder?.user;
    if (user?.profilePicture?.isNotEmpty ?? false) {
      return NetworkImage(user!.profilePicture!);
    }
    return AssetImage(AssetsPath.dummy);
  }

  @override
  void initState() {
    super.initState();
    isComplete = widget.isComplete;
    _initializeState();
  }

  void _initializeState() {
    final status = widget.vendorOrder?.status?.toLowerCase() ?? '';

    // Initialize flags based on status + widget params
    isAccepted =
        widget.isAccepted ||
        ['accepted', 'ready-for-pickup', 'dispatched'].contains(status);

    // isCurrent triggers the Stepper UI. It should be true for all active stages.
    isCurrent =
        widget.isCurrent ||
        [
          'pending',
          'accepted',
          'ready-for-pickup',
          'dispatched',
        ].contains(status);

    if (status == 'ready-for-pickup') {
      currentStep = 1;
      text = "Order Handed to Delivery Personnel";
    } else if (status == 'dispatched') {
      currentStep = 2;
      text = "Order Completed";
    } else if (status == 'completed') {
      currentStep = 3;
      isComplete = true;
    } else {
      // Default: 'accepted' or others
      currentStep = 0;
      text = "Ready for Pickup";
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeController = Get.find<StoreController>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(30.w, 350.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      items: _getCarouselImages().map((imageUrl) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _getImageProvider(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 290.h,
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 2.0,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentCarouselIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 270.h,
                  left: 170.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [1, 2, 3].asMap().entries.map((entry) {
                      bool isSelected = currentCarouselIndex == entry.key;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: isSelected ? 50.w : 8.w,
                        height: 8.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blackColor,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.whiteColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 70.h,
                    bottom: 20.h,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 150.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 30.r,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        CustomText(
                          text: "Order Requests Detail",
                          fontColor: AppColors.whiteColor,
                          fontSize: 18.sp,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(width: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomText(
                text: "Customer",
                fontSize: 20.sp,
                weight: FontWeight.bold,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.yellow2,
                          width: 2.w,
                        ),
                        image: DecorationImage(
                          image: _getCustomerImage(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomText(
                      text: _getCustomerName(),
                      fontSize: 18.sp,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              CustomText(
                text: "Order Details",
                fontSize: 18.sp,
                weight: FontWeight.bold,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 10.h),

              // Display each item from the order
              if (widget.vendorOrder?.items != null &&
                  widget.vendorOrder!.items!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.vendorOrder!.items!.map((item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:
                              "Product: ${item.productName ?? 'Unknown Product'}",
                          fontSize: 16.sp,
                          fontColor: AppColors.blackColor,
                        ),
                        CustomText(
                          text: "Qty: ${item.quantity ?? 0}",
                          fontSize: 16.sp,
                          fontColor: AppColors.blackColor,
                        ),
                        CustomText(
                          text:
                              "Price: \$${item.price?.toStringAsFixed(2) ?? '0.00'}",
                          fontSize: 16.sp,
                          fontColor: AppColors.blackColor,
                        ),
                        SizedBox(height: 12.h),
                      ],
                    );
                  }).toList(),
                )
              else
                CustomText(
                  text: "No items in order",
                  fontSize: 16.sp,
                  fontColor: AppColors.blackColor,
                ),
              CustomText(
                text: "Order Number: ${widget.vendorOrder?.sId ?? 'N/A'}",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              CustomText(
                text:
                    "Placed on: ${_formatDate(widget.vendorOrder?.createdAt)}",
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 30.h),
              CustomText(
                text: "Delivery Address",
                fontSize: 18.sp,
                weight: FontWeight.bold,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text:
                    widget.vendorOrder?.deliveryAddress ??
                    (widget.vendorOrder?.user?.phoneNumber != null
                        ? "Address: ${widget.vendorOrder!.user!.phoneNumber}"
                        : "No address provided"),
                fontSize: 16.sp,
                fontColor: AppColors.blackColor,
              ),
              SizedBox(height: 20.h),
              // Status action buttons for vendor orders
              if (widget.vendorOrder != null)
                Column(
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if ((widget.vendorOrder?.status ?? '').toLowerCase() ==
                            'pending')
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow2,
                              foregroundColor: AppColors.blackColor,
                            ),
                            onPressed: () async {
                              await storeController.changeVendorOrderStatus(
                                widget.vendorOrder!.sId ?? '',
                                'accepted',
                                context,
                              );
                            },
                            child: const Text('Accept'),
                          ),
                        // Commented out - using stepper flow instead
                        // if ((widget.vendorOrder?.status ?? '').toLowerCase() !=
                        //     'completed')
                        //   ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColors.yellow2,
                        //       foregroundColor: AppColors.blackColor,
                        //     ),
                        //     onPressed: () async {
                        //       await storeController.changeVendorOrderStatus(
                        //         widget.vendorOrder!.sId ?? '',
                        //         'completed',
                        //         context,
                        //       );
                        //     },
                        //     child: Text(
                        //       isCurrent ? 'Ready for Pickup' : 'Mark Complete',
                        //     ),
                        //   ),
                        if ((widget.vendorOrder?.status ?? '').toLowerCase() !=
                                'cancelled' &&
                            isCurrent)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow2,
                              foregroundColor: AppColors.blackColor,
                            ),
                            onPressed: () async {
                              final success = await storeController
                                  .changeVendorOrderStatus(
                                    widget.vendorOrder!.sId ?? '',
                                    'cancelled',
                                    context,
                                  );
                              if (success) {
                                // Navigate to home page and clear navigation stack
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => BaseView()),
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text('Cancel'),
                          ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 30.h),
              // Show individual product prices
              if (widget.vendorOrder?.items != null &&
                  widget.vendorOrder!.items!.isNotEmpty)
                Column(
                  children: widget.vendorOrder!.items!.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomText(
                              text:
                                  "${item.productName ?? 'Product'} x${item.quantity ?? 1}",
                              fontSize: 16.sp,
                              fontColor: AppColors.blackColor,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          CustomText(
                            text: "\$${(item.price ?? 0).toStringAsFixed(2)}",
                            fontSize: 16.sp,
                            fontColor: AppColors.blackColor,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Subtotal",
                    fontSize: 18.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.blackColor,
                  ),
                  CustomText(
                    text:
                        "\$${widget.vendorOrder?.totalPrice?.toStringAsFixed(2) ?? '0.00'}",
                    fontSize: 18.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Delivery Charges",
                    fontSize: 18.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.blackColor,
                  ),
                  CustomText(
                    text: () {
                      // Calculate delivery charges as: totalAmount - sum(items price * qty)
                      final totalAmount =
                          widget.vendorOrder?.totalAmount ?? 0.0;

                      double itemsTotal = 0.0;
                      if (widget.vendorOrder?.items != null) {
                        for (final it in widget.vendorOrder!.items!) {
                          final price = (it.price ?? 0).toDouble();
                          final qty = (it.quantity ?? 1).toDouble();
                          itemsTotal += price * qty;
                        }
                      }

                      final deliveryCharges = totalAmount - itemsTotal;
                      // Show calculated value if positive and finite, otherwise show 0
                      final show =
                          (deliveryCharges.isFinite && deliveryCharges > 0)
                          ? deliveryCharges.toStringAsFixed(2)
                          : '0.00';
                      return "\$$show";
                    }(),
                    fontSize: 18.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Total Bill",
                    fontSize: 18.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.blackColor,
                  ),
                  CustomText(
                    text:
                        "\$${widget.vendorOrder?.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
                    fontSize: 18.sp,
                    fontColor: AppColors.yellow2,
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              // === ORDER STATE LOGIC ===

              // === ORDER STATE LOGIC ===

              // 🟥 Cancelled Orders
              if (widget.isCancelled) ...[
                CustomText(
                  text: "Order Cancelled",
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.blackColor,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: "Cancellation Reason",
                  fontSize: 16.sp,
                  fontColor: AppColors.blackColor,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: "Order was cancelled by the customer or vendor.",
                  fontSize: 16.sp,
                  textAlign: TextAlign.center,
                  fontColor: AppColors.blackColor,
                ),
              ]
              // 🟨 Order Requests (Not Yet Accepted)
              else if (!isAccepted && !isCurrent && !isComplete) ...[
                Padding(
                  padding: EdgeInsets.only(top: 150.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        width: 160.w,
                        text: "Reject",
                        onTap: () => AppDialogs.showToast("Order Rejected!"),
                        verticalPadding: 20.h,
                        gradientColors: [
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                        ],
                        borderColor: AppColors.blackColor,
                      ),
                      CustomButton(
                        width: 160.w,
                        text: "Accept",
                        onTap: () {
                          setState(() {
                            isAccepted = true;
                            isCurrent =
                                true; // ✅ Now this affects the condition below
                            currentStep = 0;
                            text = "Ready for Pickup";
                          });
                        },
                        verticalPadding: 20.h,
                        gradientColors: [AppColors.yellow1, AppColors.yellow2],
                        borderColor: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),
              ]
              // 🟩 Current Orders (Active Step Flow)
              else if (isCurrent) ...[
                HorizontalStepper(currentStep: currentStep, steps: steps),
                SizedBox(height: 20.h),
                CustomText(
                  text: "Select Order Status",
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  fontColor: AppColors.yellow2,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: text,
                  onTap: () async {
                    if (currentStep == 0) {
                      // Case: Ready for Pickup -> Needs Driver Details
                      final driverDetails =
                          await showAddDeliveryPersonnelDialog(context);

                      // If dialog cancelled or no data returned, do nothing
                      if (driverDetails == null) return;

                      // Call API for "ready-for-pickup" with driver details
                      final success = await storeController
                          .changeVendorOrderStatus(
                            widget.vendorOrder!.sId ?? '',
                            'ready-for-pickup',
                            context,
                            driverDetail: driverDetails,
                          );

                      if (success) {
                        setState(() {
                          currentStep = 1;
                          text = "Order Handed to Delivery Personnel";
                        });
                      }
                    } else if (currentStep == 1) {
                      // Call API for "dispatched"
                      final success = await storeController
                          .changeVendorOrderStatus(
                            widget.vendorOrder!.sId ?? '',
                            'dispatched',
                            context,
                          );

                      if (success) {
                        setState(() {
                          currentStep = 2;
                          text = "Order Completed";
                        });
                      }
                    } else if (currentStep == 2) {
                      final confirmResult =
                          await orderCompleteConfirmationDialog(context);
                      if (confirmResult == true) {
                        // Call API for "completed"
                        final success = await storeController
                            .changeVendorOrderStatus(
                              widget.vendorOrder!.sId ?? '',
                              'completed',
                              context,
                            );

                        if (success) {
                          setState(() {
                            currentStep = 3;
                            isComplete = true;
                          });
                          Future.delayed(
                            Duration(seconds: 1),
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => BaseView()),
                            ),
                          );
                        }
                      }
                    } else if (currentStep >= 3) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => BaseView()),
                      );
                    }
                  },
                ),
              ]
              // 🟦 Completed Orders (Past Orders)
              else if (isComplete) ...[
                HorizontalStepper(currentStep: steps.length, steps: steps),
                SizedBox(height: 20.h),
                Center(
                  child: CustomText(
                    text: "Order Completed",
                    fontSize: 18.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                ),
              ],
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

// class SelectedOrder extends StatefulWidget {
//   SelectedOrder({
//     super.key,
//     this.vendorOrder,
//     this.isCancelled = false,
//     this.isCurrent = false,
//     this.isAccepted = false,
//     this.isComplete = false,
//   });
//   final vorder.VendorOrder? vendorOrder;
//   final bool isCancelled;
//   final bool isCurrent;
//   final bool isAccepted;
//   final bool isComplete;

//   @override
//   State<SelectedOrder> createState() => _SelectedOrderState();
// }

// class _SelectedOrderState extends State<SelectedOrder> {
//   int currentCarouselIndex = 0;
//   int currentStep = 0;
//   bool isAccepted = false;
//   bool isCurrent = false; // ✅ Local copy to modify dynamically
//   bool isComplete = false;

//   final List<String> steps = [
//     AssetsPath.box,
//     AssetsPath.truck,
//     AssetsPath.carry,
//   ];

//   String text = "Ready for Pickup";

//   List<String> _getCarouselImages() {
//     // Get product images from order items
//     if (widget.vendorOrder?.items != null &&
//         widget.vendorOrder!.items!.isNotEmpty) {
//       return widget.vendorOrder!.items!
//           .map((item) => item.productImage ?? AssetsPath.store)
//           .toList();
//     }
//     // Fallback to default store images if no items
//     return [AssetsPath.store, AssetsPath.store, AssetsPath.store];
//   }

//   ImageProvider _getImageProvider(String imageUrl) {
//     if (imageUrl.isEmpty || imageUrl == AssetsPath.store) {
//       return AssetImage(AssetsPath.store);
//     }
//     return NetworkImage(imageUrl);
//   }

//   String _formatDate(String? dateStr) {
//     if (dateStr == null) return 'N/A';
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat('dd-MM-yyyy').format(date);
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     currentStep = widget.isCurrent ? 0 : 2;
//     isAccepted =
//         widget.isAccepted ||
//         (widget.vendorOrder?.status?.toLowerCase() == 'accepted');
//     isCurrent =
//         widget.isCurrent ||
//         (widget.vendorOrder?.status?.toLowerCase() == 'pending');
//     isComplete =
//         widget.isComplete ||
//         (widget.vendorOrder?.status?.toLowerCase() == 'completed');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final storeController = Get.find<StoreController>();
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size(30.w, 350.h),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               children: [
//                 Column(
//                   children: [
//                     CarouselSlider(
//                       items: _getCarouselImages().map((imageUrl) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: _getImageProvider(imageUrl),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                       options: CarouselOptions(
//                         height: 290.h,
//                         autoPlay: true,
//                         viewportFraction: 1,
//                         aspectRatio: 2.0,
//                         initialPage: 0,
//                         onPageChanged: (index, reason) {
//                           setState(() {
//                             currentCarouselIndex = index;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   top: 270.h,
//                   left: 170.w,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [1, 2, 3].asMap().entries.map((entry) {
//                       bool isSelected = currentCarouselIndex == entry.key;
//                       return AnimatedContainer(
//                         duration: Duration(milliseconds: 300),
//                         width: isSelected ? 50.w : 8.w,
//                         height: 8.h,
//                         margin: EdgeInsets.symmetric(horizontal: 4.w),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: AppColors.blackColor,
//                             width: 2.w,
//                           ),
//                           borderRadius: BorderRadius.circular(4.r),
//                           color: AppColors.whiteColor,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: 20.w,
//                     right: 20.w,
//                     top: 70.h,
//                     bottom: 20.h,
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(bottom: 150.h),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Icon(
//                             Icons.arrow_back_rounded,
//                             size: 30.r,
//                             color: AppColors.whiteColor,
//                           ),
//                         ),
//                         CustomText(
//                           text: "Order Requests Detail",
//                           fontColor: AppColors.whiteColor,
//                           fontSize: 18.sp,
//                           weight: FontWeight.bold,
//                         ),
//                         SizedBox(width: 10.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20.h),
//               CustomText(
//                 text: "Customer",
//                 fontSize: 20.sp,
//                 weight: FontWeight.bold,
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 10.w),
//                     child: Container(
//                       width: 50.w,
//                       height: 50.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: AppColors.yellow2,
//                           width: 2.w,
//                         ),
//                         image: DecorationImage(
//                           image: AssetImage(AssetsPath.dummy),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                     child: CustomText(
//                       text: widget.vendorOrder?.user?.name ?? "John Smith",
//                       fontSize: 18.sp,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               CustomText(
//                 text: "Order Details",
//                 fontSize: 18.sp,
//                 weight: FontWeight.bold,
//                 fontColor: AppColors.blackColor,
//               ),
//               SizedBox(height: 10.h),

//               // Display each item from the order
//               if (widget.vendorOrder?.items != null &&
//                   widget.vendorOrder!.items!.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: widget.vendorOrder!.items!.map((item) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text:
//                               "Product: ${item.productName ?? 'Unknown Product'}",
//                           fontSize: 16.sp,
//                           fontColor: AppColors.blackColor,
//                         ),
//                         CustomText(
//                           text: "Qty: ${item.quantity ?? 0}",
//                           fontSize: 16.sp,
//                           fontColor: AppColors.blackColor,
//                         ),
//                         CustomText(
//                           text:
//                               "Price: \$${item.price?.toStringAsFixed(2) ?? '0.00'}",
//                           fontSize: 16.sp,
//                           fontColor: AppColors.blackColor,
//                         ),
//                         SizedBox(height: 12.h),
//                       ],
//                     );
//                   }).toList(),
//                 )
//               else
//                 CustomText(
//                   text: "No items in order",
//                   fontSize: 16.sp,
//                   fontColor: AppColors.blackColor,
//                 ),
//               CustomText(
//                 text: "Order Number: ${widget.vendorOrder?.sId ?? 'N/A'}",
//                 fontSize: 16.sp,
//                 fontColor: AppColors.blackColor,
//               ),
//               CustomText(
//                 text:
//                     "Placed on: ${_formatDate(widget.vendorOrder?.createdAt)}",
//                 fontSize: 16.sp,
//                 fontColor: AppColors.blackColor,
//               ),
//               SizedBox(height: 30.h),
//               CustomText(
//                 text: "Delivery Address",
//                 fontSize: 18.sp,
//                 weight: FontWeight.bold,
//                 fontColor: AppColors.blackColor,
//               ),
//               SizedBox(height: 10.h),
//               CustomText(
//                 text:

//                     // storeController.selectedVendorOrder.value?.deliveryAddress??"No address provided",

//                     widget.vendorOrder?.deliveryAddress ??
//                     (widget.vendorOrder?.user?.phoneNumber != null
//                         ? "Address: ${widget.vendorOrder!.user!.phoneNumber}"
//                         : "No address provided"),
//                 fontSize: 16.sp,
//                 fontColor: AppColors.blackColor,
//               ),
//               SizedBox(height: 20.h),
//               // Status action buttons for vendor orders
//               if (widget.vendorOrder != null)
//                 Column(
//                   children: [
//                     SizedBox(height: 10.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         if ((widget.vendorOrder?.status ?? '').toLowerCase() ==
//                             'pending')
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.yellow2,
//                               foregroundColor: AppColors.blackColor,
//                             ),
//                             onPressed: () async {
//                               await storeController.changeVendorOrderStatus(
//                                 widget.vendorOrder!.sId ?? '',
//                                 'accepted',
//                                 context,
//                               );
//                             },
//                             child: const Text('Accept'),
//                           ),
//                         if ((widget.vendorOrder?.status ?? '').toLowerCase() !=
//                             'completed')
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.yellow2,
//                               foregroundColor: AppColors.blackColor,
//                             ),
//                             onPressed: () async {
//                               await storeController.changeVendorOrderStatus(
//                                 widget.vendorOrder!.sId ?? '',
//                                 'completed',
//                                 context,
//                               );
//                             },
//                             child: Text(
//                               isCurrent ? 'Ready for Pickup' : 'Mark Complete',
//                             ),
//                           ),
//                         if ((widget.vendorOrder?.status ?? '').toLowerCase() !=
//                                 'cancelled' &&
//                             isCurrent)
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.yellow2,
//                               foregroundColor: AppColors.blackColor,
//                             ),
//                             onPressed: () async {
//                               await storeController.changeVendorOrderStatus(
//                                 widget.vendorOrder!.sId ?? '',
//                                 'cancelled',
//                                 context,
//                               );
//                             },
//                             child: const Text('Cancel'),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CustomText(
//                     text: "Delivery Charges",
//                     fontSize: 18.sp,
//                     weight: FontWeight.bold,
//                     fontColor: AppColors.blackColor,
//                   ),
//                   CustomText(
//                     text:
//                         "\$${widget.vendorOrder?.totalAmount != null ? ((widget.vendorOrder!.totalAmount! - 10).toStringAsFixed(2)) : '0.00'}",
//                     fontSize: 18.sp,
//                     fontColor: AppColors.blackColor,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CustomText(
//                     text: "Total Bill",
//                     fontSize: 18.sp,
//                     weight: FontWeight.bold,
//                     fontColor: AppColors.blackColor,
//                   ),
//                   CustomText(
//                     text:
//                         "\$${widget.vendorOrder?.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
//                     fontSize: 18.sp,
//                     fontColor: AppColors.yellow2,
//                   ),
//                 ],
//               ),

//               SizedBox(height: 60.h),

//               // === ORDER STATE LOGIC ===

//               // === ORDER STATE LOGIC ===

//               // 🟥 Cancelled Orders
//               if (widget.isCancelled) ...[
//                 CustomText(
//                   text: "Order Cancelled",
//                   fontSize: 18.sp,
//                   weight: FontWeight.bold,
//                   fontColor: AppColors.blackColor,
//                 ),
//                 SizedBox(height: 10.h),
//                 CustomText(
//                   text: "Cancellation Reason",
//                   fontSize: 16.sp,
//                   fontColor: AppColors.blackColor,
//                 ),
//                 SizedBox(height: 10.h),
//                 CustomText(
//                   text:
//                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Primis sem.",
//                   fontSize: 16.sp,
//                   textAlign: TextAlign.center,
//                   fontColor: AppColors.blackColor,
//                 ),
//               ]
//               // 🟨 Order Requests (Not Yet Accepted)
//               else if (!isAccepted && !isCurrent && !isComplete) ...[
//                 Padding(
//                   padding: EdgeInsets.only(top: 150.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       CustomButton(
//                         width: 160.w,
//                         text: "Reject",
//                         onTap: () => AppDialogs.showToast("Order Rejected!"),
//                         verticalPadding: 20.h,
//                         gradientColors: [
//                           AppColors.whiteColor,
//                           AppColors.whiteColor,
//                         ],
//                         borderColor: AppColors.blackColor,
//                       ),
//                       CustomButton(
//                         width: 160.w,
//                         text: "Accept",
//                         onTap: () {
//                           setState(() {
//                             isAccepted = true;
//                             isCurrent =
//                                 true; // ✅ Now this affects the condition below
//                             currentStep = 0;
//                             text = "Ready for Pickup";
//                           });
//                         },
//                         verticalPadding: 20.h,
//                         gradientColors: [AppColors.yellow1, AppColors.yellow2],
//                         borderColor: AppColors.blackColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ]
//               // 🟩 Current Orders (Active Step Flow)
//               else if (isCurrent) ...[
//                 HorizontalStepper(currentStep: currentStep, steps: steps),
//                 SizedBox(height: 20.h),
//                 CustomText(
//                   text: "Select Order Status",
//                   fontSize: 18.sp,
//                   weight: FontWeight.bold,
//                   fontColor: AppColors.yellow2,
//                 ),
//                 SizedBox(height: 20.h),
//                 CustomButton(
//                   text: text,
//                   onTap: () async {
//                     if (currentStep == 0) {
//                       final result = await showAddDeliveryPersonnelDialog(
//                         context,
//                       );
//                       if (result == true) {
//                         // Call API for "ready-for-pickup" with driver details
//                         await storeController.changeVendorOrderStatus(
//                           widget.vendorOrder!.sId ?? '',
//                           'ready-for-pickup',
//                           context,
//                           driverDetail: {
//                             "driverName":
//                                 "Muneer Ahmed", // This should come from the dialog
//                             "phoneNumber":
//                                 "03219205554", // This should come from the dialog
//                             "color":
//                                 "white", // This should come from the dialog
//                             "make":
//                                 "toyota", // This should come from the dialog
//                             "numberPlate":
//                                 "BDE-358", // This should come from the dialog
//                           },
//                         );
//                         setState(() {
//                           currentStep = 1;
//                           text = "Order Handed to Delivery Personnel";
//                         });
//                       }
//                     } else if (currentStep == 1) {
//                       // Call API for "dispatched"
//                       await storeController.changeVendorOrderStatus(
//                         widget.vendorOrder!.sId ?? '',
//                         'dispatched',
//                         context,
//                       );
//                       setState(() {
//                         currentStep = 2;
//                         text = "Order Completed";
//                       });
//                     } else if (currentStep == 2) {
//                       final confirmResult =
//                           await orderCompleteConfirmationDialog(context);
//                       if (confirmResult == true) {
//                         // Call API for "completed"
//                         await storeController.changeVendorOrderStatus(
//                           widget.vendorOrder!.sId ?? '',
//                           'completed',
//                           context,
//                         );
//                         setState(() {
//                           currentStep = 3;
//                           isComplete = true;
//                         });
//                         Future.delayed(
//                           Duration(seconds: 1),
//                           () => Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (_) => BaseView()),
//                           ),
//                         );
//                       }
//                     } else if (currentStep >= 3) {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (_) => BaseView()),
//                       );
//                     }
//                   },
//                 ),
//               ]
//               // 🟦 Completed Orders (Past Orders)
//               else if (isComplete) ...[
//                 HorizontalStepper(currentStep: steps.length, steps: steps),
//                 SizedBox(height: 20.h),
//                 Center(
//                   child: CustomText(
//                     text: "Order Completed",
//                     fontSize: 18.sp,
//                     fontColor: AppColors.blackColor,
//                     weight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
