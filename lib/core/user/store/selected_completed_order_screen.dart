import 'dart:developer';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/checkout.dart';
import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/models/data_models/create_order_data_model.dart';
import 'package:bee_kind/models/response_models/single_order_response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/widgets/completed_order_item.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SelectedCompletedOrderScreen extends StatefulWidget {
  const SelectedCompletedOrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<SelectedCompletedOrderScreen> createState() =>
      _SelectedCompletedOrderScreenState();
}

class _SelectedCompletedOrderScreenState
    extends State<SelectedCompletedOrderScreen> {
  double rating = 3.5;
  bool isLoading = true;
  String? errorMessage;
  Order? _order;
  final TextEditingController _reviewController = TextEditingController();

  final network = Network();
  final storeController = Get.find<StoreController>();

  final List<String> _steps = [
    AssetsPath.box,
    AssetsPath.truck,
    AssetsPath.carry,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchOrderDetails();
    });
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getSingleOrder}/${widget.orderId}",
        isHeaderRequire: true,
      );

      if (response == null) {
        setState(() {
          isLoading = false;
          errorMessage = "Unable to fetch order details.";
        });
        return;
      }

      final model = SingleOrderResponseModel.fromJson(response.data);

      if (model.status != true || model.data?.order == null) {
        setState(() {
          isLoading = false;
          errorMessage = model.message ?? "Order not found.";
        });
        return;
      }

      setState(() {
        _order = model.data!.order!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_order?.items != null && _order!.items!.isNotEmpty) {
            setState(() {
              selectedProductId = _order!.items!.first.productId;
            });
          }
        });
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

  /// Calculate step index based on order status
  int _stepFromStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 1; // Pending orders show at "Ready for Pickup" step
      case 'accepted':
      case 'ready for pickup':
      case 'ready_for_pickup':
        return 1;
      case 'dispatched':
      case 'shipped':
      case 'out for delivery':
        return 2;
      case 'delivered':
      case 'completed':
        return 3;
      default:
        return 1; // Default to "Ready for Pickup" step
    }
  }

  /// Check if order is completed (show buttons only for completed)
  bool get _isCompletedOrder {
    return _order?.status?.toLowerCase() == 'completed';
  }

  /// Get product ID from order items (assuming first item for now)
  String? get _firstProductId {
    if (_order?.items?.isNotEmpty == true) {
      return _order!.items!.first.productId;
    }
    return null;
  }

  /// Submit review using API
  Future<void> _submitReview() async {
    if (!_isCompletedOrder) {
      AppDialogs.showToast("Reviews can only be added to completed orders");
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      AppDialogs.showToast("Please write a review");
      return;
    }

    if (_firstProductId == null) {
      AppDialogs.showToast("Product ID not found");
      return;
    }

    try {
      final success = await storeController.addReview(
        orderId: widget.orderId,
        // productId: _firstProductId!,
        productId: selectedProductId!,
        rating: rating.toInt(),
        review: _reviewController.text.trim(),
        context: context,
      );

      if (success) {
        Navigator.pop(context); // Close bottom sheet
        _reviewController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectedProduct(
              productId: selectedProductId,
              // productName: p?.productName,
              // ingredients: p?.ingredients,
              // description: p?.description,
              // effets: p?.effects,
              // price: p?.price,
              // afterDiscountPrice: p?.afterDiscountPrice,
              // inventoryStatus: p?.inventoryStatus,
              // hasDiscount:
              // p?.isDiscountAvailable ?? false,
              // isAvailable: p?.isAvailable ?? false,
              // quantity: p?.quantity,
            ),
          ),
        );
        setState(() {
          rating = 3.5;
        });
      }
    } catch (e) {
      log("Error submitting review: $e");
      AppDialogs.showToast("Failed to submit review");
    }
  }

  /// Handle re-order functionality
  Future<void> _handleReOrder(BuildContext context) async {
    if (_order == null || _order!.items == null || _order!.items!.isEmpty) {
      AppDialogs.showToast("No items found to re-order");
      return;
    }

    final prefs = SharedPrefs();

    try {
      // Show loading
      AppDialogs.progressAlertDialog(context: context);

      // Clear existing cart
      storeController.orderItems?.clear();
      await storeController.saveCartToPrefs(prefs.getUserId().toString());

      // Set store ID for the re-order
      prefs.setString("storeId", _order!.storeId ?? "");

      // Convert order items to cart items and add to cart
      for (final item in _order!.items!) {
        final cartItem = OrderItem(
          productId: item.productId,
          productName: item.productName,
          quantity: item.quantity,
          unitPrice: ((item.price ?? 0) * (item.quantity ?? 1)).toDouble(), // Total price for the quantity
          productImage: item.productImage,
        );

        await storeController.addItems(cartItem);
      }

      // Pre-select the address from the original order if available
      if (_order!.userAddress != null) {
        // Try to find matching address in user's saved addresses
        final userAddresses = storeController.userAddresses.value?.data;
        if (userAddresses != null) {
          final matchingAddressIndex = userAddresses.indexWhere(
            (addr) => addr.address == _order!.userAddress!.address,
          );

          if (matchingAddressIndex != -1) {
            storeController.selectAddress(matchingAddressIndex);
          }
        }
      }

      // Set additional notes from original order
      if (_order!.additionalNotes != null) {
        storeController.notesController.text = _order!.additionalNotes.toString();
      }

      // Close loading dialog
      Navigator.pop(context);

      // Navigate to checkout
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CheckoutScreen()),
      );

      AppDialogs.showToast("Items added to cart successfully");
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      log("Re-order error: $e");
      AppDialogs.showToast("Failed to re-order items");
    }
  }


String? selectedProductId;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Completed Order")),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    if (errorMessage != null || _order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Completed Order")),
        body: Center(
          child: Text(errorMessage ?? "Order not found"),
        ),
      );
    }

    final order = _order!;
    final firstItem = order.items?.isNotEmpty == true ? order.items!.first : null;
    final formattedDate = order.createdAt != null
        ? DateFormat("dd-MM-yyyy").format(DateTime.parse(order.createdAt!))
        : "--";
    final currentStep = _stepFromStatus(order.status);

    return AppBarBaseView(
      title: "Completed Order",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Only show Re-Order button for completed orders
            if (_isCompletedOrder)
              CustomButton(
                onTap: () => _handleReOrder(context),
                text: "Re-Order",
                gradientColors: [AppColors.whiteColor, AppColors.whiteColor],
              ),
            if (_isCompletedOrder) SizedBox(height: 20.h),
            
            // Only show Leave a Review button for completed orders
            if (_isCompletedOrder)
              CustomButton(
                onTap: () {
                  showModalBottomSheet(
                    isDismissible: true,
                    isScrollControlled: true,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 30.h,
                              bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
                              left: 20.w,
                              right: 20.w,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  text: "How is your order?",
                                  weight: FontWeight.w600,
                                  fontSize: 22.sp,
                                ),
                                SizedBox(height: 20.h),
                                CustomText(
                                  text: "Please give your rating & also your review...",
                                  fontSize: 18.sp,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 20.h,
                                    bottom: 10.h,
                                  ),
                                  child: StarRating(
                                    size: 40.r,
                                    rating: rating,
                                    color: AppColors.yellow2,
                                    borderColor: Colors.grey,
                                    allowHalfRating: true,
                                    starCount: 5,
                                    onRatingChanged: (rate) => setModalState(() {
                                      rating = rate;
                                    }),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: CustomTextField(
                                    controller: _reviewController,
                                    hint: "Write a Review",
                                    radius: 10.r,
                                    maxlines: 6,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                CustomButton(
                                  onTap: _submitReview,
                                  text: "Submit",
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                text: "Leave a Review",
              ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _order?.items?.length ?? 0,
            itemBuilder: (context, index) {
              final item = _order!.items![index];
              final bool isSelected = selectedProductId == item!.productId;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedProductId = item.productId; // assign selected product id
                  });


                },
                child: Container(
                  // margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.yellow1   // selected border color
                          : Colors.transparent,      // default
                      width: 2,
                    ),
                  ),
                  child: CompletedOrderItem(
                    hideDate: true,
                    productName: item.productName,
                    quantity: item.quantity,
                    price: double.tryParse("${item.price ?? 0}"),
                    status: order.status,
                    imageUrl: item.productImage,
                  ),
                ),
              );
            },
          ),

            SizedBox(height: 20.h),
              HorizontalStepper(
                currentStep: currentStep,
                steps: _steps,
                activeColor: AppColors.blackColor,
                inactiveColor: _isCompletedOrder ? AppColors.whiteColor : Colors.grey,
              ),
              SizedBox(height: 10.h),
              // Status labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusLabel("Ready", currentStep >= 1),
                  _statusLabel("Dispatched", currentStep >= 2),
                  _statusLabel("Delivered", currentStep >= 3),
                ],
              ),
              SizedBox(height: 20.h),
              Container(color: AppColors.blackColor, height: 0.5.w),
              SizedBox(height: 20.h),
              CustomText(
                text: "Order Details",
                weight: FontWeight.bold,
                fontSize: 22.sp,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: "Order ID: ${order.sId ?? '--'}",
                fontSize: 18.sp,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: "Status: ${order.status ?? '--'}",
                fontSize: 18.sp,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: "Placed On: $formattedDate",
                fontSize: 18.sp,
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: "Delivery Address",
                weight: FontWeight.bold,
                fontSize: 22.sp,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: order.userAddress?.address ?? "Address not available",
                fontSize: 18.sp,
              ),
              if (order.userAddress?.floorNumber != null ||
                  order.userAddress?.apartmentNumber != null) ...[
                SizedBox(height: 5.h),
                CustomText(
                  text:
                      "Floor: ${order.userAddress?.floorNumber ?? '--'}, Apt: ${order.userAddress?.apartmentNumber ?? '--'}",
                  fontSize: 16.sp,
                ),
              ],
              if (order.storeAddress != null) ...[
                SizedBox(height: 20.h),
                CustomText(
                  text: "Store Address",
                  weight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: order.storeAddress?.address ?? "Store address not available",
                  fontSize: 18.sp,
                ),
              ],
              SizedBox(height: 20.h),
              CustomText(
                text: "Additional Notes",
                weight: FontWeight.bold,
                fontSize: 22.sp,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: order.additionalNotes?.toString() ?? "No additional notes",
                maxLines: 3,
                textAlign: TextAlign.start,
                fontSize: 18.sp,
              ),
              SizedBox(height: 20.h),
              Container(color: AppColors.blackColor, height: 0.5.w),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Delivery Charges",
                    weight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                  CustomText(
                    text: "\$${order.deliverCharges ?? 0}",
                    fontSize: 18.sp,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Total Bill",
                    weight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),
                  CustomText(
                    text: "\$${order.totalAmount ?? 0}",
                    fontSize: 20.sp,
                    fontColor: AppColors.yellow2,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 200.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusLabel(String text, bool isActive) {
    return CustomText(
      text: text,
      fontSize: 12.sp,
      fontColor: isActive ? AppColors.blackColor : Colors.grey,
      weight: isActive ? FontWeight.bold : FontWeight.normal,
    );
  }
}
