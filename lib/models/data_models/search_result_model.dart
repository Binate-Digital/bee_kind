import 'package:bee_kind/models/response_models/store_detail_response_model.dart';

class SearchResultItem {
  final String? productId;
  final String? productName;
  final int? price;
  final int? afterDiscountPrice;
  final bool? isDiscountAvailable;
  final String? inventoryStatus;
  final List<String>? productImages;

  // newly added fields
  final String? ingredients;
  final String? description;
  final String? effects;
  final bool? isAvailable;
  final int? quantity;

  SearchResultItem({
    this.productId,
    this.productName,
    this.price,
    this.afterDiscountPrice,
    this.isDiscountAvailable,
    this.inventoryStatus,
    this.productImages,
    this.ingredients,
    this.description,
    this.effects,
    this.isAvailable,
    this.quantity,
  });

  /// FACTORY for Products
  factory SearchResultItem.fromProduct(Products p) {
    return SearchResultItem(
      productId: p.sId,
      productName: p.productName,
      price: p.price,
      afterDiscountPrice: p.afterDiscountPrice,
      isDiscountAvailable: p.isDiscountAvailable,
      inventoryStatus: p.inventoryStatus,
      productImages: p.productImages,
      ingredients: p.ingredients,
      description: p.description,
      effects: p.effects,
      isAvailable: p.isAvailable,
      quantity: p.quantity,
    );
  }

  /// FACTORY for PopularProducts
  factory SearchResultItem.fromPopular(PopularProducts p) {
    return SearchResultItem(
      productId: p.sId,
      productName: p.productName,
      price: p.price,
      afterDiscountPrice: p.afterDiscountPrice,
      isDiscountAvailable: p.isDiscountAvailable,
      inventoryStatus: p.inventoryStatus,
      productImages: p.productImages,
      ingredients: p.ingredients,
      description: p.description,
      effects: p.effects,
      isAvailable: p.isAvailable,
      quantity: p.quantity,
    );
  }
}
