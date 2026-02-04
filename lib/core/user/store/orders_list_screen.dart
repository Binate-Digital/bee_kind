// orders_list_screen.dart

import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/live_tracking.dart';
import 'package:bee_kind/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  final StoreController controller = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    // Fetch orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrdersByStatus("pending");
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            ListView.builder(
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

                // Calculate total items count in order
                final totalItemsCount =
                    order.items?.fold<int>(
                      0,
                      (sum, item) => sum + (item.quantity ?? 1),
                    ) ??
                    0;

                // Compute itemized total (items * price) + delivery to ensure
                // displayed amount matches the itemized values.
                final double itemsTotal = (order.items ?? []).fold(0.0, (
                  sum,
                  item,
                ) {
                  final double price = (item.price ?? 0).toDouble();
                  final int qty = item.quantity ?? 0;
                  return sum + (price * qty);
                });

                final double delivery = (order.deliverCharges ?? 0.0);
                final double computedTotal = itemsTotal + delivery;

                // Log backend vs computed totals for diagnostics
                // ignore: avoid_print
                print(
                  'Order ${order.sId} backend total: ${order.totalAmount} computed: $computedTotal',
                );

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
                    productName: order.items != null && order.items!.length > 1
                        ? "${order.items!.length} Products"
                        : firstItem?.productName,
                    quantity: totalItemsCount,
                    price: computedTotal,
                    status: order.status,
                    imageUrl: firstItem?.productImage,
                    hideButton: order.status == "cancelled" ? true : false,
                  ),
                );
              },
            ),
            110.verticalSpace,
          ],
        ),
      );
    });
  }
}
