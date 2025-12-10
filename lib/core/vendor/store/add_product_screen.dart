import 'dart:io';
import 'dart:developer';

import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_drop_down.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:bee_kind/widgets/dialogs/discount_dialog.dart';
import 'package:bee_kind/widgets/image_picking_container.dart';
import 'package:bee_kind/widgets/dialogs/show_loading_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.isEdit, this.productId});
  final bool? isEdit;
  final String? productId;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<File> selectedImages = [];
  List<String> networkImages = [];

  /// Text Controllers
  final productNameController = TextEditingController();
  final categoryIdController = TextEditingController();
  final quantityController = TextEditingController();
  final dosageController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  final effectsController = TextEditingController();
  final ingredientsController = TextEditingController();
  final descriptionController = TextEditingController();

  final network = Network();
  final baseController = Get.find<BaseViewController>();

  bool isLoading = false;
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // If editing, populate form fields from the currently loaded product
    if (widget.isEdit ?? false) {
      _populateFormWithProductData();
    }
  }

  void _populateFormWithProductData() {
    final storeController = Get.find<StoreController>();
    final product = storeController.singleProduct.value?.data;

    if (product != null) {
      productNameController.text = product.productName ?? '';
      selectedCategoryId = product.categoryId;
      quantityController.text = (product.quantity ?? '').toString();
      dosageController.text = product.dosage ?? '';
      priceController.text = (product.price ?? '').toString();
      discountPriceController.text = (product.afterDiscountPrice ?? '')
          .toString();
      effectsController.text = product.effects ?? '';
      ingredientsController.text = product.ingredients ?? '';
      descriptionController.text = product.description ?? '';
      // Set initial network images if present
      if (product.productImages != null) {
        networkImages = List<String>.from(product.productImages!);
      }
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    categoryIdController.dispose();
    quantityController.dispose();
    dosageController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    effectsController.dispose();
    ingredientsController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> addProduct() async {
    // Validation
    if (productNameController.text.isEmpty) {
      AppDialogs.showToast("Please enter product name");
      return;
    }
    if (selectedCategoryId == null || selectedCategoryId!.isEmpty) {
      AppDialogs.showToast("Please select a category");
      return;
    }
    if (quantityController.text.isEmpty) {
      AppDialogs.showToast("Please enter quantity");
      return;
    }
    if (priceController.text.isEmpty) {
      AppDialogs.showToast("Please enter price");
      return;
    }
    if (dosageController.text.isEmpty) {
      AppDialogs.showToast("Please enter dosage");
      return;
    }
    // Discount is optional; mark availability based on whether a value was provided
    if (effectsController.text.isEmpty) {
      AppDialogs.showToast("Please enter effects");
      return;
    }
    if (ingredientsController.text.isEmpty) {
      AppDialogs.showToast("Please enter ingredients");
      return;
    }
    if (descriptionController.text.isEmpty) {
      AppDialogs.showToast("Please enter description");
      return;
    }
    if (selectedImages.isEmpty && networkImages.isEmpty) {
      AppDialogs.showToast("Please select at least one image");
      return;
    }

    try {
      setState(() => isLoading = true);
      showLoadingDialog(context);

      // Build FormData
      final formData = dio.FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry('productName', productNameController.text.trim()),
        MapEntry('categoryId', selectedCategoryId ?? ''),
        MapEntry('quantity', quantityController.text.trim()),
        MapEntry('dosage', dosageController.text.trim()),
        MapEntry('price', priceController.text.trim()),
        MapEntry('afterDiscountPrice', discountPriceController.text.trim()),
        MapEntry('effects', effectsController.text.trim()),
        MapEntry('ingredients', ingredientsController.text.trim()),
        MapEntry('description', descriptionController.text.trim()),
      ]);

      // Add images
      for (final image in selectedImages) {
        formData.files.add(
          MapEntry(
            'productImages',
            await dio.MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }
      // Add network image URLs as a field (if needed by backend)
      if (networkImages.isNotEmpty) {
        for (final url in networkImages) {
          formData.fields.add(MapEntry('existingImages', url));
        }
      }

      log("Add Product FormData: ${formData.fields}");
      log("Add Product Images Count: ${selectedImages.length}");

      // API Call - Use PATCH for update, POST for add
      final isEdit = widget.isEdit ?? false;
      final response = isEdit
          ? await network.patchRequest(
              endPoint: "${NetworkStrings.updateProduct}/${widget.productId}",
              data: formData,
              isHeaderRequire: true,
            )
          : await network.postRequest(
              endPoint: NetworkStrings.addProduct,
              data: formData,
              isHeaderRequire: true,
            );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (response == null) {
        AppDialogs.showToast("Failed to add product");
        setState(() => isLoading = false);
        return;
      }

      final data = response.data;
      log("Add Product Response: $data");

      if (response.statusCode == 200 && data["status"] == true) {
        AppDialogs.showToast(data["message"] ?? "Product added successfully");


        setState(() => isLoading = false);

        // Clear form
        productNameController.clear();
        categoryIdController.clear();
        quantityController.clear();
        dosageController.clear();
        priceController.clear();
        discountPriceController.clear();
        effectsController.clear();
        ingredientsController.clear();
        descriptionController.clear();
        selectedImages.clear();
        selectedCategoryId = null;

        // Pop back
        Navigator.pop(context);
          Get.find<StoreController>().getVendorProducts();
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to add product");
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      log("Add Product Exception: $e");
      AppDialogs.showToast("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: (widget.isEdit ?? false) ? "Edit Products" : "Add Products",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomButton(
          onTap: isLoading ? null : addProduct,
          text: (widget.isEdit ?? false) ? "Edit Product" : "Add Product",
        ),
      ),
      body: Form(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                DottedBorderImagePicker(
                  maxImages: 3,
                  initialNetworkImages: networkImages,
                  onImagesSelected: (images, networkImgs) {
                    setState(() {
                      selectedImages = images;
                      networkImages = networkImgs;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hint: "Product Name",
                  controller: productNameController,
                ),
                SizedBox(height: 10.h),
                CustomDropdown(
                  items:
                      baseController.categories.value?.data
                          ?.map((cat) => cat.categoryName ?? "")
                          .toList() ??
                      [],
                  hintText: "Product Category",
                  onChanged: (value) {
                    final selectedCat = baseController.categories.value?.data
                        ?.firstWhere(
                          (cat) => cat.categoryName == value,
                          orElse: () =>
                              baseController.categories.value!.data![0],
                        );
                    selectedCategoryId = selectedCat?.sId;
                    log("Selected Category ID: $selectedCategoryId");
                  },
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hint: "Product Quantity",
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Dosage", controller: dosageController),
                SizedBox(height: 10.h),
                CustomTextField(
                  hint: "Special Offer / Discount",
                  controller: discountPriceController,
                  keyboardType: TextInputType.number,
                ),
                if (widget.isEdit ?? false)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: GestureDetector(
                      onTap: () => showDiscountDialog(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.add_circle, color: AppColors.yellow2),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: "Add Discounted Price",
                            fontSize: 18.sp,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(height: 10.h),
                CustomTextField(
                  hint: "Product Cost",
                  controller: priceController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10.h),
                CustomTextField(hint: "Effects", controller: effectsController),
                SizedBox(height: 10.h),
                CustomTextField(
                  hint: "Ingredients",
                  controller: ingredientsController,
                  maxlines: 4,
                  radius: 10.r,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hint: "Description",
                  controller: descriptionController,
                  maxlines: 4,
                  radius: 10.r,
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
