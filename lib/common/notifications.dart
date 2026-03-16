import 'package:bee_kind/core/user/store/live_tracking.dart';
import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/models/response_models/notification_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/notifications_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controllers/base_view_controller.dart';
import 'base_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _handleNotificationTap(
    BuildContext context,
    NotificationItem notification,
    BaseViewController controller,
  ) {
    final type = notification.type?.trim().toLowerCase();

    switch (type) {
      case 'review-reply-added':
        final productId = notification.metadata?.productId;
        if (productId != null && productId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectedProduct(productId: productId),
            ),
          );
        }
        break;
      case 'new-product':
        final productId = notification.metadata?.productId;
        if (productId != null && productId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectedProduct(productId: productId),
            ),
          );
        }
        break;
      case 'discount-added':
        final productId = notification.metadata?.productId;
        if (productId != null && productId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectedProduct(productId: productId),
            ),
          );
        }
        break;
      case 'order-status-updated':
        final orderId = notification.metadata?.orderId;
        if (orderId != null && orderId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LiveTracking(orderId: orderId)),
          );
        }
        break;

      case 'new-order-accepted':
        final orderId = notification.metadata?.orderId;
        if (orderId != null && orderId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LiveTracking(orderId: orderId)),
          );
        }
        break;

      case 'new-order':
        controller.changeTab(1);
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BaseView(initialIndex: 1)),
          );
        }
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Notifications",
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GetBuilder<BaseViewController>(
              builder: (controller) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.notifications.value?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    String getDateOnly(String? dateTime) {
                      if (dateTime == null || dateTime.isEmpty) return "";
                      return dateTime.split('T').first;
                    }

                    final notification =
                        controller.notifications.value?.data?[index];

                    if (notification == null) {
                      return const SizedBox.shrink();
                    }

                    return NotificationsWidget(
                      message: notification.message,
                      title: notification.type,
                      time: getDateOnly(notification.createdAt),
                      onTap: () =>
                          _handleNotificationTap(context, notification, controller),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBarColor: AppColors.whiteColor,
    );
  }
}
