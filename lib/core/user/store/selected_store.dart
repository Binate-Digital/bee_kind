import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/categories.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(30.w, 340.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.yellow1,
                backgroundBlendMode: BlendMode.darken,
                image: const DecorationImage(
                  image: AssetImage(AssetsPath.store),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 70.h,
                      bottom: 20.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 100.h),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  size: 30.r,
                                ),
                              ),
                              SizedBox(width: 10, height: 10),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10.w,
                            right: 10.w,
                            bottom: 20.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "Lorem Ipsum",
                                fontSize: 22.sp,
                                fontColor: AppColors.blackColor,
                                weight: FontWeight.bold,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    AssetsPath.clock,
                                    width: 19.w,
                                    color: AppColors.blackColor,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.h),
                                    child: CustomText(
                                      text: "9 AM To 6PM",
                                      fontSize: 18.sp,
                                      fontColor: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    AssetsPath.location,
                                    width: 17.w,
                                    color: AppColors.blackColor,
                                  ),
                                  Container(
                                    width: 200.w,
                                    padding: EdgeInsets.only(left: 11.h),
                                    child: CustomText(
                                      text: "Lorem ipsum road street 26",
                                      fontSize: 18.sp,
                                      overflow: TextOverflow.ellipsis,
                                      fontColor: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    AssetsPath.phone,
                                    width: 20.w,
                                    color: AppColors.blackColor,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.h),
                                    child: CustomText(
                                      text: "+123-456-7890",
                                      fontSize: 18.sp,
                                      fontColor: AppColors.blackColor,
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.h, right: 20.w, top: 20.h),
              child: CustomTextField(
                hint: "Search",
                bgColor: AppColors.whiteColor,
                bdColor: AppColors.yellow2,
                hintColor: AppColors.blackColor.withValues(alpha: 0.3),
                prefxicon: AssetsPath.search,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      CustomText(
                        text: "Most Demanded Products",
                        fontColor: AppColors.blackColor,
                        fontSize: 20.sp,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 195.h,
                    child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Product(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      CustomText(
                        text: "Categories",
                        fontColor: AppColors.blackColor,
                        fontSize: 20.sp,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 195.h,
                    child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Categories(),
                        );
                      },
                    ),
                  ),
                  GridView.builder(
                    itemCount: 6,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectedProduct(),
                            ),
                          );
                        },
                        child: Product(),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 210.h,
                      mainAxisSpacing: 20.h,
                      crossAxisSpacing: 10.w,
                      crossAxisCount: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
