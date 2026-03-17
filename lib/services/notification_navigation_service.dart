import 'dart:convert';

import 'package:bee_kind/models/response_models/notification_model.dart';

const String _newOrderType = 'new-order';

class NotificationRouteData {
  const NotificationRouteData({
    required this.target,
    this.type,
    this.productId,
    this.orderId,
  });

  final NotificationTarget target;
  final String? type;
  final String? productId;
  final String? orderId;

  bool get hasTarget => target != NotificationTarget.none;
}

enum NotificationTarget {
  none,
  product,
  vendorMyProducts,
  orderTracking,
  orderRequestsTab,
}

class NotificationNavigationService {
  NotificationNavigationService._();

  static Map<String, dynamic>? _pendingPayload;

  static NotificationRouteData fromNotificationItem(
    NotificationItem notification,
    {bool isVendor = false}
  ) {
    return _resolveRoute(
      type: _clean(notification.type),
      productId: _clean(notification.metadata?.productId),
      orderId: _clean(notification.metadata?.orderId),
      isVendor: isVendor,
    );
  }

  static NotificationRouteData fromPayload(
    Map<String, dynamic> payload, {
    bool isVendor = false,
  }) {
    final metadata = _extractMetadata(payload['metadata']);
    final type = _clean(payload['type']);
    final fallbackId = _clean(payload['id']);

    final productId =
        _clean(metadata['productId']) ??
        _clean(payload['productId']) ??
        _clean(payload['product_id']) ??
        (_isProductType(type) ? fallbackId : null);

    final orderId =
        _clean(metadata['orderId']) ??
        _clean(payload['orderId']) ??
        _clean(payload['order_id']) ??
        (_isOrderType(type) ? fallbackId : null);

    return _resolveRoute(
      type: type,
      productId: productId,
      orderId: orderId,
      isVendor: isVendor,
    );
  }

  static void setPendingPayload(Map<String, dynamic> payload) {
    _pendingPayload = Map<String, dynamic>.from(payload);
  }

  static Map<String, dynamic>? takePendingPayload() {
    final pendingPayload = _pendingPayload;
    _pendingPayload = null;
    return pendingPayload;
  }

  static NotificationRouteData _resolveRoute({
    String? type,
    String? productId,
    String? orderId,
    bool isVendor = false,
  }) {
    switch (type) {
      case 'review-reply-added':

        print("productIdproductId======${productId}");
        if (isVendor && productId != null) {
          return NotificationRouteData(
            target: NotificationTarget.vendorMyProducts,
            type: type,
            productId: productId,
          );
        }
        if (productId != null) {
          return NotificationRouteData(
            target: NotificationTarget.product,
            type: type,
            productId: productId,
          );
        }
        break;
      case 'new-product':
      case 'discount-added':
        if (productId != null) {
          return NotificationRouteData(
            target: NotificationTarget.product,
            type: type,
            productId: productId,
          );
        }
        break;
      case 'order-status-updated':
      case 'new-order-accepted':
        if (orderId != null) {
          return NotificationRouteData(
            target: NotificationTarget.orderTracking,
            type: type,
            orderId: orderId,
          );
        }
        break;
      case _newOrderType:
        return NotificationRouteData(
          target: NotificationTarget.orderRequestsTab,
          type: type,
          orderId: orderId,
        );
    }

    return NotificationRouteData(target: NotificationTarget.none, type: type);
  }

  static Map<String, dynamic> _extractMetadata(dynamic rawMetadata) {
    if (rawMetadata is Map<String, dynamic>) {
      return rawMetadata;
    }

    if (rawMetadata is Map) {
      return Map<String, dynamic>.from(rawMetadata);
    }

    if (rawMetadata is String && rawMetadata.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawMetadata);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return <String, dynamic>{};
      }
    }

    return <String, dynamic>{};
  }

  static String? _clean(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return text.toLowerCase() == _newOrderType ? _newOrderType : text;
  }

  static bool _isProductType(String? type) {
    return type == 'review-reply-added' ||
        type == 'new-product' ||
        type == 'discount-added';
  }

  static bool _isOrderType(String? type) {
    return type == 'order-status-updated' || type == 'new-order-accepted';
  }
}

