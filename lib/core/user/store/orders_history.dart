import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/selected_completed_order_screen.dart';
import 'package:bee_kind/widgets/completed_order_item.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();

    // Load completed and cancelled orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompletedAndCancelledOrders();
    });

    return AppBarBaseView(
      title: "Orders History",
      body: Obx(() {
        if (controller.isFetchingOrders.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        if (controller.ordersList.isEmpty) {
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
          itemCount: controller.ordersList.length,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            final order = controller.ordersList[index];
            final firstItem = order.items?.isNotEmpty == true
                ? order.items!.first
                : null;

            print("controller.ordersList.length");
            print(controller.ordersList.length);
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
                productName: firstItem?.productName,
                quantity: firstItem?.quantity,
                price: double.tryParse("${controller.ordersList[index].totalAmount ?? 0}"),
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
