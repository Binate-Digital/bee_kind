import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/notifications_widget.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Notifications",
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            NotificationsWidget(),
            NotificationsWidget(),
            NotificationsWidget(),
            NotificationsWidget(),
            NotificationsWidget(),
            NotificationsWidget(),
            NotificationsWidget(),
            NotificationsWidget(),
            NotificationsWidget(),
          ],
        ),
      ),
      appBarColor: AppColors.whiteColor,
    );
  }
}
