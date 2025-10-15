import 'dart:io';

import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class DottedBorderImagePicker extends StatefulWidget {
  final Function(List<File>)? onImagesSelected;
  final String? hintText;
  final int maxImages;

  const DottedBorderImagePicker({
    super.key,
    this.onImagesSelected,
    this.hintText = "Upload pictures",
    this.maxImages = 3,
  });

  @override
  State<DottedBorderImagePicker> createState() =>
      _DottedBorderImagePickerState();
}

class _DottedBorderImagePickerState extends State<DottedBorderImagePicker> {
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Check if user can select more images
      if (_selectedImages.length >= widget.maxImages) {
        _showErrorDialog(
          "You can only select up to ${widget.maxImages} images",
        );
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        widget.onImagesSelected?.call(_selectedImages);
      }
    } catch (e) {
      _showErrorDialog(
        "Failed to ${source == ImageSource.camera ? 'capture' : 'select'} image",
      );
    }
  }

  void _showImageSourceDialog() {
    // Check if user can select more images
    if (_selectedImages.length >= widget.maxImages) {
      _showErrorDialog("You can only select up to ${widget.maxImages} images");
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Text(
              "Choose Image Source",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.yellow2),
              title: Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.yellow2),
              title: Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesSelected?.call(_selectedImages);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload Container (Always empty)
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(10.r),
              color: AppColors.yellow2,
              dashPattern: [20, 1],
              strokeWidth: 1.5.w,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.yellow1.withValues(alpha: 0.2),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 30.w,
                      color: AppColors.yellow2,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: widget.hintText!,
                      fontSize: 16.sp,
                      fontColor: AppColors.yellow2,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // Selected Images List
        if (_selectedImages.isNotEmpty) ...[
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(_selectedImages.length, (index) {
              return _buildImageItem(_selectedImages[index], index);
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildImageItem(File imageFile, int index) {
    return Stack(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.blackColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              imageFile,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: -4.w,
          right: -4.w,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.close, color: Colors.white, size: 12.w),
            ),
          ),
        ),
      ],
    );
  }
}
