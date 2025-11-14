import 'package:bee_kind/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppDialogs {
  ////////////////////// Toast //////////////////////////
  static void showToast(String? message) {
    Fluttertoast.showToast(
      msg: message ?? "",
      backgroundColor: AppColors.yellow1,
      textColor: AppColors.blackColor,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  static Widget circularProgressWidget({Color? color}) {
    return CircularProgressIndicator(color: color ?? AppColors.whiteColor);
  }

  static void progressAlertDialog({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColors.whiteColor,
              color: AppColors.whiteColor,
            ),
          ),
        );
      },
    );
  }
}
