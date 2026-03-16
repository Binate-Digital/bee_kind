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
    this.vendorResponses,
    this.review,
    this.ratingCount,
    this.userImage,
    this.userName,
    this.reviewId,
    this.repliedBy,
  });

  final bool enabled;
  final bool isVendor;
  final List<String>? vendorResponses;
  final String? review;
  final int? ratingCount;
  final String? userImage;
  final String? userName;
  final String? reviewId;

  final List<String>? repliedBy;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  double rating = 3;
  late List<String> _replies;
  late String _reviewText;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _replies = List<String>.from(widget.vendorResponses ?? const []);
    _reviewText = widget.review ?? "";
  }

  @override
  void didUpdateWidget(covariant ReviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vendorResponses != widget.vendorResponses) {
      _replies = List<String>.from(widget.vendorResponses ?? const []);
    }
    if (oldWidget.review != widget.review) {
      _reviewText = widget.review ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) return const SizedBox.shrink();

    final replies = _replies;
    final repliedByList = widget.repliedBy ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvatarWidget(
                    radius: 40.r,
                    selectedImgPath: widget.userImage,
                    isViewOnly: true,
                    placeHolder: AssetsPath.placeholder,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: (widget.userName != null &&
                              widget.userName!.isNotEmpty)
                              ? widget.userName!
                              : "Anonymous User",
                          fontSize: 18.sp,
                          fontColor: AppColors.blackColor,
                          weight: FontWeight.bold,
                        ),
                        if (widget.isVendor)
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final newReply = await showRespondDialog(
                                    context,
                                    widget.reviewId,
                                  );

                                  if (newReply != null && newReply.isNotEmpty) {
                                    setState(() => _replies.add(newReply));
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  margin: EdgeInsets.only(top: 10.h),
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
                                    text: _reviewText,
                                  );

                                  await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Edit Review"),
                                      content: TextField(
                                        controller: editController,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
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
                                            final isUpdated = await storeController.updateReview(
                                              widget.reviewId,
                                              editController.text,
                                              context,
                                            );
                                            if (isUpdated && mounted) {
                                              setState(() => _reviewText = editController.text);
                                            }
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
                                  margin: EdgeInsets.only(top: 10.h),
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
                                            final isDeleted = await storeController.deleteReview(
                                              widget.reviewId,
                                              context,
                                            );
                                            if (isDeleted && mounted) {
                                              setState(() => _isDeleted = true);
                                            }
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
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            StarRating(
              size: 20.r,
              rating: (widget.ratingCount ?? 0).toDouble(),
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

        SizedBox(
          width: double.infinity,
          child: CustomText(
            text: _reviewText,
            fontSize: 16.sp,
            textAlign: TextAlign.start,
            maxLines: 2,
            fontColor: AppColors.blackColor,
          ),
        ),

        if (replies.isNotEmpty) ...[
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
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
                    text: repliedByList.isNotEmpty
                        ? "${repliedByList.join(', ')}:"
                        : "Vendor:",
                    fontSize: 15.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 6.h),
                  ...List.generate(
                    replies.length,
                        (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == replies.length - 1 ? 0 : 6.h,
                      ),
                      child: CustomText(
                        text: replies[index],
                        fontSize: 15.sp,
                        fontColor: AppColors.blackColor,
                        textAlign: TextAlign.start,
                      ),
                    ),
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