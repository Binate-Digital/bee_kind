import 'package:bee_kind/core/user/store/ratings_and_reviews.dart';
import 'package:bee_kind/core/user/user_base_view.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/review_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedProduct extends StatefulWidget {
  const SelectedProduct({super.key});

  @override
  State<SelectedProduct> createState() => _SelectedProductState();
}

class _SelectedProductState extends State<SelectedProduct> {
  int currentCarouselIndex = 0;

  int _count = 0;

  void increment() {
    setState(() {
      _count++;
    });
  }

  void decrement() {
    setState(() {
      if (_count > 0) _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(30.w, 350.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      items: [1, 2, 3].map((i) {
                        return Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(AssetsPath.store),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 290.h,
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 2.0,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentCarouselIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 270.h,
                  left: 170.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [1, 2, 3].asMap().entries.map((entry) {
                      bool isSelected = currentCarouselIndex == entry.key;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: isSelected ? 50.w : 8.w,
                        height: 8.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blackColor,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.whiteColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 70.h,
                    bottom: 20.h,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 150.h),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back_rounded, size: 30.r),
                        ),
                        SizedBox(width: 10, height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Lorem Ipsum",
                    fontSize: 22.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: "\$20.00",
                    fontSize: 16.sp,
                    fontColor: AppColors.yellow2,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AssetsPath.star, width: 18.w),
                      CustomText(
                        text: "4.8\t\t 52 Reviews",
                        fontSize: 16.sp,
                        fontColor: AppColors.blackColor,
                      ),
                    ],
                  ),
                  CustomText(
                    text: "In Stock",
                    fontSize: 22.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 5),
                  CustomText(
                    text: "5 Products Left",
                    fontSize: 16.sp,
                    fontColor: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  CustomText(
                    text: "Description",
                    fontSize: 22.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
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
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  CustomText(
                    text: "Effects",
                    fontSize: 22.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
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
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  CustomText(
                    text: "Ingredients",
                    fontSize: 22.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
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
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  CustomText(
                    text: "Dosage",
                    fontSize: 22.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
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
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  CustomText(
                    text: "Quantity",
                    fontSize: 18.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(width: 20.w),
                  Row(
                    children: [
                      // Minus Button (Left side with left border radius)
                      GestureDetector(
                        onTap: decrement,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _count > 0
                                ? AppColors.blackColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              bottomLeft: Radius.circular(24.r),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 30.w,
                              color: _count > 0 ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      // Count Display (Center)
                      Container(
                        width: 50.w,
                        color: Colors.transparent,
                        child: Center(
                          child: CustomText(
                            text: '$_count',
                            fontSize: 22.sp,
                            weight: FontWeight.bold,
                            fontColor: AppColors.blackColor,
                          ),
                        ),
                      ),

                      // Plus Button (Right side with right border radius)
                      GestureDetector(
                        onTap: increment,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.yellow2,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24.r),
                              bottomRight: Radius.circular(24.r),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 30.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              CustomButton(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserBaseView(currIndex: 1),
                    ),
                    (route) => false,
                  );
                },
                text: "Add To Cart",
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Rating & Reviews",
                    fontSize: 18.sp,
                    fontColor: AppColors.blackColor,
                    weight: FontWeight.bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RatingScreen()),
                      );
                    },
                    child: CustomText(
                      text: "View All",
                      fontSize: 16.sp,
                      underlined: true,
                      fontColor: AppColors.blackColor,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
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
