import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

void showPermissionDeniedDialog(String permission, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(text: "Permission Required"),
        content: CustomText(
          text:
              "Please grant $permission permission to select a profile picture",
          fontSize: 14.sp,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText(text: "Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: CustomText(text: "Open Settings"),
          ),
        ],
      ),
    );
  }