import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';

class SalesInfo extends StatelessWidget {
  final Color? backgroundColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final String? heading;
  final String? text;
  final Widget? child;

  const SalesInfo({
    super.key,
    this.heading,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      height: 180.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      
        children: [
          child ??
              CustomText(
                text: heading ?? "",
                textAlign: TextAlign.center,
                fontSize: 18.sp,
                fontColor: AppColors.blackColor,
              ),
          SizedBox(height: 10.h),
          CustomText(
            text: text ?? "",
            textAlign: TextAlign.center,
            fontSize: 18.sp,
            fontColor: AppColors.yellow2,
          ),
        ],
      ),
    );
  }
}
