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

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 3.00;
  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Ratings & Reviews",
      isExtended: true,
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
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
                return StatefulBuilder(
                  builder: (context, setModalState) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 50.h,
                        horizontal: 20.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: "How is your order?",
                            weight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                            child: StarRating(
                              size: 40.r,
                              rating: rating,
                              color: AppColors.yellow2,
                              borderColor: Colors.grey,
                              allowHalfRating: true,
                              starCount: 5,
                              onRatingChanged: (rate) => setModalState(() {
                                rating = rate;
                              }),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: CustomTextField(
                              hint: "Write a Review",
                              radius: 10.r,
                              verticalPadding: 70.h,
                              maxlines: 6,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomButton(
                            onTap: () {
                              Navigator.pop(context);
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
          text: "Add Review",
        ),
      ),
      extendedWidget: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: CustomText(
                text: "4.8",
                fontSize: 35.sp,
                weight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: StarRating(
                size: 15.r,
                rating: 4.5,
                color: AppColors.yellow2,
                borderColor: Colors.grey,
                allowHalfRating: true,
                starCount: 5,
              ),
            ),
            CustomText(text: "52 Reviews", fontSize: 18.sp),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Row(
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
                                              padding: EdgeInsets.symmetric(
                                                vertical: 50.h,
                                                horizontal: 20.h,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomText(
                                                    text:
                                                        "Edit Rating & Review",
                                                    weight: FontWeight.bold,
                                                    fontSize: 18.sp,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 20.h,
                                                      bottom: 10.h,
                                                    ),
                                                    child: StarRating(
                                                      size: 40.r,
                                                      rating: rating,
                                                      color: AppColors.yellow2,
                                                      borderColor: Colors.grey,
                                                      allowHalfRating: true,
                                                      starCount: 5,
                                                      onRatingChanged: (rate) =>
                                                          setModalState(() {
                                                            rating = rate;
                                                          }),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 10.h,
                                                        ),
                                                    child: CustomTextField(
                                                      hint: "Write a Review",
                                                      radius: 10.r,
                                                      verticalPadding: 70.h,
                                                      maxlines: 6,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  CustomButton(
                                                    onTap: () {
                                                      Navigator.pop(context);
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
                                      Image.asset(AssetsPath.edit, width: 20.w),
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
                                  margin: EdgeInsets.symmetric(vertical: 20.h),
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
              ),
              GridView.builder(
                itemCount: 15,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(onTap: () {}, child: ReviewCard());
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 145.h,
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
