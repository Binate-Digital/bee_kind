import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/core/vendor/store/add_product_screen.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/popular_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  bool isVendor = false;
  List<bool> hasDiscount = [true, false, false, false, false];

  final prefs = SharedPrefs();

  @override
  void initState() {
    isVendor = prefs.getString("role") == "vendor";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "My Products",
      body: ListView.builder(
        itemCount: hasDiscount.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              debugPrint("isVendor: $isVendor");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectedProduct(
                    isVendor: isVendor,
                    hasDiscount: hasDiscount[index],
                  ),
                ),
              );
            },
            child: Products(isPopular: false),
          );
        },
      ),
      button: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddProductScreen()),
          );
        },
        backgroundColor: AppColors.yellow2,
        child: Icon(Icons.add, color: AppColors.blackColor),
      ),
      location: FloatingActionButtonLocation.endFloat,
    );
  }
}
