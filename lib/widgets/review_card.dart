import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({super.key, this.enabled = false});
  final bool enabled;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  double rating = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  margin: EdgeInsets.symmetric(vertical: 15.h),
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
                CustomText(
                  text: "John Smith",
                  fontSize: 18.sp,
                  fontColor: AppColors.blackColor,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            StarRating(
              size: 25.r,
              rating: rating,
              color: AppColors.yellow2,
              borderColor: Colors.grey,
              allowHalfRating: true,
              starCount: 5,
              onRatingChanged: (rating) => widget.enabled
                  ? setState(() {
                      this.rating = rating;
                    })
                  : null,
            ),
          ],
        ),
        SizedBox(
          width: 390.w,
          child: CustomText(
            text:
                "Lorem ipsum dolor sit amet consectetur adipiscing elit porta, leo erat parturient arcu.",
            fontSize: 16.sp,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            maxLines: 2,
            fontColor: AppColors.blackColor,
          ),
        ),
        SizedBox(height: 20.w),
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
