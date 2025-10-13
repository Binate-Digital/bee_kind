import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child, this.isProfile = false});
  final Widget? child;
  final bool? isProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isProfile == true
                ? Offstage()
                : Padding(
                    padding: EdgeInsets.only(bottom: 25.h, top: 90.h),
                    child: SizedBox(
                      width: 250.w,
                      child: Image.asset(AssetsPath.icon),
                    ),
                  ),
            child!,
          ],
        ),
      ),
    );
  }
}
