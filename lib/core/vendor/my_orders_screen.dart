import 'package:bee_kind/core/vendor/store/selected_past_product.dart';
import 'package:bee_kind/widgets/past_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedIndex = 0; // 0 = Current, 1 = Past

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
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SelectedOrder(isCancelled: false, isCurrent: true),
              ),
            );
          },
          child: PastProducts(isCurrent: true),
        );
      },
    );
  }

  /// === Past Orders Tab ===
  Widget _buildPastOrders() {
    List<bool> cancelled = [true, false, true, false, true];
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: cancelled.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SelectedOrder(isCancelled: cancelled[index], isCurrent: false),
              ),
            );
          },
          child: PastProducts(isCancelled: cancelled[index]),
        );
      },
    );
  }
}
