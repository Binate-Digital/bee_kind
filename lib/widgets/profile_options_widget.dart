import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileOption extends StatefulWidget {
  const ProfileOption({
    super.key,
    required this.onTap,
    required this.image,
    required this.text,
    this.isNotification = false,
  });
  final VoidCallback onTap;
  final String image;
  final String text;
  final bool isNotification;

  @override
  State<ProfileOption> createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<ProfileOption> {
  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 40.h,
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
                widget.isNotification
                    ? slidingToggleButton(
                        value: isToggled,
                        onChanged: (newValue) {
                          setState(() {
                            isToggled = newValue;
                          });
                        },
                      )
                    : Icon(Icons.arrow_forward_rounded),
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

  Widget slidingToggleButton({
    required bool value,
    ValueChanged<bool>? onChanged,
    double width = 40,
    double height = 25,
    Duration animationDuration = const Duration(milliseconds: 200),
    Key? key,
  }) {
    return GestureDetector(
      key: key,
      onTap: () => onChanged?.call(!value),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? AppColors.yellow2 : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: height - 4,
            height: height - 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
