import 'package:bee_kind/core/user/store/live_tracking.dart';
import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/models/response_models/notification_model.dart';
import 'package:bee_kind/services/notification_navigation_service.dart';
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
    final routeData = NotificationNavigationService.fromNotificationItem(
      notification,
      isVendor: controller.isVendor.value,
    );

    print("Notifications====${routeData.target}");

    switch (routeData.target) {
      case NotificationTarget.product:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectedProduct(
              productId: routeData.productId,
              isVendor: controller.isVendor.value,
            ),
          ),
        );
        break;
      case NotificationTarget.vendorMyProducts:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectedProduct(
              productId: routeData.productId,
              isVendor: true,
            ),
          ),
        );
        break;
      case NotificationTarget.orderTracking:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveTracking(orderId: routeData.orderId!),
          ),
        );
        break;

      case NotificationTarget.orderRequestsTab:
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
      case NotificationTarget.none:
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
