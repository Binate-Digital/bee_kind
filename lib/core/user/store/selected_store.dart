import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/product_categories_list.dart';
import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/models/response_models/get_products_by_category_response_model.dart';
import 'package:bee_kind/models/response_models/store_detail_response_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/categories.dart' as cat;
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StoreScreen extends GetView<StoreController> {
  const StoreScreen({super.key, this.data});

  final StoreDetail? data;

  @override
  Widget build(BuildContext context) {

    print("sdlnnd");
    controller.setStoreData(data);
    // Set initial data if provided
    if (data != null && controller.storeData.value == null) {
      controller.setStoreData(data);
    }

    return Obx(() {
      final storeData = controller.storeData.value ?? data;
      return _buildScaffold(context, storeData);
    });
  }
  Widget _buildScaffold(BuildContext context, StoreDetail? data) {
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
                                text:
                                    data?.store?.businessName ?? "Lorem Ipsum",
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
                                      text:
                                          "${controller.convertTo12HourFormat(data?.store?.openTime ?? "10:00")} to ${controller.convertTo12HourFormat(data?.store?.closeTime ?? "6:00")}",
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
                                      text:
                                          data?.store?.vendorAddress?.address ?? data?.store?.addressName ??
                                          "Address not available",
                                      fontSize: 16.sp,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
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
                                      text:
                                          data?.store?.phoneNumber ??
                                          "No. not available",
                                      fontSize: 17.sp,
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

            /// SEARCH FIELD
            Padding(
              padding: EdgeInsets.only(left: 20.h, right: 20.w, top: 20.h),
              child: CustomTextField(
                hint: "Search",
                bgColor: AppColors.whiteColor,
                bdColor: AppColors.yellow2,
                hintColor: AppColors.blackColor.withValues(alpha: 0.3),
                prefxicon: AssetsPath.search,
                onchange: controller.search,
              ),
            ),
          ],
        ),
      ),

      body: Obx(() {
        if (controller.searchQuery.isNotEmpty) {
          return _buildSearchResults(controller);
        }

        return _buildOriginalBody(context, controller);
      }),
    );
  }

  /// --------------------------------------------
  ///  SEARCH RESULTS VIEW
  /// --------------------------------------------
  Widget _buildSearchResults(StoreController controller) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          if (controller.searchedItems.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: CustomText(
                text: "No products found",
                fontSize: 20.sp,
                weight: FontWeight.w600,
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: GridView.builder(
              itemCount: controller.searchedItems.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 200.h,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 10.w,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final item = controller.searchedItems[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SelectedProduct(
                          productId: item.productId,
                          productName: item.productName,
                          ingredients: item.ingredients,
                          description: item.description,
                          effets: item.effects,
                          price: item.price,
                          afterDiscountPrice: item.afterDiscountPrice,
                          inventoryStatus: item.inventoryStatus,
                          hasDiscount: item.isDiscountAvailable ?? false,
                          isAvailable: item.isAvailable ?? false,
                          quantity: item.quantity,
                          productImages: item.productImages,
                        ),
                      ),
                    );
                  },
                  child: Product(
                    stockStatus: item.inventoryStatus,
                    isDiscountAvailable: item.isDiscountAvailable ?? false,
                    productName: item.productName,
                    price: item.price,
                    afterDiscountPrice: item.afterDiscountPrice,
                    productImages: item.productImages,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------
  ///  ORIGINAL BODY (when no search)
  /// --------------------------------------------
  Widget _buildOriginalBody(BuildContext context, StoreController controller) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),

            /// MOST DEMANDED PRODUCTS
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
            data != null && data!.popularProducts!.isNotEmpty?
            SizedBox(
              height: 195.h,
              child: Align(
                alignment: Alignment.centerLeft,
                child: data != null && data!.popularProducts!.isNotEmpty
                    ? ListView.builder(
                        itemCount: data?.popularProducts?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final p = data!.popularProducts?[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SelectedProduct(
                                      productImages: p?.productImages,
                                      productId: p?.sId,
                                      productName: p?.productName,
                                      ingredients: p?.ingredients,
                                      description: p?.description,
                                      effets: p?.effects,
                                      price: p?.price,
                                      afterDiscountPrice: p?.afterDiscountPrice,
                                      inventoryStatus: p?.inventoryStatus,
                                      hasDiscount:
                                          p?.isDiscountAvailable ?? false,
                                      isAvailable: p?.isAvailable ?? false,
                                      quantity: p?.quantity,
                                    ),
                                  ),
                                );
                              },
                              child: Product(
                                stockStatus: p?.inventoryStatus,
                                isDiscountAvailable:
                                    p?.isDiscountAvailable ?? false,
                                productName: p?.productName,
                                price: p?.price,
                                afterDiscountPrice: p?.afterDiscountPrice,
                                productImages: p?.productImages,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CustomText(text: "Products Not Available!"),
                      ),
              ),
            ):Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                child: Center(
                  child: CustomText(text: "Products Not Available!"),
                ),
              ),
            ),

            SizedBox(height: 30.h),

            /// CATEGORIES
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

            if (data != null && data!.categories!.isNotEmpty)
              SizedBox(
                height: 150.h,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    itemCount: data?.categories?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = data?.categories?[index];
                      return GestureDetector(
                        onTap: () {
                          // Filter current store's products by this category
                          final categoryProducts =
                              data?.products
                                  ?.where(
                                    (p) => p.categoryId?.sId == category?.sId,
                                  )
                                  .toList() ??
                              [];

                          // Convert Products to ProductByCategoryData for the list screen
                          final convertedProducts = categoryProducts
                              .map(
                                (p) => ProductByCategoryData(
                                  sId: p.sId,
                                  productImages: p.productImages,
                                  productName: p.productName,
                                  categoryId: p.categoryId?.sId,
                                  quantity: p.quantity,
                                  price: p.price,
                                  afterDiscountPrice: p.afterDiscountPrice,
                                  isDiscountAvailable: p.isDiscountAvailable,
                                  effects: p.effects,
                                  ingredients: p.ingredients,
                                  description: p.description,
                                  user: p.user,
                                  isDeleted: p.isDeleted,
                                  isAvailable: p.isAvailable,
                                  inventoryStatus: p.inventoryStatus,
                                  createdAt: p.createdAt,
                                  updatedAt: p.updatedAt,
                                  iV: p.iV,
                                  businessName: data?.store?.businessName,
                                  businessId: data?.store?.sId,
                                ),
                              )
                              .toList();

                          // Navigate to category products list with filtered products
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryWiseProductsList(
                                fromHome: false,
                                products: convertedProducts,
                                categoryName: category?.categoryName,
                              ),
                            ),
                          );
                        },
                        child: cat.Categories(
                          image: data?.categories?[index].categoryImage,
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Center(child: CustomText(text: "Products Not Available!")),

            /// PRODUCTS GRID
            GridView.builder(
              itemCount: data?.products?.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 200.h,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 10.w,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final p = data!.products?[index];

                // print("ldfndln${data!.products?[index].productImages}");
                return GestureDetector(
                  onTap: () {
                    print("ldfndln${data!.products?[index].productImages}");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SelectedProduct(
                          productId: p?.sId,
                          productName: p?.productName,
                          ingredients: p?.ingredients,
                          description: p?.description,
                          effets: p?.effects,
                          price: p?.price,
                          afterDiscountPrice: p?.afterDiscountPrice,
                          inventoryStatus: p?.inventoryStatus,
                          hasDiscount: p?.isDiscountAvailable ?? false,
                          isAvailable: p?.isAvailable ?? false,
                          quantity: p?.quantity,
                          productImages: p?.productImages,
                        ),
                      ),
                    );
                  },
                  child: Product(
                    stockStatus: p?.inventoryStatus,
                    isDiscountAvailable: p?.isDiscountAvailable ?? false,
                    productName: p?.productName,
                    price: p?.price,
                    afterDiscountPrice: p?.afterDiscountPrice,
                    productImages: p?.productImages,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
