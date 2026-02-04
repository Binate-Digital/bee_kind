import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/selected_completed_order_screen.dart';
import 'package:bee_kind/widgets/completed_order_item.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  final controller = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    // Load completed and cancelled orders once when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompletedAndCancelledOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Orders History",
      body: Obx(() {
        if (controller.isFetchingOrders.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        if (controller.completedOrdersList.isEmpty) {
          return Center(
            child: Text(
              "No orders found",
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: controller.completedOrdersList.length,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            final order = controller.completedOrdersList[index];
            final firstItem = order.items?.isNotEmpty == true
                ? order.items!.first
                : null;

            // Calculate total items count in order
            final totalItemsCount =
                order.items?.fold<int>(
                  0,
                  (sum, item) => sum + (item.quantity ?? 1),
                ) ??
                0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SelectedCompletedOrderScreen(orderId: order.sId ?? ""),
                  ),
                );
              },
              child: CompletedOrderItem(
                hideDate: false,

                // ---- Pass API Data Here ----
                productName: order.items != null && order.items!.length > 1
                    ? "${order.items!.length} Products"
                    : firstItem?.productName,
                quantity: totalItemsCount,
                // Compute price client-side to avoid relying on backend totalAmount
                price: () {
                  final items = order.items ?? [];
                  double itemsTotal = 0.0;
                  for (final it in items) {
                    final double price = (it.price ?? 0).toDouble();
                    final int qty = it.quantity ?? 0;
                    itemsTotal += price * qty;
                  }
                  final double delivery = (order.deliverCharges ?? 0.0);
                  return itemsTotal + delivery;
                }(),
                status: order.status,
                imageUrl: firstItem?.productImage,

                // Format date safely
                date: order.createdAt != null
                    ? DateFormat(
                        "dd-MM-yyyy",
                      ).format(DateTime.parse(order.createdAt!))
                    : "--",
              ),
            );
          },
        );
      }),
    );
  }
}
