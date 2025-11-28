import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_fonts.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String? text, fontFamily;
  final bool showIcon;
  final bool isLoading;
  final double? fontSize,
      width,
      height,
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
    this.isLoading = false,
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
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 60.h, // <-- FIXED HEIGHT
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(borderCircular ?? 30.r),
          border: Border.all(
            color: borderColor ?? AppColors.blackColor,
            width: 1.w,
          ),
        ),

        child: SizedBox.expand(
          // <-- KEY FIX: keeps height & layout identical
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.whiteColor,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding ?? 20.h,
                      horizontal: horizontalPadding ?? 30.w,
                    ),
                    child: CustomText(
                      text: text,
                      weight: FontWeight.bold,
                      fontColor: textColor ?? AppColors.blackColor,
                      fontSize: fontSize ?? 16.sp,
                      fontFamily: fontFamily ?? AppFonts.ralewayBold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
