import 'dart:io';

import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/discount_dialog.dart';
import 'package:bee_kind/widgets/image_picking_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.isEdit});
  final bool? isEdit;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<File> selectedImages = [];
  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Add Products",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomButton(
          onTap: () {
            Navigator.pop(context);
          },
          text: "Add Products",
        ),
      ),
      body: Form(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                DottedBorderImagePicker(
                  maxImages: 3,
                  onImagesSelected: (images) {
                    setState(() {
                      selectedImages = images;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Product Name"),
                SizedBox(height: 10.h),
                CustomDropdown(
                  items: ["Category 1", "Category 2", "Category 3"],
                  hintText: "Product Category",
                ),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Product Quantity"),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Special Offer / Discount"),
                if (widget.isEdit == true)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: GestureDetector(
                      onTap: () => showDiscountDialog(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.add_circle, color: AppColors.yellow2),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: "Add Discounted Price",
                            fontSize: 18.sp,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(height: 10.h),
                CustomTextField(hint: "Product Cost"),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Effects"),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Ingredients", maxlines: 4, radius: 10.r),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Description", maxlines: 4, radius: 10.r),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
