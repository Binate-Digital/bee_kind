import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({
    super.key,
    this.enabled = false,
    this.isVendor = false,
    this.vendorResponse, // ✅ new field
  });

  final bool enabled;
  final bool isVendor;
  final String? vendorResponse; // ✅ vendor response text

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  double rating = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ keep left-aligned
      children: [
        // === Reviewer Info Row ===
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Profile Image
                Container(
                  width: 40.w,
                  height: 40.h,
                  margin: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.yellow2, width: 1),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(AssetsPath.placeholder),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Name + Respond button (if vendor)
                CustomText(
                  text: "John Smith",
                  fontSize: 18.sp,
                  fontColor: AppColors.blackColor,
                  weight: FontWeight.bold,
                ),
                widget.isVendor && (widget.vendorResponse == null)
                    ? GestureDetector(
                        onTap: () => showRespondDialog(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.yellow2,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CustomText(
                            text: "Respond",
                            fontColor: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                    : Offstage(),
              ],
            ),

            // Rating Stars
            StarRating(
              size: 20.r,
              rating: rating,
              color: AppColors.yellow2,
              borderColor: Colors.grey,
              allowHalfRating: true,
              starCount: 5,
              onRatingChanged: (rating) =>
                  widget.enabled ? setState(() => this.rating = rating) : null,
            ),
          ],
        ),

        // === Review Text ===
        SizedBox(
          width: double.infinity,
          child: CustomText(
            text:
                "Lorem ipsum dolor sit amet consectetur adipiscing elit porta, leo erat parturient arcu.",
            fontSize: 16.sp,
            textAlign: TextAlign.start,
            maxLines: 2,
            fontColor: AppColors.blackColor,
          ),
        ),

        // === Vendor Response Section ===
        if (widget.vendorResponse != null) ...[
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            // height: 120.h,
            decoration: BoxDecoration(
              color: AppColors.yellow1.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Vendor:",
                    fontSize: 15.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: widget.vendorResponse!,
                    fontSize: 15.sp,
                    fontColor: AppColors.blackColor,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],

        SizedBox(height: 20.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.blackColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          height: 2.w,
        ),
      ],
    );
  }

}
