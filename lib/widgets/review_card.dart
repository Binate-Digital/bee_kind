import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/response_dialog.dart';
import 'package:bee_kind/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({
    super.key,
    this.enabled = false,
    this.isVendor = false,
    this.vendorResponse,
    this.review,
    this.ratingCount,
    this.userImage,
    this.userName,
  });

  final bool enabled;
  final bool isVendor;
  final String? vendorResponse;
  final String? review;
  final int? ratingCount;
  final String? userImage;
  final String? userName;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  double rating = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Reviewer Info Row ===
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Profile Image
                UserAvatarWidget(
                  radius: 40.r,
                  selectedImgPath: widget.userImage,
                  isViewOnly: true,
                  placeHolder: AssetsPath.placeholder,
                ),
                SizedBox(width: 10.w),

                Column(
                  children: [
                    // Name + Respond button (if vendor)
                    CustomText(
                      text: widget.userName ?? "John Smith",
                      fontSize: 18.sp,
                      fontColor: AppColors.blackColor,
                      weight: FontWeight.bold,
                    ),
                    widget.isVendor
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
              ],
            ),

            // Rating Stars
            StarRating(
              size: 20.r,
              rating: double.tryParse(widget.ratingCount.toString()) ?? 0.0,
              color: AppColors.yellow2,
              borderColor: Colors.grey,
              allowHalfRating: true,
              starCount: 5,
              onRatingChanged: (rate) =>
                  widget.enabled ? setState(() => rating = rate) : null,
            ),
          ],
        ),

        SizedBox(height: 10.h),

        // === Review Text ===
        SizedBox(
          width: double.infinity,
          child: CustomText(
            text: widget.review ?? "",
            fontSize: 16.sp,
            textAlign: TextAlign.start,
            maxLines: 2,
            fontColor: AppColors.blackColor,
          ),
        ),

        SizedBox(height: 10.h),

        // === Vendor Response Section ===
        if (!widget.isVendor && widget.vendorResponse != null) ...[
          SizedBox(height: 8.h),
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
                    text: widget.vendorResponse ?? "",
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

        SizedBox(height: 15.h),
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
