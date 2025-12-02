// orders_list_screen.dart

import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/live_tracking.dart';
import 'package:bee_kind/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrdersListScreen extends StatelessWidget {
  OrdersListScreen({super.key});

  final StoreController controller = Get.find<StoreController>();

  @override
  Widget build(BuildContext context) {
    // Fetch orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrdersByStatus("pending");
    });

    return Obx(() {
      if (controller.isFetchingOrders.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        );
      }

      if (controller.ordersList.isEmpty) {
        return Center(
          child: Text(
            "No orders available",
            style: TextStyle(fontSize: 18.sp, color: Colors.grey),
          ),
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: controller.ordersList.length,
          itemBuilder: (_, index) {
            final order = controller.ordersList[index];

            // Safely extract first product
            final firstItem = order.items != null && order.items!.isNotEmpty
                ? order.items!.first
                : null;

            return GestureDetector(
              onTap: () {}, // If you want whole tile tap as well
              child: OrderItem(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveTracking(orderId: order.sId ?? ""),
                  ),
                ),

                /// Pass real data to OrderItem
                productName: firstItem?.productName,
                quantity: firstItem?.quantity,
                price: firstItem?.price,
                status: order.status,
                imageUrl: firstItem?.productImage,
              ),
            );
          },
        ),
      );
    });
  }
}
