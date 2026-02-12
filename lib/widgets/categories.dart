import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, this.image, this.name});

  final String? image;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: [
          UserAvatarWidget(
            radius: 60,
            selectedImgPath: image,
            isViewOnly: true,
          ),
          SizedBox(height: 5.h),
          CustomText(
            text: name ?? "",
            fontSize: 18.sp,
            fontColor: AppColors.yellow2,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
