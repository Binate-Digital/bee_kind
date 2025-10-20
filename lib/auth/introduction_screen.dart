import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Introduction",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomButton(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BaseView()),
          ),
          text: "Skip",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Image.asset(AssetsPath.introImage),
            SizedBox(height: 20.h),
            Row(
              children: [
                CustomText(
                  text: "Lorem Ipsum Dolor",
                  weight: FontWeight.bold,
                  fontSize: 22.sp,
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
                        "Sed vehicula magna at lacus interdum, quis laoreet nulla condimentum. Aliquam erat volutpat. Cras et nulla in turpis consectetur suscipit. Vivamus lobortis, risus sit amet cursus tincidunt, erat turpis placerat ex, ut placerat justo lorem vel ligula. Fusce non diam felis",
                    maxLines: 10,
                    textAlign: TextAlign.start,
                    lineSpacing: 1.5,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
