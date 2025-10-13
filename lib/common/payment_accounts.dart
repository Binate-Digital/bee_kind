import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/add_new_account_dialog.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentAccountsScreen extends StatefulWidget {
  const PaymentAccountsScreen({super.key});

  @override
  State<PaymentAccountsScreen> createState() => _PaymentAccountsScreenState();
}

class _PaymentAccountsScreenState extends State<PaymentAccountsScreen> {
  // List of payment methods that can be dismissed
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': '1',
      'method': "PayPal",
      'color': Colors.blue[900]!,
      'name': 'Pay Pal',
    },
    {'id': '2', 'method': "G Pay", 'color': Colors.blue, 'name': 'Google Pay'},
    {
      'id': '3',
      'method': "A Pay",
      'color': AppColors.blackColor,
      'name': 'Apple Pay',
    },
  ];

  void _removePaymentMethod(String id) {
    setState(() {
      _paymentMethods.removeWhere((method) => method['id'] == id);
    });
    // Optional: Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment method removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // You would need to implement undo logic here
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Payment Accounts",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomButton(
          borderColor: AppColors.blackColor,
          onTap: () {
            addNewAccountDialog(context);
          },
          text: "Add New Account",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: _paymentMethods.isEmpty
            ? Center(
                child: CustomText(
                  text: "No payment methods added",
                  fontSize: 18.sp,
                  fontColor: Colors.grey[600]!,
                ),
              )
            : ListView.builder(
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return Dismissible(
                    key: Key(method['id']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(right: 20.w),
                      child: Icon(Icons.delete, color: Colors.red, size: 24.w),
                    ),
                    secondaryBackground: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.w),
                      child: Icon(Icons.delete, color: Colors.red, size: 24.w),
                    ),
                    confirmDismiss: (direction) async {
                      // Optional: Show confirmation dialog
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: CustomText(text: "Confirm Delete"),
                            content: CustomText(
                              text:
                                  "Are you sure you want to remove this payment method?",
                              fontSize: 14.sp,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: CustomText(text: "Cancel"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: CustomText(
                                  text: "Delete",
                                  fontColor: Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      _removePaymentMethod(method['id']);
                    },
                    child: PaymentMethod(
                      paymentMethod: method['method'],
                      color: method['color'],
                      paymentName: method['name'],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
    required this.paymentMethod,
    required this.color,
    required this.paymentName,
  });
  final String paymentMethod;
  final String paymentName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 25.h),
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
        children: [
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: color,
            ),
            child: CustomText(
              text: paymentMethod,
              fontSize: 16.sp,
              fontColor: AppColors.whiteColor,
            ),
          ),
          SizedBox(width: 10.w),
          CustomText(text: paymentName, fontSize: 20.sp),
        ],
      ),
    );
  }
}
