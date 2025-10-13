import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressBar extends StatefulWidget {
  const AddressBar({super.key, required this.onTap, this.isEdit = false});
  final VoidCallback onTap;
  final bool isEdit;

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.yellow2, width: 1.w),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(Icons.location_on, color: AppColors.yellow2),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.yellow2,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  width: 1.5.w,
                  height: 30.h,
                ),
              ],
            ),
            Expanded(
              child: CustomText(
                text: "USA New York, Lorem ipsum road",
                textAlign: TextAlign.start,
                fontColor: AppColors.blackColor.withValues(alpha: 0.3),
                fontSize: 18.sp,
              ),
            ),
            widget.isEdit
                ? Icon(Icons.edit, color: AppColors.blackColor)
                : Offstage(),
          ],
        ),
      ),
    );
  }
}
