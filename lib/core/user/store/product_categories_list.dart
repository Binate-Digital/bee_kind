import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/models/response_models/get_products_by_category_response_model.dart';
import 'package:bee_kind/widgets/category_wise_product.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryWiseProductsList extends StatelessWidget {
  const CategoryWiseProductsList({
    super.key,
    this.fromHome = false,
    this.products,
    this.categoryName,
  });

  final List<ProductByCategoryData>? products;

  final String? categoryName;

  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();
    return AppBarBaseView(
      title: categoryName ?? 'Lorem Ipsum',
      body: ListView.builder(
        itemCount: products?.length ?? 0,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => fromHome
                ? controller.fetchStoreDetail(
                    products?[index].businessId,
                    context,
                  )
                : controller.fetchSingleProduct(products?[index].sId, context),
            child: CategoryWiseProduct(
              fromHome: fromHome,
              product: products?[index],
            ),
          );
        },
      ),
    );
  }
}
