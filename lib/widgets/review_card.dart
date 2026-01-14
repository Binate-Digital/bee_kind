import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/dialogs/response_dialog.dart';
import 'package:bee_kind/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    this.reviewId,
  });

  final bool enabled;
  final bool isVendor;
  final String? vendorResponse;
  final String? review;
  final int? ratingCount;
  final String? userImage;
  final String? userName;
  final String? reviewId;

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
                    // Name + Action buttons (if vendor)
                    CustomText(
                      text: (widget.userName != null && widget.userName!.isNotEmpty) 
                          ? widget.userName! 
                          : "Anonymous User",
                      fontSize: 18.sp,
                      fontColor: AppColors.blackColor,
                      weight: FontWeight.bold,
                    ),
                    if (widget.isVendor)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                showRespondDialog(context, widget.reviewId),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              margin: EdgeInsets.only(top: 10.h, right: 8.w),
                              decoration: BoxDecoration(
                                color: AppColors.yellow2,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: CustomText(
                                text: "Respond",
                                fontColor: Colors.black,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final TextEditingController editController =
                                  TextEditingController(
                                    text: widget.review ?? "",
                                  );
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Edit Review"),
                                  content: TextField(
                                    controller: editController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: "Edit your review",
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(ctx);
                                        final storeController =
                                            Get.find<StoreController>();
                                        await storeController.updateReview(
                                          widget.reviewId,
                                          editController.text,
                                          context,
                                        );
                                      },
                                      child: const Text("Save"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              margin: EdgeInsets.only(top: 10.h, right: 8.w),
                              decoration: BoxDecoration(
                                color: AppColors.yellow1,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: CustomText(
                                text: "Edit",
                                fontColor: Colors.black,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Show confirmation dialog
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Delete Review"),
                                  content: const Text(
                                    "Are you sure you want to delete this review?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(ctx);
                                        final storeController =
                                            Get.find<StoreController>();
                                        await storeController.deleteReview(
                                          widget.reviewId,
                                          context,
                                        );
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              margin: EdgeInsets.only(top: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: CustomText(
                                text: "Delete",
                                fontColor: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
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
        // if (!widget.isVendor && widget.vendorResponse != null) ...[
        //   SizedBox(height: 8.h),
        //   Container(
        //     width: double.infinity,
        //     // height: 120.h,
        //     decoration: BoxDecoration(
        //       color: AppColors.yellow1.withValues(alpha: 0.3),
        //       borderRadius: BorderRadius.circular(15.r),
        //     ),
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           CustomText(
        //             text: "Vendor:",
        //             fontSize: 15.sp,
        //             fontColor: AppColors.blackColor,
        //             weight: FontWeight.bold,
        //           ),
        //           SizedBox(height: 6.h),
        //           CustomText(
        //             text: widget.vendorResponse ?? "",
        //             fontSize: 15.sp,
        //             fontColor: AppColors.blackColor,
        //             maxLines: 3,
        //             textAlign: TextAlign.start,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ],

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
