import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressType extends StatefulWidget {
  const AddressType({
    super.key,
    this.onChanged,
    required this.isChecked,
    required this.type,
    this.hasCheckBox = true,
  });
  final void Function(bool?)? onChanged;
  final bool isChecked;
  final String type;
  final bool hasCheckBox;

  @override
  State<AddressType> createState() => _AddressTypeState();
}

class _AddressTypeState extends State<AddressType> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.15),
            blurRadius: 25.r,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
        color: AppColors.whiteColor,
      ),
      child: Row(
        children: [
          widget.hasCheckBox
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  width: 40.w,
                  child: Checkbox(
                    value: widget.isChecked,
                    checkColor: AppColors.yellow2,
                    onChanged: widget.onChanged,
                    fillColor: WidgetStateProperty.all(
                      AppColors.yellow1.withValues(alpha: 0.2),
                    ),
                    side: BorderSide(color: AppColors.yellow2, width: 1),
                  ),
                )
              : Container(
                  width: 50.w,
                  height: 50.h,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.yellow1,
                  ),
                  child: Transform.scale(
                    scale: 0.6,
                    child: Image.asset(
                      AssetsPath.location,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: widget.type,
                fontSize: 18.sp,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: 270.w,
                child: CustomText(
                  text: "Lorem ipsum dolor sit amet consectetur adip.",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Icon(Icons.edit, color: AppColors.yellow2),
        ],
      ),
    );
  }
}
