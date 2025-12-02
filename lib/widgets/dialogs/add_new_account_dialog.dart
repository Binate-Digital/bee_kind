import 'package:bee_kind/common/add_card_bloc.dart';
import 'package:bee_kind/services/stripe_service.dart';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<Map<String, dynamic>?> addNewAccountDialog(BuildContext context) async {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final expController = TextEditingController();
  final cvvController = TextEditingController();

  return await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20.w),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ---------- HEADER ----------
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        decoration: BoxDecoration(
                          color: AppColors.yellow2,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Add New Card",
                            fontSize: 22.sp,
                            fontColor: AppColors.blackColor,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10.w,
                        top: 17.h,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close, size: 25.r),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  // ---------- NAME ----------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomTextField(
                      controller: nameController,
                      hint: "Card Holder Name",
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ---------- CARD NUMBER ----------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomTextField(
                      controller: numberController,
                      hint: "Card Number",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberFormatter(),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ---------- EXP + CVV ----------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: CustomTextField(
                              controller: expController,
                              hint: "MM/YY",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                ExpiryDateFormatter(),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: CustomTextField(
                              controller: cvvController,
                              hint: "CVV",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // ---------- BUTTON ----------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      text: "Add Card",
                      onTap: () async {
                        String rawExp = expController.text.trim();

                        if (!rawExp.contains("/") || rawExp.length != 5) {
                          AppDialogs.showToast("Invalid Exp Date Format");
                          return;
                        }

                        final parts = rawExp.split("/");
                        int month = int.tryParse(parts[0]) ?? 0;
                        int year = int.tryParse("20${parts[1]}") ?? 0;

                        if (month < 1 || month > 12) {
                          AppDialogs.showToast("Invalid Month (1–12)");
                          return;
                        }

                        if (year < DateTime.now().year) {
                          AppDialogs.showToast("Card has expired");
                          return;
                        }

                        final cardToken =
                            await StripeService.createPaymentMethod(
                              context: context,
                              cardNumber: numberController.text.trim(),
                              expMonth: month,
                              expYear: year,
                              cvc: cvvController.text.trim(),
                            );

                        if (cardToken == null) {
                          AppDialogs.showToast("Failed to generate card token");
                          return;
                        }

                        // Step 2 - Add Card API
                        AddCardBloc().saveCard(
                          context: context,
                          cardToken: cardToken,
                          setProgressBar: () {
                            AppDialogs.progressAlertDialog(context: context);
                          },
                        );

                        Navigator.pop(context);
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

/// ------------------------------------------------------------
///  Custom MMYY TextInputFormatter
///  Auto-formats: 1234 → "12/34"
/// ------------------------------------------------------------
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // Remove everything except numbers
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// ------------------------------------------------------------
///  Formats card number: 4242-4242-4242-4242
/// ------------------------------------------------------------
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit max length to 16 digits
    if (text.length > 16) text = text.substring(0, 16);

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write('-');
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
