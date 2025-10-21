import 'dart:io';

import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

void showImagePickerBottomSheet({
  required String title,
  required Function(File file) onImagePicked,
  required String target,
  required BuildContext context,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final file = await chooseImage(
                  context: context,
                  source: ImageSource.camera,
                  target: target,
                );
                if (file != null) onImagePicked(file);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt, color: AppColors.yellow2),
                    SizedBox(width: 15.w),
                    CustomText(
                      text: "Take Photo",
                      fontSize: 18.sp,
                      fontColor: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final file = await chooseImage(
                  context: context,
                  source: ImageSource.gallery,
                  target: target,
                );
                if (file != null) onImagePicked(file);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                child: Row(
                  children: [
                    Icon(Icons.photo_library, color: AppColors.yellow2),
                    SizedBox(width: 15.w),
                    CustomText(
                      text: "Choose from Gallery",
                      fontSize: 18.sp,
                      fontColor: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    ),
  );
}
