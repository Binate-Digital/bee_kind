import 'package:bee_kind/core/user/store/live_tracking.dart';
import 'package:bee_kind/widgets/cancel_order_dialog.dart';
import 'package:bee_kind/widgets/order_item.dart';
import 'package:bee_kind/widgets/track_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TrackOrderScreen(onTap: () => cancelOrderDialog(context), isTracking: true),
              ),
            ),
            child: OrderItem(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrackOrderScreen(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LiveTracking()),
                      );
                    },
                    isTracking: false,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
