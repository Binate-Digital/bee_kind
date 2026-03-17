import 'package:bee_kind/models/response_models/notification_model.dart';
import 'package:bee_kind/services/notification_navigation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationNavigationService.fromPayload', () {
    test('maps review-reply-added payload to product route using metadata JSON', () {
      final routeData = NotificationNavigationService.fromPayload({
        'type': 'review-reply-added',
        'metadata': '{"productId":"product-123","reviewId":"review-1"}',
      });

      expect(routeData.target, NotificationTarget.product);
      expect(routeData.productId, 'product-123');
    });

    test('maps order-status-updated payload to order tracking route', () {
      final routeData = NotificationNavigationService.fromPayload({
        'type': 'order-status-updated',
        'metadata': {'orderId': 'order-456'},
      });

      expect(routeData.target, NotificationTarget.orderTracking);
      expect(routeData.orderId, 'order-456');
    });

    test('maps new-order payload to order requests tab', () {
      final routeData = NotificationNavigationService.fromPayload({
        'type': 'new-order',
        'id': 'order-789',
      });

      expect(routeData.target, NotificationTarget.orderRequestsTab);
      expect(routeData.type, 'new-order');
    });

    test('falls back to top-level id for product notifications', () {
      final routeData = NotificationNavigationService.fromPayload({
        'type': 'new-product',
        'id': 'product-999',
      });

      expect(routeData.target, NotificationTarget.product);
      expect(routeData.productId, 'product-999');
    });
  });

  group('NotificationNavigationService.fromNotificationItem', () {
    test('maps notification item metadata to product route', () {
      final routeData = NotificationNavigationService.fromNotificationItem(
        NotificationItem(
          type: 'new-product',
          metadata: NotificationMetadata(productId: 'product-abc'),
        ),
      );

      expect(routeData.target, NotificationTarget.product);
      expect(routeData.productId, 'product-abc');
    });
  });
}

