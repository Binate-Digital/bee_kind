import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/vendor/store/selected_past_product.dart';
import 'package:bee_kind/widgets/past_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:get/get.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedIndex = 1; // 0 = Current, 1 = Past
  final storeController = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    // Fetch current (accepted) orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeController.fetchVendorOrders(status: 'accepted', context: context);
      // Also fetch completed orders for Past tab
      _fetchPastOrders();
    });
  }

  Future<void> _fetchPastOrders() async {
    // Fetch completed orders
    await storeController.fetchVendorOrders(
      status: 'completed',
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          // === Custom Tabs ===
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: AppColors.yellow2, width: 1.5),
            ),
            child: Row(
              children: [
                _buildTabButton("Current", 0),
                _buildTabButton("Past", 1),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // === Tab Content ===
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [_buildCurrentOrders(), _buildPastOrders()],
            ),
          ),
        ],
      ),
    );
  }

  /// === Custom Tab Button ===
  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellow2 : Colors.white,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 18.sp,
              fontColor: Colors.black,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// === Current Orders Tab ===
  Widget _buildCurrentOrders() {
    return Obx(() {
      if (storeController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (storeController.vendorOrders.isEmpty) {
        return Center(
          child: CustomText(text: 'No current orders', fontSize: 16.sp),
        );
      }

      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: storeController.vendorOrders.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final order = storeController.vendorOrders[index];
          return GestureDetector(
            onTap: () async {
              // Fetch full order details (use sId which is the MongoDB ID)
              await storeController.fetchVendorOrder(order.sId ?? '', context);
              // Navigate to details screen with the fetched order
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectedOrder(
                    vendorOrder: storeController.selectedVendorOrder.value,
                    isCurrent: true,
                    isAccepted: true,
                  ),
                ),
              );
            },
            child: PastProducts(isCurrent: true, vendorOrder: order),
          );
        },
      );
    });
  }

  /// === Past Orders Tab ===
  Widget _buildPastOrders() {
    return Obx(() {
      if (storeController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      // Filter completed and cancelled orders
      final pastOrders = storeController.vendorOrders
          .where(
            (order) =>
                (order.status?.toLowerCase() == 'completed') ||
                (order.status?.toLowerCase() == 'cancelled'),
          )
          .toList();

      if (pastOrders.isEmpty) {
        return Center(
          child: CustomText(text: 'No past orders', fontSize: 16.sp),
        );
      }

      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: pastOrders.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final order = pastOrders[index];
          final isCancelled = order.status?.toLowerCase() == 'cancelled';
          return GestureDetector(
            onTap: () async {
              // Fetch full order details
              if (order.sId != null) {
                await storeController.fetchVendorOrder(order.sId!, context);
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectedOrder(
                      vendorOrder: storeController.selectedVendorOrder.value,
                      isComplete: true,
                      isCancelled: isCancelled,
                      isCurrent: false,
                      isAccepted: true,
                    ),
                  ),
                );
              }
            },
            child: PastProducts(isCancelled: isCancelled, vendorOrder: order),
          );
        },
      );
    });
  }
}
