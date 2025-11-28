import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../utils/app_dialogs.dart';

class StripeService {
  static Future<String?> createPaymentMethod({
    required BuildContext context,
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
    String? name,
    String? email,
  }) async {
    try {
      // Show loader
      AppDialogs.progressAlertDialog(context: context);

      // 1️⃣ Update card details
      await Stripe.instance.dangerouslyUpdateCardDetails(
        CardDetails(
          number: cardNumber,
          expirationMonth: expMonth,
          expirationYear: expYear,
          cvc: cvc,
        ),
      );

      // 2️⃣ Create Payment Method (LATEST API – NO params required)
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(name: name, email: email),
          ),
        ),
      );

      Navigator.pop(context); // close loader

      log("Stripe PaymentMethod ID: ${paymentMethod.id}");

      return paymentMethod.id;
    } on StripeException catch (ex) {
      Navigator.pop(context);
      AppDialogs.showToast(ex.error.message ?? "Stripe error");
      log("Stripe Error: ${ex.error.message}");
      return null;
    } catch (ex) {
      Navigator.pop(context);
      AppDialogs.showToast("Something went wrong");
      log("General Error: $ex");
      return null;
    }
  }
}
