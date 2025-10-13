// Custom thumb shape with gradient
import 'package:bee_kind/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(24.w, 24.h);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final thumbRect = Rect.fromCircle(center: center, radius: 12.w);

    // Create gradient
    final gradient = LinearGradient(
      colors: [AppColors.yellow1, AppColors.yellow2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Create shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    // Draw shadow
    canvas.drawCircle(center, 12.w, shadowPaint);

    // Draw thumb with gradient
    final thumbPaint = Paint()
      ..shader = gradient.createShader(thumbRect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 12.w, thumbPaint);

    // Optional: Add a white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.w;

    canvas.drawCircle(center, 12.w, borderPaint);
  }
}