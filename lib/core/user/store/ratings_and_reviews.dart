import 'package:bee_kind/models/response_models/product_reviews_response_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class RatingScreen extends StatelessWidget {
  RatingScreen({
    super.key,
    this.addReview = false,
    this.isVendor = false,
    this.avgRating,
    this.reviews,
    this.totalReviews,
  });
  final bool addReview;
  final bool isVendor;
  final dynamic avgRating;
  final dynamic totalReviews;
  final List<Reviews>? reviews;

  double rating = 3.00;

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Ratings & Reviews",
      isExtended: true,
      extendedWidget: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: CustomText(
                text: avgRating.toString(),
                fontSize: 35.sp,
                weight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: StarRating(
                size: 15.r,
                rating: double.tryParse(avgRating.toString()) ?? 0.0,
                color: AppColors.yellow2,
                borderColor: Colors.grey,
                allowHalfRating: true,
                starCount: 5,
              ),
            ),
            CustomText(text: "$totalReviews Reviews", fontSize: 18.sp),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              addReview
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isDismissible: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  topRight: Radius.circular(30.r),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 50.h,
                                    horizontal: 20.h,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showModalBottomSheet(
                                            isDismissible: true,
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.r),
                                                topRight: Radius.circular(30.r),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (context, setModalState) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 50.h,
                                                          horizontal: 20.h,
                                                        ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CustomText(
                                                          text:
                                                              "Edit Rating & Review",
                                                          weight:
                                                              FontWeight.bold,
                                                          fontSize: 18.sp,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                top: 20.h,
                                                                bottom: 10.h,
                                                              ),
                                                          child: StarRating(
                                                            size: 40.r,
                                                            rating: rating,
                                                            color: AppColors
                                                                .yellow2,
                                                            borderColor:
                                                                Colors.grey,
                                                            allowHalfRating:
                                                                true,
                                                            starCount: 5,
                                                            onRatingChanged:
                                                                (rate) =>
                                                                    setModalState(
                                                                      () {
                                                                        rating =
                                                                            rate;
                                                                      },
                                                                    ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                vertical: 10.h,
                                                              ),
                                                          child: CustomTextField(
                                                            hint:
                                                                "Write a Review",
                                                            radius: 10.r,
                                                            maxlines: 6,
                                                          ),
                                                        ),
                                                        SizedBox(height: 20.h),
                                                        CustomButton(
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          text: "Save",
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AssetsPath.edit,
                                              width: 20.w,
                                            ),
                                            SizedBox(width: 20.w),
                                            CustomText(
                                              text: "Edit Review",
                                              weight: FontWeight.bold,
                                              fontSize: 18.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 20.h,
                                        ),
                                        color: AppColors.blackColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        height: 1.w,
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AssetsPath.delete,
                                              width: 20.w,
                                            ),
                                            SizedBox(width: 20.w),
                                            CustomText(
                                              text: "Delete Review",
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
                          child: Icon(Icons.more_vert),
                        ),
                      ],
                    )
                  : Offstage(),
              GridView.builder(
                itemCount: reviews?.length ?? 0,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = reviews?[index];
                  return ReviewCard(
                    isVendor: isVendor,
                    review: data?.review ?? "",
                    vendorResponse: data?.reply ?? "",
                    ratingCount: data?.rating ?? 0,
                    userName: data?.user?.fullName,
                    userImage: data?.user?.profileImage,
                    reviewId: data?.sId,
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: isVendor ? 130.h : 200.h,
                  crossAxisSpacing: 10.w,
                  crossAxisCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
