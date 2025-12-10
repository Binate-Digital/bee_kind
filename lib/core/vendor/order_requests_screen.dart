import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/widgets/order_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';

class OrderRequestsScreen extends StatefulWidget {
  const OrderRequestsScreen({super.key});

  @override
  State<OrderRequestsScreen> createState() => _OrderRequestsScreenState();
}

class _OrderRequestsScreenState extends State<OrderRequestsScreen> {
  final storeController = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    // Fetch pending orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeController.fetchPendingOrders(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator
      if (storeController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.yellow2),
        );
      }

      // Show empty state if no pending orders
      if (storeController.pendingOrders.isEmpty) {
        return Center(
          child: CustomText(
            text: 'No pending orders',
            fontSize: 16.sp,
            fontColor: AppColors.blackColor,
          ),
        );
      }

      // Display pending orders list
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: storeController.pendingOrders.length,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (context, index) {
          final order = storeController.pendingOrders[index];
          return GestureDetector(
            // onTap: () async {
            //   // Fetch full order details using the pending order's sId
            //   if (order.sId != null) {
            //     await storeController.fetchVendorOrder(order.sId!, context);
            //     // Navigate to details screen with the fetched order
            //     if (!context.mounted) return;
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => SelectedOrder(
            //           vendorOrder: storeController.selectedVendorOrder.value,
            //           isCurrent: true,
            //           isAccepted: false, // pending orders are not accepted yet
            //         ),
            //       ),
            //     );
            //   }
            // },
            child: OrderRequest(
              order: order,
              onAccept: () async {
                // Accept the pending order
                if (order.sId != null) {
                  await storeController.changeVendorOrderStatus(
                    order.sId!,
                    'accepted',
                    context,
                  );
                  // Refresh pending orders after status change
                  await storeController.fetchPendingOrders(context: context);
                }
              },
              onReject: () async {
                // Reject (cancel) the pending order
                if (order.sId != null) {
                  await storeController.changeVendorOrderStatus(
                    order.sId!,
                    'cancelled',
                    context,
                  );
                  // Refresh pending orders after status change
                  await storeController.fetchPendingOrders(context: context);
                }
              },
            ),
          );
        },
      );
    });
  }
}
