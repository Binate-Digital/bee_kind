import 'dart:io';

import 'package:bee_kind/widgets/dialogs/error_dialog.dart';
import 'package:bee_kind/widgets/dialogs/show_permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> chooseImage({
  required BuildContext context,
  required ImageSource source,
  required String target, // e.g., "profile" or "license"
}) async {
  final ImagePicker imagePicker = ImagePicker();
  try {
    // Handle camera permission
    if (source == ImageSource.camera) {
      final permissionStatus = await Permission.camera.request();
      if (!permissionStatus.isGranted) {
        showPermissionDeniedDialog('Camera', context);
        return null;
      }
    }

    final XFile? image = await imagePicker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (image != null) {
      return File(image.path);
    } else {
      debugPrint("No $target image selected");
    }
  } catch (e) {
    debugPrint("Error picking $target image: $e");
    errorSnackBar("Failed to upload $target image", context);
  }
  return null;
}
