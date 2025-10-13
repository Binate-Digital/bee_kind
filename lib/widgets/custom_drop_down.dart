import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final Function(String?)? onChanged;
  final String? initialValue;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hintText,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.5.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.yellow1.withValues(alpha: 0.2),
        border: Border.all(color: AppColors.yellow2, width: 1),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: CustomText(
            text: widget.hintText,
            fontSize: 18.sp,
            fontColor: AppColors.yellow2,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.yellow2,
          ),
          dropdownColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          isExpanded: true,
          items: widget.items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: CustomText(
                    text: item,
                    fontSize: 18.sp,
                    fontColor: AppColors.yellow2,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
