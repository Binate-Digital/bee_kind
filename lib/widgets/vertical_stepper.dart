import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalStepper extends StatefulWidget {
  final int currentStep;
  final List<String> progressSteps;
  final List<String> locationSteps;
  final List<String> timeSteps;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const VerticalStepper({
    super.key,
    required this.currentStep,
    required this.progressSteps,
    required this.locationSteps,
    required this.timeSteps,
    this.activeColor = AppColors.blackColor,
    this.inactiveColor = Colors.grey,
    this.activeTextColor = AppColors.whiteColor,
    this.inactiveTextColor = Colors.grey,
  });

  @override
  State<VerticalStepper> createState() => _VerticalStepperState();
}

class _VerticalStepperState extends State<VerticalStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: List.generate(widget.progressSteps.length, (index) {
          final isActive = index <= widget.currentStep;
          final isCompleted = index < widget.currentStep;
          final isLastStep = index == widget.progressSteps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator column
              Column(
                children: [
                  // Step circle with inner circle (radio button style)
                  _buildStepCircle(index, isActive, isCompleted),
                  // Vertical dotted line (except for last step)
                  if (!isLastStep) _buildVerticalConnector(isCompleted),
                ],
              ),
              SizedBox(width: 16.w),
              // Step content - Always show all steps, but style based on active state
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress text
                        CustomText(
                          text: widget.progressSteps[index],
                          fontSize: 18.sp,
                          weight: isActive ? FontWeight.w600 : FontWeight.w400,
                          fontColor: isActive
                              ? widget.activeColor
                              : widget.inactiveColor,
                        ),
                        SizedBox(height: 4.h),
                        // Location text
                        SizedBox(
                          width: 230.w,
                          child: CustomText(
                            text: widget.locationSteps[index],
                            fontSize: 16.sp,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            weight: FontWeight.w400,
                            fontColor: isActive
                                ? widget.activeColor
                                : widget.inactiveColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CustomText(
                          text: widget.timeSteps[index],
                          fontSize: 16.sp,
                          weight: FontWeight.w400,
                          fontColor: isActive
                              ? widget.activeColor
                              : widget.inactiveColor.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepCircle(int index, bool isActive, bool isCompleted) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? widget.activeColor : widget.inactiveColor,
          width: 2.w,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: isActive ? 16.w : 0,
          height: isActive ? 16.h : 0,
          decoration: BoxDecoration(
            color: isActive ? AppColors.yellow2 : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalConnector(bool isCompleted) {
    return Container(
      width: 2.w,
      height: 40.h,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: VerticalDottedLine(
        color: isCompleted ? widget.activeColor : widget.inactiveColor,
        strokeWidth: 2,
        dashWidth: 5,
        dashSpace: 3,
      ),
    );
  }
}

class VerticalDottedLine extends StatelessWidget {
  final double width;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double? height;
  final bool roundedDots;

  const VerticalDottedLine({
    super.key,
    this.width = 1,
    this.color = AppColors.blackColor,
    this.strokeWidth = 1,
    this.dashWidth = 3,
    this.dashSpace = 3,
    this.height,
    this.roundedDots = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final finalHeight = height ?? constraints.maxHeight;
        final boxCount = (finalHeight / (dashWidth + dashSpace)).floor();

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(boxCount, (_) {
            return Container(
              width: strokeWidth,
              height: dashWidth,
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
