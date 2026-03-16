import 'dart:developer';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/core/user/store/ratings_and_reviews.dart';
import 'package:bee_kind/models/data_models/create_order_data_model.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/bottom_sheets/show_options_bottom_sheet.dart';
import 'package:bee_kind/widgets/bottom_sheets/show_stock_bottom_sheet.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/review_card.dart';
import 'package:bee_kind/widgets/sliding_toggle_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../services/shared_prefs_services.dart';
import '../../../utils/app_dialogs.dart' show AppDialogs;

class SelectedProduct extends StatefulWidget {
  const SelectedProduct({
    super.key,
    this.isVendor = false,
    this.hasDiscount = false,
    this.productName,
    this.ingredients,
    this.effets,
    this.dosage,
    this.description,
    this.inventoryStatus,
    this.price,
    this.quantity,
    this.isAvailable = false,
    this.afterDiscountPrice,
    this.productImages,
    this.productId,
  });

  final bool isVendor;
  final bool hasDiscount;
  final bool isAvailable;

  final String? productName;
  final String? ingredients;
  final String? effets;
  final String? dosage;
  final String? description;
  final String? inventoryStatus;
  final dynamic price;
  final dynamic? afterDiscountPrice;
  final int? quantity;
  final List<String>? productImages;
  final String? productId;

  @override
  State<SelectedProduct> createState() => _SelectedProductState();
}

class _SelectedProductState extends State<SelectedProduct>
    with WidgetsBindingObserver {
  final controller = Get.find<StoreController>();
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      _hasFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchProductData();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh product data when app resumes to get latest availability status
    if (state == AppLifecycleState.resumed) {
      _fetchProductData();
    }
  }

  Future<void> _fetchProductData() async {
    log("product id: ${widget.productId}");

    if (widget.productId != null) {
      if (widget.isVendor) {
        log("Fetching vendor product details for ID: ${widget.productId}");
        await controller.fetchVendorProduct(
          widget.productId,
          context,
          navigate: false,
        );
        await controller.fetchProductReviews(widget.productId, context);
        // Fetch vendor-specific reviews
        log("Fetching vendor reviews for product ID: ${widget.productId}");
        await controller.fetchVendorProductReviews(widget.productId, context);
      } else {
        log("Fetching user product details for ID: ${widget.productId}");
        await controller.fetchSingleProduct(
          widget.productId,
          context,
          navigate: false,
        );
        await controller.fetchProductReviews(widget.productId, context);
      }

      // Debug: Check if reviews are loaded
      log("Reviews list after fetch: ${controller.reviewsList?.length ?? 0}");
      log(
        "Product reviews model: ${controller.productReviews.value?.toJson()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(30.w, 350.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                /// ---------------- CAROUSEL ----------------
                Column(
                  children: [
                    Obx(() {
                      final sp = controller.singleProduct.value?.data;
                      final images =
                          (sp?.productImages != null &&
                              sp!.productImages!.isNotEmpty)
                          ? sp.productImages!
                          : (widget.productImages ?? []);

                      return CarouselSlider(
                        items: (images.isNotEmpty)
                            ? images.map((imgUrl) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(imgUrl),
                                      onError: (_, __) {},
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                // FALLBACK IF NO IMAGES
                                Container(
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(AssetsPath.product),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                        options: CarouselOptions(
                          height: 290.h,
                          autoPlay: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) =>
                              controller.updateCarouselIndex(index),
                        ),
                      );
                    }),
                  ],
                ),

                /// ---------------- OBX CAROUSEL INDICATORS ----------------
                Positioned(
                  top: 270.h,
                  left: 170.w,
                  child: Obx(() {
                    final sp = controller.singleProduct.value?.data;
                    final count =
                        (sp?.productImages != null &&
                            sp!.productImages!.isNotEmpty)
                        ? sp.productImages!.length
                        : (widget.productImages?.length ?? 1);

                    return Row(
                      children: List.generate(count, (index) {
                        bool isSelected =
                            controller.currentCarouselIndex.value == index;

                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: isSelected ? 50.w : 8.w,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.blackColor,
                              width: 2.w,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                            color: AppColors.whiteColor,
                          ),
                        );
                      }),
                    );
                  }),
                ),

                /// ---------------- BACK + OPTIONS ----------------
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 70.h,
                    bottom: 20.h,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 150.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 30.r,
                            color: AppColors.whiteColor,
                          ),
                        ),

                        widget.isVendor
                            ? GestureDetector(
                                onTap: () => showOptionsBottomSheet(
                                  context,
                                  productId: widget.productId,
                                ),
                                child: Icon(
                                  Icons.more_vert,
                                  size: 30.r,
                                  color: AppColors.whiteColor,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      /// ---------------- BODY ----------------
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
          child: Column(
            children: [
              /// ---------------- NAME + PRICE ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final sp = controller.singleProduct.value?.data;
                    final name =
                        sp?.productName ?? widget.productName ?? "Lorem Ipsum";
                    final hasDiscount =
                        sp?.isDiscountAvailable ?? widget.hasDiscount;
                    final afterPrice =
                        sp?.afterDiscountPrice ?? widget.afterDiscountPrice;
                    final price = sp?.price ?? widget.price ?? 0;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: name,
                          fontSize: 22.sp,
                          weight: FontWeight.bold,
                        ),
                        hasDiscount
                            ? Row(
                                children: [
                                  CustomText(
                                    text: "\$${afterPrice ?? 0}",
                                    fontSize: 20.sp,
                                    weight: FontWeight.bold,
                                  ),
                                  SizedBox(width: 10.w),
                                  CustomText(
                                    text: "\$${price}",
                                    lineThrough: true,
                                    fontSize: 20.sp,
                                    fontColor: AppColors.yellow2,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              )
                            : CustomText(
                                text: "\$${price}",
                                fontSize: 20.sp,
                                fontColor: AppColors.yellow2,
                                weight: FontWeight.bold,
                              ),
                      ],
                    );
                  }),
                ],
              ),

              SizedBox(height: 10.h),

              /// ---------------- STOCK & REVIEWS ----------------
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final avgRating;
                        final totalReviews;
                        if(widget.isVendor){
                          avgRating = controller.vendorRating.value;
                          totalReviews = controller.VendorReviews.value;
                        }
                        else{
                          avgRating = controller.averageRating  .value;
                          totalReviews = controller.totalReviews.value;
                        }

                        return Row(
                          children: [
                            Image.asset(AssetsPath.star, width: 18.w),
                            SizedBox(width: 10.w),
                            CustomText(
                              text:
                                  "${avgRating.toStringAsFixed(1)}   $totalReviews Reviews",
                            ),
                          ],
                        );
                      }),

                      if (!widget.isVendor)
                        Obx(() {
                          final sp = controller.singleProduct.value?.data;
                          return CustomText(
                            text:
                                sp?.inventoryStatus ??
                                widget.inventoryStatus ??
                                "In Stock",
                            weight: FontWeight.bold,
                          );
                        }),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10.h),
                      if (!widget.isVendor)
                        Obx(() {
                          final sp = controller.singleProduct.value?.data;
                          final inventoryStatus =
                              (sp?.inventoryStatus ??
                                      widget.inventoryStatus ??
                                      "In Stock")
                                  .toString()
                                  .toLowerCase();

                          final qty = sp?.quantity ?? widget.quantity ?? 0;

                          // Treat as out of stock if status indicates it OR quantity is zero
                          final isOutOfStock =
                              inventoryStatus.contains('out') ||
                              inventoryStatus.contains('sold') ||
                              qty <= 0;

                          if (!isOutOfStock) {
                            return CustomText(text: "${qty} products left");
                          }
                          return SizedBox.shrink();
                        }),
                    ],
                  ),
                ],
              ),

              /// ---------------- VENDOR ONLY: STOCK DROPDOWN ----------------
              if (widget.isVendor) ...[
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 230.w,
                      onTap: () async {
                        final selected = await showStockBottomSheet(
                          context,
                          controller.selectedStockStatus.value,
                          controller.inventoryOptions,
                        );

                        // Call API to update inventory status if selection changed
                        if (selected != controller.selectedStockStatus.value &&
                            widget.productId != null) {
                          controller.selectedStockStatus.value = selected;
                          await controller.updateVendorInventoryStatus(
                            widget.productId!,
                            selected,
                          );
                        } else {
                          controller.selectedStockStatus.value = selected;
                        }
                      },
                      text: "Select Inventory Options",
                    ),
                  ],
                ),
              ],

              SizedBox(height: 20.h),

              /// ---------------- VENDOR ONLY: AVAILABILITY TOGGLE ----------------
              if (widget.isVendor)
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomText(
                        text: controller.isAvailable.value
                            ? "Available"
                            : "Not Available",
                        weight: FontWeight.bold,
                      ),
                      SizedBox(width: 10.w),
                      slidingToggleButton(
                        value: controller.isAvailable.value,
                        onChanged: (v) => controller.setAvailibility(v),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 20.h),

              /// ---------------- DESCRIPTION ----------------
              _sectionTitle("Description"),
              SizedBox(height: 10.h),
              Obx(() {
                final sp = controller.singleProduct.value?.data;
                return _sectionText(sp?.description ?? widget.description);
              }),

              SizedBox(height: 20.h),

              _sectionTitle("Effects"),
              SizedBox(height: 10.h),
              Obx(() {
                final sp = controller.singleProduct.value?.data;
                return _sectionText(sp?.effects ?? widget.effets);
              }),

              SizedBox(height: 20.h),

              _sectionTitle("Ingredients"),
              SizedBox(height: 10.h),
              Obx(() {
                final sp = controller.singleProduct.value?.data;
                return _sectionText(sp?.ingredients ?? widget.ingredients);
              }),

              SizedBox(height: 20.h),

              _sectionTitle("Dosage"),
              SizedBox(height: 10.h),
              Obx(() {
                final sp = controller.singleProduct.value?.data;
                return _sectionText(sp?.dosage ?? widget.dosage);
              }),

              SizedBox(height: 30.h),

              /// ---------------- CUSTOMER ONLY: QUANTITY ----------------
              if (!widget.isVendor)
                Obx(
                  () => Row(
                    children: [
                      CustomText(text: "Quantity", weight: FontWeight.bold),
                      SizedBox(width: 20.w),

                      /// MINUS
                      GestureDetector(
                        onTap: controller.decrementQuantity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: controller.quantityCount > 0
                                ? AppColors.blackColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              bottomLeft: Radius.circular(24.r),
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: controller.quantityCount > 0
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),

                      /// COUNT
                      Container(
                        width: 50.w,
                        alignment: Alignment.center,
                        child: CustomText(
                          text: '${controller.quantityCount}',
                          fontSize: 22.sp,
                          weight: FontWeight.bold,
                        ),
                      ),

                      /// PLUS
                      GestureDetector(
                        onTap: controller.incrementQuantity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.yellow2,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24.r),
                              bottomRight: Radius.circular(24.r),
                            ),
                          ),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 30.h),

              if (!widget.isVendor)
                Obx(() {
                  // Get the real-time isAvailable from singleProduct or use widget.isAvailable as fallback
                  final isProductAvailable =
                      controller.singleProduct.value?.data?.isAvailable ??
                      widget.isAvailable;
                  final inventoryStatus =
                      controller.singleProduct.value?.data?.inventoryStatus ??
                      widget.inventoryStatus ??
                      "In Stock";
                  final canAddToCart =
                      isProductAvailable && controller.quantityCount.value > 0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isProductAvailable)
                        CustomText(
                          text:
                              "This product is currently unavailable. Please check back later.",
                          fontColor: AppColors.errorColor,
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                        )
                      else if (inventoryStatus.toLowerCase().contains("out"))
                        CustomText(
                          text:
                              "Inventory status: $inventoryStatus. You may add to cart once it restocks.",
                          fontColor: AppColors.errorColor,
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 10.h),
                      CustomButton(
                        text: "Add To Cart",
                        gradientColors: canAddToCart
                            ? [AppColors.yellow1, AppColors.yellow2]
                            : [
                                AppColors.whiteColor,
                                AppColors.shimmerHighlightColor,
                              ],
                        onTap: canAddToCart
                            ? () {


                          final prefs = SharedPrefs();

                          prefs.setBool("navigateToMyOrder", false);

                          final sp = controller.singleProduct.value?.data;

                          final qtytocheck = sp?.quantity ?? widget.quantity ?? 0;
                          print("lsskdslkn${sp?.inventoryStatus ??
                              widget.inventoryStatus}");

                          double unitPrice =
                                    (widget.hasDiscount
                                        ? double.tryParse(
                                            widget.afterDiscountPrice
                                                .toString(),
                                          )
                                        : double.tryParse(
                                            widget.price.toString(),
                                          )) ??
                                    0;
                                print("dljfdsfbdlfn${unitPrice}");


                                print("widget.hasDiscount${widget.hasDiscount}");
                                print("widget.afterDiscountPrice.toString()${widget.afterDiscountPrice.toString()}");
                                print("widget.price.toString(),${widget.price.toString()}");
                                int qty = controller.quantityCount.value;

                                print("qtyqty${qty}");
                          print("qtytocheckqtytocheck${qtytocheck}");

                                if(qtytocheck>=qty){


                                  if(sp?.inventoryStatus =="out-of-stock"){
                                    AppDialogs.showToast(
                                      " Product is currently out of stock",
                                    );
                                    return;
                                  }

                                  controller
                                      .addItems(
                                        OrderItem(
                                          productId: widget.productId,
                                          productName: widget.productName,
                                          productImage: widget.productImages?.first,
                                          unitPrice: unitPrice,
                                          quantity: qty,

                                        ),
                                      )
                                      .then((value) {
                                        controller.baseController.changeTab(1);
                                        Get.until((route) => route.isFirst);
                                      });
                                  print("less");
                                }

                                // print("sp?.inventoryStatus${sp?.inventoryStatus}");

                                else{

                                  AppDialogs.showToast(
                                       "Only ${qtytocheck} items are available in stock. Please reduce the quantity to continue.",
                                  );
                                  print("moew");
                                }




                                log(
                                  "Cart total now: ${controller.calculateTotalCartPrice()}",
                                );
                              }
                            : null,
                      ),
                    ],
                  );
                }),

              SizedBox(height: 30.h),




              /// ---------------- REVIEWS ----------------
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CircularProgressIndicator(
                        color: AppColors.yellow2,
                      ),
                    ),
                  );
                }


                // No reviews
                if (controller.reviewsList != null &&
                    controller.reviewsList!.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: CustomText(text: "Reviews Not Available!"),
                  );
                }

                // Reviews available
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(

                          onTap:(){
                            controller.fetchProductReviews(widget.productId, context);
                          },

                          child: CustomText(
                            text: "Rating & Reviews",
                            fontSize: 18.sp,
                            weight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (widget.isVendor) {
                              await controller.fetchProductReviews(widget.productId, context);
                            } else {
                              await controller.fetchProductReviews(widget.productId, context);
                            }

                            final data = controller.productReviews.value?.data;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RatingScreen(
                                  isVendor: widget.isVendor,
                                  avgRating: (data?.averageRating ?? 0).toDouble(),
                                  totalReviews: (data?.totalReviews ?? 0).toDouble(),
                                  reviews: data?.reviews ?? [],
                                ),
                              ),
                            );
                          },
                          child: CustomText(
                            text: "View All",
                            underlined: true,
                            fontSize: 16.sp,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.reviewsList?.length,
                      itemBuilder: (_, index) {
                        final data = controller.reviewsList?[index];
                        log("RATING: ${data?.rating}");
                        return

                          ReviewCard(
                            isVendor: widget.isVendor,
                            reviewId: data?.sId,
                            review: data?.review,
                            ratingCount: data?.rating,
                            userName: data?.user?.fullName,
                            userImage: data?.user?.profileImage,
                            vendorResponses: data?.reply,
                            repliedBy: data?.repliedBy,
                          );
                        //   ReviewCard(
                        //   isVendor: widget.isVendor,
                        //   review: data?.review ?? "",
                        //   userImage: data?.user?.profileImage,
                        //   userName: data?.user?.fullName,
                        //   vendorResponse: data?.reply ?? "",
                        //   ratingCount: data?.rating ?? 0,
                        //   reviewId: data?.sId,
                        //
                        // );
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Row(
    children: [
      CustomText(text: title, fontSize: 22.sp, weight: FontWeight.bold),
    ],
  );

  Widget _sectionText(String? text) => Row(
    children: [
      SizedBox(
        child: CustomText(
          text: text ?? "No information found.",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
