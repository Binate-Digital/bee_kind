import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/core/vendor/store/add_product_screen.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  bool isVendor = false;
  late final controller = Get.find<StoreController>();

  final prefs = SharedPrefs();

  @override
  void initState() {
    isVendor = prefs.getString("role") == "vendor";
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getVendorProducts(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "My Products",
      body: Obx(() {
        final products = controller.vendorProducts.value?.data;

        if (products == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (products.isEmpty) {
          return Center(
            child: CustomText(text: "No products found", fontSize: 16.sp),
          );
        }

        return ListView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemBuilder: (context, index) {
            final p = products[index];

            final imageUrl =
                (p.productImages != null && p.productImages!.isNotEmpty)
                ? p.productImages!.first
                : null;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectedProduct(
                      isVendor: isVendor,
                      hasDiscount: p.isDiscountAvailable ?? false,
                      productName: p.productName,
                      description: p.description,
                      effets: p.effects,
                      ingredients: p.ingredients,
                      dosage: p.dosage,
                      price: p.price,
                      afterDiscountPrice: p.afterDiscountPrice,
                      quantity: p.quantity,
                      productImages: p.productImages,
                      isAvailable: p.isAvailable ?? false,
                      inventoryStatus: p.inventoryStatus,
                      productId: p.sId,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                margin: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.15),
                      blurRadius: 25.r,
                      offset: const Offset(0, 5),
                      spreadRadius: 0,
                    ),
                  ],
                  color: AppColors.whiteColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.yellow2,
                          width: 1.w,
                        ),
                        color: AppColors.whiteColor,
                        image: DecorationImage(
                          image: imageUrl != null
                              ? NetworkImage(imageUrl) as ImageProvider
                              : AssetImage(AssetsPath.product),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: p.productName ?? "Untitled",
                            fontSize: 18.sp,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: 6.h),
                          SizedBox(
                            width: double.infinity,
                            child: CustomText(
                              text: p.description ?? "",
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (p.isDiscountAvailable == true &&
                                p.afterDiscountPrice != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: "\$${p.afterDiscountPrice}",
                                    fontSize: 16.sp,
                                    weight: FontWeight.bold,
                                  ),
                                  SizedBox(height: 6.h),
                                  CustomText(
                                    text: "\$${p.price}",
                                    lineThrough: true,
                                    fontSize: 14.sp,
                                    fontColor: AppColors.yellow2,
                                  ),
                                ],
                              )
                            : CustomText(
                                text: "\$${p.price ?? 0}",
                                fontSize: 18.sp,
                                fontColor: AppColors.yellow2,
                                weight: FontWeight.bold,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
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
