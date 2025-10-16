import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/core/user/store/selected_store.dart';
import 'package:bee_kind/widgets/category_wise_product.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWiseProductsList extends StatelessWidget {
  const CategoryWiseProductsList({
    super.key,
    this.showDistance = true,
    this.homeCategory = true,
  });
  final bool showDistance;
  final bool homeCategory;

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: 'Lorem Ipsum',
      body: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    homeCategory ? StoreScreen() : SelectedProduct(),
              ),
            ),
            child: CategoryWiseProduct(showDistance: showDistance),
          );
        },
      ),
    );
  }
}
