import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressType extends StatelessWidget {
  const AddressType({
    super.key,
    required this.isChecked,
    required this.type,
    required this.address,
    required this.onChanged,
    this.isEdit = false,
    this.onEditTap,
    this.isDefault = false,
  });

  final bool isChecked; // selected by user
  final bool isDefault; // API default address
  final String type; // Home, Office, etc.
  final String address; // actual address
  final void Function(bool?)? onChanged;

  final bool isEdit; // whether to show the edit icon
  final VoidCallback? onEditTap; // passed from AddressScreen

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.15),
            blurRadius: 25.r,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isChecked ? AppColors.yellow2 : Colors.transparent,
          width: isChecked ? 2 : 0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            checkColor: AppColors.yellow2,
            fillColor: WidgetStateProperty.all(
              AppColors.yellow1.withValues(alpha: 0.2),
            ),
            side: BorderSide(color: AppColors.yellow2, width: 1),
          ),

          SizedBox(width: 10.w),

          // TEXTS + Default badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: type,
                      fontSize: 18.sp,
                      weight: FontWeight.bold,
                    ),

                    SizedBox(width: 8.w),

                    // if (isDefault)
                    //   Container(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 6.w,
                    //       vertical: 2.h,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.yellow2.withValues(alpha: 0.15),
                    //       borderRadius: BorderRadius.circular(6.r),
                    //     ),
                    //     child: CustomText(
                    //       text: "Default",
                    //       fontSize: 12.sp,
                    //       fontColor: AppColors.yellow2,
                    //       weight: FontWeight.bold,
                    //     ),
                    //   ),
                  ],
                ),

                SizedBox(height: 10.h),

                CustomText(
                  text: address,
                  textAlign: TextAlign.left,
                  fontSize: 16.sp,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // EDIT ICON — only visible in edit mode
          if (isEdit == true)
            GestureDetector(
              onTap: onEditTap,
              child: Icon(Icons.edit, size: 25.sp, color: AppColors.yellow2),
            ),
        ],
      ),
    );
  }
}
