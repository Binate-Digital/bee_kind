import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_fonts.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String? text, fontFamily;
  final bool showIcon;
  final double? fontSize,
      width,
      verticalPadding,
      borderCircular,
      horizontalPadding,
      iconSize;
  final Color? textColor, backgroundColor, borderColor;
  final String? Function(bool)? onChanged;
  final void Function()? onTap;
  final List<Color> gradientColors;

  const CustomButton({
    required this.onTap,
    required this.text,
    this.verticalPadding,
    this.iconSize,
    this.showIcon = false,
    this.borderCircular,
    this.backgroundColor,
    this.width,
    this.fontFamily,
    this.fontSize,
    this.borderColor,
    this.onChanged,
    this.gradientColors = const [AppColors.yellow1, AppColors.yellow2],
    this.textColor,
    this.horizontalPadding,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(borderCircular ?? 30.r),
          ),
          border: Border.all(color: AppColors.blackColor, width: 1.w),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 20.h,
            horizontal: horizontalPadding ?? 30.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: text,
                weight: FontWeight.bold,
                fontColor: textColor ?? AppColors.blackColor,
                fontSize: fontSize ?? 16.sp,
                fontFamily: fontFamily ?? AppFonts.ralewayBold,
              ),
              if (showIcon) ...[
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
