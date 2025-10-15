import 'package:bee_kind/core/user/store/selected_completed_order_screen.dart';
import 'package:bee_kind/widgets/completed_order_item.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "orders History",
      body: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SelectedCompletedOrderScreen()),
            ),
            child: CompletedOrderItem(),
          );
        },
      ),
    );
  }
}
