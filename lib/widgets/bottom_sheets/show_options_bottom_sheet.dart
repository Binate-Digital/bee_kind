import 'package:bee_kind/core/vendor/store/add_product_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/delete_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddProductScreen(isEdit: true),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(AssetsPath.edit, width: 20.w),
                        SizedBox(width: 10.w),
                        CustomText(
                          text: "Edit Product",
                          weight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      deleteProductDialog(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(AssetsPath.delete, width: 20.w),
                        SizedBox(width: 10.w),
                        CustomText(
                          text: "Delete Product",
                          weight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
