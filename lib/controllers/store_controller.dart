import 'dart:convert';
import 'dart:developer';
import 'package:bee_kind/common/get_all_cards_bloc.dart';
import 'package:bee_kind/controllers/base_view_controller.dart';
import 'package:bee_kind/core/user/store/product_categories_list.dart';
import 'package:bee_kind/core/user/store/selected_product.dart';
import 'package:bee_kind/core/user/store/selected_store.dart';
import 'package:bee_kind/models/data_models/create_order_data_model.dart';
import 'package:bee_kind/models/response_models/address_response_model.dart';
import 'package:bee_kind/models/response_models/card_response_model.dart';
import 'package:bee_kind/models/response_models/get_products_by_category_response_model.dart';
import 'package:bee_kind/models/response_models/orders_response_model.dart'
    as order;
import 'package:bee_kind/models/response_models/product_reviews_response_model.dart';
import 'package:bee_kind/models/data_models/search_result_model.dart';
import 'package:bee_kind/models/response_models/single_product_response_model.dart'
    hide Reviews;
import 'package:bee_kind/models/response_models/store_detail_response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:bee_kind/widgets/dialogs/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StoreController extends GetxController {
  RxString searchQuery = "".obs;

  final baseController = Get.put(BaseViewController());

  RxList<order.OrderData> completedOrdersList = <order.OrderData>[].obs;

  RxBool isLoading = false.obs;

  final prefs = SharedPrefs();

  RxList<OrderItem>? orderItems = <OrderItem>[].obs;

  Rxn<SingleProductResponseModel> singleProduct =
      Rxn<SingleProductResponseModel>();

  Rxn<AddressResponseModel> userAddresses = Rxn<AddressResponseModel>();

  List<Products> allProducts = [];
  List<PopularProducts> allPopularProducts = [];

  final notesController = TextEditingController();

  final Rxn<StoreDetailResponseModel> storeDetail =
      Rxn<StoreDetailResponseModel>();

  RxList<SearchResultItem> searchedItems = <SearchResultItem>[].obs;

  Rxn<ProductReviewsResponseModel> productReviews =
      Rxn<ProductReviewsResponseModel>();

  // DIRECT ACCESS TO LIST OF REVIEWS
  RxList<Reviews>? reviewsList = <Reviews>[].obs;

  RxBool isFetchingOrders = false.obs;
  RxList<order.OrderData> ordersList = <order.OrderData>[].obs;

  // SUMMARY DATA
  RxInt averageRating = 0.obs;
  RxInt totalReviews = 0.obs;

  RxInt quantityCount = 0.obs;

  RxString selectedStockStatus = "In Stock".obs;
  List<String> inventoryOptions = ["In Stock", "Low Stock", "Out Of Stock"];

  RxBool isAvailable = true.obs;

  RxInt currentCarouselIndex = 0.obs;

  final network = Network();

  final Rxn<StoreDetail> storeData = Rxn<StoreDetail>();

  RxBool isFetchingCards = false.obs;
  RxList<CardModel> cardList = <CardModel>[].obs;

  // SELECTED PAYMENT METHOD
  RxString selectedPaymentMethod = "".obs;

  // STORE ID
  RxString selectedStoreId = "".obs;
  // (Set this at store selection time)

  // DELIVERY CHARGES (constant for now)
  final double deliveryCharges = 20.0;

  // CREATE ORDER LOADING STATE
  RxBool isCreatingOrder = false.obs;

  Rxn<GetProductsByCategoriesResponseModel> productsByCategory =
      Rxn<GetProductsByCategoriesResponseModel>();

  RxInt selectedAddressIndex = (-1).obs;
  Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();

  Future<void> setDefaultCard(BuildContext context, String cardId) async {
    try {
      AppDialogs.progressAlertDialog(context: context);

      final response = await network.postRequest(
        endPoint: NetworkStrings.setDefaultCard,
        data: {"paymentMethodId": cardId},
        isHeaderRequire: true,
      );

      Navigator.pop(context);

      if (response == null) {
        AppDialogs.showToast("Unable to set default card");
        return;
      }

      final data = response.data;

      if (data["status"] == true) {
        AppDialogs.showToast("Default card updated");

        for (var c in cardList) {
          c.isDefault = false;
        }

        final selectedCard = cardList.firstWhereOrNull((c) => c.id == cardId);

        if (selectedCard != null) {
          selectedCard.isDefault = true;
        }

        selectedPaymentMethod.value = cardId;

        prefs.setString("cardId", cardId);

        // 🔄 reload cards from API to sync fully
        await loadCards(context);
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to set default card");
      }
    } catch (e) {
      Navigator.pop(context);
      AppDialogs.showToast("Something went wrong");
    }
  }

  Future<void> deleteCard(BuildContext context, String cardId) async {
    try {
      AppDialogs.progressAlertDialog(context: context);

      final response = await network.deleteRequest(
        endPoint: "${NetworkStrings.deleteCard}/$cardId",
        isHeaderRequire: true,
      );

      Navigator.pop(context); // Close loader

      if (response == null) {
        AppDialogs.showToast("Unable to delete card");
        return;
      }

      final data = response.data;

      if (data["status"] == true) {
        cardList.removeWhere((c) => c.id == cardId);
        AppDialogs.showToast("Card deleted successfully");

        // Refresh card list immediately
        await loadCards(context);
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to delete card");
      }
    } catch (e) {
      Navigator.pop(context);
      AppDialogs.showToast("Something went wrong deleting card");
    }
  }

  Future<void> cancelOrder({
    required dynamic orderId,
    required dynamic reason,
    required dynamic description,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        "orderId": orderId.toString(),
        "reason": reason.toString(),
        "description": description.toString(),
      };

      log("BODY FOR ORDER CANCEL: $body");

      final response = await network.patchRequest(
        endPoint: NetworkStrings.cancelOrder,
        data: body,
        isHeaderRequire: true,
        isToast: false,
      );

      final data = response!.data;

      if (data["status"] == true) {
        AppDialogs.showToast("Order cancelled successfully");
        isLoading.value = false;
        Navigator.pop(context);
        Navigator.pop(context);
        fetchOrdersByStatus("pending");
      } else {
        log(data["message"] ?? "Cancellation failed");
      }
    } catch (e) {
      isLoading.value = false;
      Navigator.pop(context);
      AppDialogs.showToast("Something went wrong while cancelling order.");
      log("ERROR CANCEL ORDER: $e");
    }
  }

  Future<void> fetchOrdersByStatus(String status) async {
    try {
      isFetchingOrders.value = true;

      final response = await network.getRequest(
        endPoint: NetworkStrings.fetchOrders,
        isHeaderRequire: true,
        isToast: false,
        queryParameters: {"status": status},
      );

      isFetchingOrders.value = false;

      if (response == null) {
        AppDialogs.showToast("Unable to load orders");
        ordersList.clear();
        return;
      }

      final data = response.data;

      if (data["status"] == true && data["data"] != null) {
        final model = order.OrdersResponseModel.fromJson(data);

        ordersList.assignAll(model.data ?? []);
      } else {
        ordersList.clear();
        AppDialogs.showToast(data["message"] ?? "Failed to fetch orders");
      }
    } catch (e) {
      isFetchingOrders.value = false;
      ordersList.clear();
      AppDialogs.showToast("Something went wrong fetching orders");
    }
  }

  void selectAddress(int index) async {
    selectedAddressIndex.value = index;

    final selected = userAddresses.value?.data?[index];
    selectedAddress.value = selected;

    prefs.setString("address", selected?.address ?? "");
    if (selected?.id != null) {
      await setDefaultAddress(selected!.id.toString());
    }
  }

  Future<void> loadCards(BuildContext context) async {
    try {
      isFetchingCards.value = true;

      await GetCardBloc().getAllCards(
        context: context,
        setProgressBar: () {},
        onCardsLoaded: (model) {
          final cards = model.data?.cards ?? [];

          cardList.assignAll(cards);

          // PICK DEFAULT CARD SAFELY
          final defaultCard = cards.firstWhere(
            (c) => c.isDefault == true,
            orElse: () => cards.isNotEmpty ? cards.first : CardModel(),
          );

          selectedPaymentMethod.value = defaultCard.id ?? "";

          prefs.setString("cardId", defaultCard.toString());
        },
      );
    } catch (e) {
      log("error loading cards: $e");
    } finally {
      isFetchingCards.value = false;
    }
  }

  Future<void> createOrder(BuildContext context, double totalPrice) async {
    try {
      if (selectedPaymentMethod.value.isEmpty) {
        AppDialogs.showToast("Please select a payment method");
        return;
      }

      if (selectedAddress.value == null) {
        AppDialogs.showToast("Please select a delivery address");
        return;
      }

      isCreatingOrder.value = true;

      // Build user address model
      final addr = selectedAddress.value!;

      UserAddress userAddress = UserAddress(
        type: addr.type,
        coordinates: addr.coordinates ?? [],
        address: addr.address,
        floorNumber: addr.floorNumber,
        apartmentNumber: addr.apartmentNumber,
        suiteNumber: addr.suiteNumber,
        isDefault: addr.isDefault,
      );

      // Build order items
      List<OrderItem> items = orderItems != null ? orderItems!.toList() : [];

      log("store id when creating order: ${prefs.getString("storeId")}");

      // Build final order model
      CreateOrderDataModel order = CreateOrderDataModel(
        storeId: prefs.getString("storeId"),
        items: items,
        additionalNotes: notesController.text.trim(),
        userAddress: userAddress,
        totalAmount: totalPrice,
        deliveryCharges: deliveryCharges,
        paymentMethodId: prefs.getString("cardId"),
      );

      final body = order.toJson();
      log("CREATE ORDER BODY => ${jsonEncode(body)}");

      // API CALL
      final response = await network.postRequest(
        endPoint: NetworkStrings.createOrder,
        data: body,
        isHeaderRequire: true,
      );

      isCreatingOrder.value = false;

      if (response == null) {
        AppDialogs.showToast("Unable to place order");
        return;
      }

      if (response.data["status"] == true) {
        AppDialogs.showToast("Order placed successfully!");

        // Clear cart
        orderItems!.clear();
        saveCartToPrefs(prefs.getUserId().toString());

        // Navigate success screen
        // successfulOrderDialog(context);
        Get.back();
        Get.back();
      } else {
        AppDialogs.showToast(response.data["message"] ?? "Order failed");
      }
    } catch (e) {
      isCreatingOrder.value = false;
      log("CreateOrder Error: $e");
      AppDialogs.showToast("Something went wrong");
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((value) async {
      await loadCartFromPrefs(prefs.getUserId().toString());
      await fetchUserAddresses();
    });
    super.onInit();
  }

  Future<void> fetchUserAddresses() async {
    try {
      isLoading.value = true;

      final response = await network.getRequest(
        endPoint: NetworkStrings.getAddresses,
        isHeaderRequire: true,
        isToast: false,
      );

      isLoading.value = false;

      if (response == null) {
        AppDialogs.showToast("Unable to fetch addresses");
        return;
      }

      final data = response.data;

      if (data["status"] == true && data["data"] != null) {
        userAddresses.value = AddressResponseModel.fromJson(data);

        final list = userAddresses.value?.data ?? [];

        int defaultIndex = list.indexWhere((a) => a.isDefault == true);

        if (defaultIndex != -1) {
          selectAddress(defaultIndex);
        } else if (list.isNotEmpty) {
          // if none is default → set first as default via API
          await setDefaultAddress(list.first.id.toString());
        }

        log("Addresses Loaded: ${list.length}");
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to load addresses.");
      }
    } catch (e) {
      isLoading.value = false;
      log("fetchUserAddresses Exception: $e");
      AppDialogs.showToast("Error while loading addresses");
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    try {
      final response = await network.postRequest(
        endPoint: NetworkStrings.setDefaultAddress,
        data: {"addressId": addressId},
        isHeaderRequire: true,
      );

      if (response == null) {
        AppDialogs.showToast("Unable to update default address");
        return;
      }

      final data = response.data;

      if (data["status"] == true) {
        log("Default address updated");

        // update UI
        // await fetchUserAddresses();
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to set default");
      }
    } catch (e) {
      AppDialogs.showToast("Something went wrong updating default address");
      log("setDefaultAddress Error: $e");
    }
  }

  Future<void> addItems(OrderItem? item) async {
    if (item == null) return;

    // Ensure cart exists
    orderItems ??= <OrderItem>[].obs;

    final String? id = item.productId;
    final int qty = item.quantity ?? 0;
    final double unitPrice = item.unitPrice ?? 0;

    if (id == null || qty <= 0 || unitPrice <= 0) {
      AppDialogs.showToast("Invalid product information");
      return;
    }

    // Per-item total (the only price we store)
    final double itemTotal = unitPrice * qty;

    // Check if item is already in cart
    int index = orderItems!.indexWhere((e) => e.productId == id);

    if (index != -1) {
      // Update existing
      final existing = orderItems![index];

      orderItems![index] = OrderItem(
        productId: existing.productId,
        productName: existing.productName,
        productImage: existing.productImage,
        quantity: qty,
        unitPrice: itemTotal, // ONLY item total
      );

      log("ITEM UPDATED: ${orderItems![index].toJson()}");
    } else {
      // Add new
      orderItems!.add(
        OrderItem(
          productId: item.productId,
          productName: item.productName,
          productImage: item.productImage,
          quantity: qty,
          unitPrice: itemTotal, // ONLY item total
        ),
      );

      log("NEW ITEM ADDED: ${item.toJson()}");
    }

    // Debug: Calculate cart total (NOT stored in items)
    final double cartTotal = calculateTotalCartPrice();
    log("CART TOTAL NOW: $cartTotal");

    // Save updated cart
    await saveCartToPrefs(prefs.getUserId().toString());

    quantityCount.value = 1;

    log("FULL CART: ${orderItems!.map((e) => e.toJson()).toList()}");
  }

  void removeItem(String productId) async {
    if (orderItems == null) return;

    // Remove item
    orderItems!.removeWhere((item) => item.productId == productId);

    // If list becomes empty → reset cart
    if (orderItems!.isEmpty) {
      orderItems = <OrderItem>[].obs;
    }

    // Save updated cart
    await saveCartToPrefs(prefs.getUserId().toString());

    log("Item removed => $productId");
    log("Updated Cart => ${orderItems!.map((e) => e.toJson()).toList()}");
  }

  Future<void> loadCartFromPrefs(String userId) async {
    final stored = prefs.getString(userId);

    if (stored == null || stored.isEmpty) {
      orderItems = <OrderItem>[].obs;
      log("No saved cart for user: $userId");
      return;
    }

    try {
      final List decoded = jsonDecode(stored);
      orderItems = decoded.map((e) => OrderItem.fromJson(e)).toList().obs;
      log("Cart loaded => $decoded");
    } catch (e) {
      orderItems = <OrderItem>[].obs;
      log("Error loading cart: $e");
    }
  }

  double calculateTotalCartPrice() {
    if (orderItems == null) return 0.0;

    return orderItems!.fold(0.0, (sum, item) {
      double price = item.unitPrice ?? 0.0;
      return sum + price;
    });
  }

  Future<void> saveCartToPrefs(String userId) async {
    if (orderItems == null) return;

    final cartJson = orderItems!.map((e) => e.toJson()).toList();

    await prefs.setString(userId, jsonEncode(cartJson));

    log("Cart saved for user $userId => $cartJson");
    log("Cart from prefs => ${prefs.getString(userId)}");
  }

  void setStoreData(StoreDetail? store) {
    allProducts = store?.products ?? [];
    allPopularProducts = store?.popularProducts ?? [];
    prefs.setString("storeId", store?.store?.sId.toString() ?? "");
    log("STORE ID: ${prefs.getString("storeId")}");
  }

  String convertTo12HourFormat(String time24) {
    try {
      final timeParts = time24.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final dateTime = DateTime(2023, 1, 1, hour, minute);

      return DateFormat('hh a').format(dateTime);
    } catch (e) {
      return time24;
    }
  }

  Future<void> fetchProductReviews(
    String? productId,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;

      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getProductReviews}/$productId",
        isHeaderRequire: true,
        isToast: false,
      );

      isLoading.value = false;

      if (response == null) {
        AppDialogs.showToast("Unable to load product reviews");
        return;
      }

      final data = response.data;

      if (data["status"] == true && data["data"] != null) {
        // Parse and store response
        productReviews.value = ProductReviewsResponseModel.fromJson(data);

        // Extract data
        final details = productReviews.value?.data;

        averageRating.value = details?.averageRating ?? 0;
        totalReviews.value = details?.totalReviews ?? 0;
        reviewsList?.value = details?.reviews ?? [];
      } else {
        isLoading.value = false;
        log(data["message"]);
        AppDialogs.showToast("Reviews not found.");
      }
    } catch (e) {
      isLoading.value = false;
      log("fetchProductReviews Exception: $e");
      AppDialogs.showToast("Error loading reviews");
    }
  }

  Future<void> fetchStoreDetail(String? storeId, BuildContext context) async {
    debugPrint("fetch store detail");
    try {
      showLoadingDialog(context);

      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getStoreDetail}/$storeId",
        isHeaderRequire: true,
        isToast: false,
      );

      Navigator.pop(context);

      if (response == null) {
        return;
      }

      final data = response.data;

      AppDialogs.showToast(data["message"]);

      if (data["status"] == true && data["data"] != null) {
        storeDetail.value = StoreDetailResponseModel.fromJson(data);
        storeData.value = storeDetail.value?.data;

        allProducts = storeData.value?.products ?? [];
        allPopularProducts = storeData.value?.popularProducts ?? [];

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StoreScreen(data: storeData.value)),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      log("StoreDetailResponseModel Exception: $e");
    }
  }

  setAvailibility(bool val) {
    isAvailable.value = val;
  }

  void search(String query) {
    searchQuery.value = query.trim();

    if (query.isEmpty) {
      searchedItems.clear();
      return;
    }

    final lower = query.toLowerCase();

    // Filter normal products
    final filteredProducts = allProducts
        .where((p) {
          return p.productName?.toLowerCase().contains(lower) ?? false;
        })
        .map((p) => SearchResultItem.fromProduct(p));

    // Filter popular products
    final filteredPopular = allPopularProducts
        .where((p) {
          return p.productName?.toLowerCase().contains(lower) ?? false;
        })
        .map((p) => SearchResultItem.fromPopular(p));

    // Combine & update UI
    searchedItems.value = [...filteredProducts, ...filteredPopular];
  }

  void incrementQuantity() {
    quantityCount.value++;
  }

  void decrementQuantity() {
    if (quantityCount.value > 0) {
      quantityCount.value--;
    }
  }

  void updateInventoryStatus(String status) {
    selectedStockStatus.value = status;
  }

  void updateCarouselIndex(int index) {
    currentCarouselIndex.value = index;
  }

  Future<void> getProductsByCategory(
    String? categoryId,
    String? categoryName,
    BuildContext context,
    bool fromHome,
  ) async {
    try {
      showLoadingDialog(context);

      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getProductsByCategory}/$categoryId",
        isHeaderRequire: true,
        isToast: false,
      );

      Navigator.pop(context);

      if (response == null) return;

      final data = response.data;

      if (data["status"] == true) {
        productsByCategory.value =
            GetProductsByCategoriesResponseModel.fromJson(data);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryWiseProductsList(
              fromHome: fromHome,
              products: productsByCategory.value?.data ?? [],
              categoryName: categoryName,
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future<void> fetchSingleProduct(
    String? productId,
    BuildContext context,
  ) async {
    try {
      showLoadingDialog(context);

      final response = await network.getRequest(
        endPoint: "${NetworkStrings.getSingleProduct}/$productId",
        isHeaderRequire: true,
        isToast: false,
      );

      Navigator.pop(context);

      if (response == null) {
        AppDialogs.showToast("Unable to fetch product details");
        return;
      }

      final data = response.data;

      if (data["status"] == true && data["data"] != null) {
        // PARSE API
        singleProduct.value = SingleProductResponseModel.fromJson(data);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectedProduct(
              productId: productId,
              productName: singleProduct.value?.data?.productName,
              ingredients: singleProduct.value?.data?.ingredients,
              description: singleProduct.value?.data?.description,
              effets: singleProduct.value?.data?.effects,
              price: singleProduct.value?.data?.price,
              afterDiscountPrice: singleProduct.value?.data?.afterDiscountPrice,
              inventoryStatus: singleProduct.value?.data?.inventoryStatus,
              hasDiscount:
                  singleProduct.value?.data?.isDiscountAvailable ?? false,
              isAvailable: singleProduct.value?.data?.isAvailable ?? false,
              quantity: singleProduct.value?.data?.quantity,
              productImages: singleProduct.value?.data?.productImages,
            ),
          ),
        );
      } else {
        AppDialogs.showToast(data["message"] ?? "Failed to load product");
      }
    } catch (e) {
      Navigator.pop(context);
      log("fetchSingleProduct Exception: $e");
      AppDialogs.showToast("Something went wrong while getting product.");
    }
  }
}
