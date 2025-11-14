import 'package:flutter/material.dart';

class AppNavigation {
  static navigateToRemovingAll(
    context,
    String routeName, {
    Object? arguments,
  }) async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static navigateReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static navigatorPop(BuildContext context) {
    Navigator.pop(context);
  }

  static navigateCloseDialog(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
