import 'package:bee_kind/core/vendor/payment_screen.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/package_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  final List<Map<String, dynamic>> packages = [
    {
      "name": "Package\n\$9.99/Lorem",
      "text":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus nibh quam, tincidunt at condimentum et, tincidunt id justo. Vestibulum lacinia vulputate tellus.",
    },
    {
      "name": "Package\n\$19.99/Ipsum",
      "text":
          "Curabitur sit amet lacus id risus dictum mattis. Proin feugiat leo non turpis sagittis, a bibendum sapien egestas. Vestibulum sed massa ligula.",
    },
    {
      "name": "Package\n\$29.99/Dolor",
      "text":
          "Pellentesque habitant morbi tristique senectus et netus. Nulla facilisi. Praesent vehicula ante a risus volutpat tincidunt.",
    },
    {
      "name": "Package\n\$39.99/Elite",
      "text":
          "Sed vitae sapien euismod, faucibus risus non, faucibus sapien. Suspendisse commodo libero at nulla feugiat, sed efficitur ex rutrum.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      isLeading: false,
      title: "Subscriptions",
      button: Container(
        color: AppColors.whiteColor,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: CustomButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentScreen()),
            );
          },
          text: "7 Day's Free Trial",
          borderColor: AppColors.blackColor,
          verticalPadding: 20.h,
          horizontalPadding: 10.w,
          fontSize: 18.sp,
        ),
      ),
      body: SizedBox(
        // height: 660.h,
        width: 500.w,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final pkg = packages[index];
            return PackageContainer(
              packageName: pkg["name"],
              packageText: pkg["text"],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
