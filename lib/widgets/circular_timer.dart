import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularTimer extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final String formattedTime;
  final double progress;

  const CircularTimer({
    super.key,
    this.size = 80.0,
    this.strokeWidth = 6.0,
    this.formattedTime = "",
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle
        Container(
          width: size.w,
          height: size.h,
          decoration: BoxDecoration(
            color: AppColors.yellow1.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),

        // Progress circle
        SizedBox(
          width: size.w,
          height: size.h,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, _) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth.w,
                backgroundColor: AppColors.yellow1.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.yellow2,
                ),
              );
            },
          ),
        ),

        // Time text
        CustomText(
          text: formattedTime,
          fontSize: 22.sp,
          underlined: false,
          fontColor: AppColors.yellow2,
        ),
      ],
    );
  }
}
