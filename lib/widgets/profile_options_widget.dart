import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/sliding_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileOption extends StatefulWidget {
  const ProfileOption({
    super.key,
    required this.onTap,
    required this.image,
    required this.text,
    this.isNotification = false,
    this.initialToggleValue,
    this.onToggleChanged,
  });
  final VoidCallback onTap;
  final String image;
  final String text;
  final bool isNotification;
  final bool? initialToggleValue;
  final ValueChanged<bool>? onToggleChanged;

  @override
  State<ProfileOption> createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<ProfileOption> {
  bool isToggled = false;
  @override
  void initState() {
    super.initState();
    isToggled = widget.initialToggleValue ?? false;
  }

  @override
  void didUpdateWidget(covariant ProfileOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent provides a new initial value (e.g., after fetching profile), update toggle
    if (widget.initialToggleValue != null &&
        widget.initialToggleValue != oldWidget.initialToggleValue) {
      setState(() => isToggled = widget.initialToggleValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isNotification ? null : widget.onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        height: 50.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(widget.image, height: 30.h, width: 30.h),
                    SizedBox(width: 10.w),
                    CustomText(text: widget.text, fontSize: 18.sp),
                  ],
                ),

                /// Toggle OR Navigate arrow
                widget.isNotification
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() => isToggled = !isToggled);
                          widget.onToggleChanged?.call(isToggled);
                        },
                        child: slidingToggleButton(
                          value: isToggled,
                          onChanged: (newValue) {
                            setState(() => isToggled = newValue);
                            widget.onToggleChanged?.call(newValue);
                          },
                        ),
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onTap,
                        child: Icon(Icons.arrow_forward_rounded),
                      ),
              ],
            ),

            Container(
              decoration: BoxDecoration(
                color: AppColors.blackColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30.r),
              ),
              height: 2.w,
            ),
          ],
        ),
      ),
    );
  }
}
