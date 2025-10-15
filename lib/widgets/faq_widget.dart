import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQDropdown extends StatefulWidget {
  final String question;
  final String answer;
  final bool isExpanded;

  const FAQDropdown({
    super.key,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  @override
  State<FAQDropdown> createState() => _FAQDropdownState();
}

class _FAQDropdownState extends State<FAQDropdown> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.15),
            blurRadius: 15.r,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          // Question Row
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text: widget.question,
                      maxLines: 6,
                      fontSize: 16.sp,
                      lineSpacing: 1.5,
                      weight: FontWeight.bold,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    _isExpanded ? Icons.remove_circle : Icons.add_circle,
                    size: 24.w,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),
          ),

          // Answer Section
          if (_isExpanded) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColors.blackColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: CustomText(
                text: widget.answer,
                maxLines: 6,
                lineSpacing: 1.5,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
