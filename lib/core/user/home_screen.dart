import 'package:bee_kind/core/user/store/selected_store.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/address_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/selected_store_location_widget.dart';
import 'package:bee_kind/widgets/slider_thumb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String location = "";
  String differentLocation = "";

  double currentValue = 50.0;
  final double minValue = 1.0;
  final double maxValue = 100.0;

  String formatPrice(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomTextField(
            hint: "Search",
            bgColor: AppColors.whiteColor,
            bdColor: AppColors.yellow2,
            hintColor: AppColors.blackColor.withValues(alpha: 0.3),
            prefxicon: AssetsPath.search,
            isSuffixIcon: true,
            suffixIcon: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20.h,
                            horizontal: 20.w,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdown(
                                items: [
                                  "Category 1",
                                  "Category 2",
                                  "Category 3",
                                ],
                                hintText: "Product Category",
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 190.w,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15.h,
                                        horizontal: 15.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.yellow1.withValues(
                                          alpha: 0.2,
                                        ),
                                        border: Border.all(
                                          color: AppColors.yellow2,
                                          width: 1.w,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          30.r,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomText(
                                                  text: "Location",
                                                  textAlign: TextAlign.start,
                                                  fontColor: AppColors.yellow2,
                                                  fontSize: 18.sp,
                                                ),
                                                Icon(
                                                  Icons.location_on,
                                                  color: AppColors.yellow2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 190.w,
                                      child: CustomDropdown(
                                        items: [
                                          "New York",
                                          "Chicago",
                                          "Boston",
                                        ],
                                        hintText: "City",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 18.h),
                                child: CustomText(
                                  text: "Price Range",
                                  fontFamily: "Raleway",
                                  weight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(
                                height: 60.h,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    SliderTheme(
                                      data: SliderThemeData(
                                        thumbShape: GradientThumbShape(),
                                        overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 14.r,
                                        ),
                                        activeTrackColor: AppColors.blackColor
                                            .withValues(alpha: 0.2),
                                        inactiveTrackColor: AppColors.blackColor
                                            .withValues(alpha: 0.2),
                                        thumbColor: Colors
                                            .transparent, // We'll handle this in custom shape
                                        overlayColor: AppColors.yellow1
                                            .withValues(alpha: 0.2),
                                      ),
                                      child: Slider(
                                        value: currentValue,
                                        min: minValue,
                                        max: maxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            currentValue = value;
                                            formatPrice(currentValue);
                                            debugPrint(
                                              "current value: $currentValue",
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      left:
                                          ((currentValue - minValue) /
                                                  (maxValue - minValue)) *
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  85.w) +
                                          0.w,
                                      top: 45.h,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        child: CustomText(
                                          text: formatPrice(currentValue),
                                          fontSize: 12.sp,
                                          weight: FontWeight.bold,
                                          fontColor: AppColors.yellow2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30.h),
                                child: CustomButton(
                                  onTap: () => Navigator.pop(context),
                                  text: "Search",
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Image.asset(AssetsPath.filter, color: AppColors.yellow2),
            ),
          ),
        ),
        AddressBar(onTap: () {}),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StoreScreen()),
            );
          },
          child: SelectedStoreLocation(),
        ),
      ],
    );
  }
}
