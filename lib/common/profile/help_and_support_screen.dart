import 'package:bee_kind/common/profile/support_chat_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/image_picking_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  List<File> selectedImages = [];
  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Help & Support",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SupportChatScreen()),
                  ),
                  child: Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.yellow2,
                    ),
                    child: Transform.scale(
                      scale: 0.5,
                      child: Image.asset(AssetsPath.support),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            CustomButton(
              borderColor: AppColors.blackColor,
              onTap: () => Navigator.pop(context),
              text: "Send",
            ),
          ],
        ),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              CustomTextField(hint: "Subject"),
              SizedBox(height: 20.h),
              CustomTextField(hint: "Description", maxlines: 5, radius: 10.r),
              SizedBox(height: 20.h),

              DottedBorderImagePicker(
                maxImages: 3,
                onImagesSelected: (images) {
                  setState(() {
                    selectedImages = images;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
