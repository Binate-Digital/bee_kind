import 'dart:io';

import 'package:bee_kind/widgets/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> chooseImage({
  required BuildContext context,
  required ImageSource source,
  required String target,
}) async {
  final ImagePicker imagePicker = ImagePicker();
  try {
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

