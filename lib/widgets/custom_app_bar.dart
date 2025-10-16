import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarBaseView extends StatelessWidget {
  const AppBarBaseView({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.color,
    this.appBarColor,
    this.button,
    this.extendedWidget,
    this.isExtended = false,
    this.isLeading = true,
  });

  final String title;
  final Widget body;
  final Widget? button;
  final List<Widget>? actions;
  final Color? color;
  final Color? appBarColor;
  final Widget? extendedWidget;
  final bool isExtended;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color ?? AppColors.whiteColor,
      floatingActionButton: button ?? Offstage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, isExtended ? 170.h : 70.h),
        child: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          leading: isLeading
              ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.blackColor,
                    size: 30,
                  ),
                )
              : Offstage(),
          actions: actions,
          flexibleSpace: extendedWidget ?? Offstage(),
          title: CustomText(
            text: title,
            fontSize: 22.sp,
            weight: FontWeight.bold,
            fontColor: AppColors.blackColor,
          ),
          centerTitle: true,
        ),
      ),
      body: body,
    );
  }
}
