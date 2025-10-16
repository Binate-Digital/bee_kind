import 'package:bee_kind/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalStepper extends StatefulWidget {
  final int currentStep;
  final List<String> steps;
  final Color activeColor;
  final Color inactiveColor;

  const HorizontalStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.activeColor = AppColors.blackColor,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<HorizontalStepper> createState() => _HorizontalStepperState();
}

class _HorizontalStepperState extends State<HorizontalStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          // Step indicators and connectors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.steps.length, (index) {
              return Center(
                child: Image.asset(
                  widget.steps[index],
                  width: 30.w,
                  height: 30.h,
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),
          // Ticks and connectors row
          Stack(
            children: [
              // Dotted connectors
              Positioned.fill(
                left: 16.w,
                child: Row(
                  children: List.generate(widget.steps.length - 1, (index) {
                    final isCompleted = index < widget.currentStep;
                    return Container(
                      width: 70.w,
                      margin: EdgeInsets.symmetric(horizontal: 18.w),
                      child: HorizontalDottedLine(
                        color: isCompleted
                            ? widget.activeColor
                            : widget.inactiveColor,
                        strokeWidth: 2,
                        dashWidth: 5,
                        dashSpace: 3,
                      ),
                    );
                  }),
                ),
              ),
              // Ticks row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(widget.steps.length, (index) {
                  final isActive = index <= widget.currentStep;
                  final isCompleted = index <= widget.currentStep;
                  return _buildStepCircle(index, isActive, isCompleted);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index, bool isActive, bool isCompleted) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: isCompleted
            ? widget.activeColor
            : (isActive ? widget.activeColor : widget.inactiveColor),
        border: Border.all(
          color: isActive ? widget.activeColor : widget.inactiveColor,
          width: 2.w,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: 
        isCompleted
            ? Icon(Icons.check, size: 18.w, color: AppColors.whiteColor)
            : Icon(Icons.check, size: 18.w, color: widget.inactiveColor),
      ),
    );
  }
}

class HorizontalDottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double? width;
  final bool roundedDots;

  const HorizontalDottedLine({
    super.key,
    this.height = 1,
    this.color = AppColors.blackColor,
    this.strokeWidth = 1,
    this.dashWidth = 3,
    this.dashSpace = 3,
    this.width,
    this.roundedDots = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final finalWidth = width ?? constraints.maxWidth;
        final boxCount = (finalWidth / (dashWidth + dashSpace)).floor();

        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(boxCount, (_) {
            return Container(
              width: dashWidth,
              height: strokeWidth,
              decoration: BoxDecoration(
                color: color,
                borderRadius: roundedDots
                    ? BorderRadius.circular(strokeWidth / 2)
                    : null,
              ),
            );
          }),
        );
      },
    );
  }
}
