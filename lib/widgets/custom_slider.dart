import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/slider_thumb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSliderWidget extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final String label;
  final String? unit; // e.g., "km", "$", "%", etc.
  final ValueChanged<double>? onChanged;
  final String Function(double value)? formatValue; // Optional custom formatter

  const CustomSliderWidget({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.label,
    this.unit,
    this.onChanged,
    this.formatValue,
  });

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  String _formatValue(double value) {
    if (widget.formatValue != null) return widget.formatValue!(value);
    if (widget.unit != null) return '${value.toStringAsFixed(2)} ${widget.unit}';
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final sliderWidth = MediaQuery.of(context).size.width - 85.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label (e.g., “Delivery Radius”)
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: CustomText(
            text: widget.label,
            fontFamily: "Raleway",
            weight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),

        /// Slider + moving value
        SizedBox(
          height: 60.h,
          width: double.infinity,
          child: Stack(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  thumbShape: GradientThumbShape(),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                  activeTrackColor: AppColors.blackColor.withValues(alpha: 0.2),
                  inactiveTrackColor:
                      AppColors.blackColor.withValues(alpha: 0.2),
                  thumbColor: Colors.transparent,
                  overlayColor: AppColors.yellow1.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: currentValue,
                  min: widget.min,
                  max: widget.max,
                  onChanged: (value) {
                    setState(() => currentValue = value);
                    widget.onChanged?.call(value);
                  },
                ),
              ),
              Positioned(
                left: ((currentValue - widget.min) /
                        (widget.max - widget.min))
                    .clamp(0.0, 1.0) *
                    sliderWidth,
                top: 45.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: CustomText(
                    text: _formatValue(currentValue),
                    fontSize: 12.sp,
                    weight: FontWeight.bold,
                    fontColor: AppColors.yellow2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
