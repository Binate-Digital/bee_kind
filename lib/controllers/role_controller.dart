import 'dart:developer';
import 'package:bee_kind/auth/sign_in_screen.dart';
import 'package:bee_kind/common/base_view.dart';
import 'package:bee_kind/common/create_profile_screen.dart';
import 'package:bee_kind/core/role_type_screen.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/user_location_permission.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleController extends GetxController {
  final prefs = SharedPrefs();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    final hasUserToken =
        prefs.getUserToken() != null && prefs.getUserToken()!.isNotEmpty;
    final hasCompletedProfile = prefs.checkProfile();
    final hasSelectedRole = prefs.containsKey('role');

    log("user token: ${prefs.getUserToken()}");
    log("user role: ${prefs.getRole()}");
    log("hasCompletedProfile: $hasCompletedProfile");
    log("hasSelectedRole: $hasSelectedRole");

    if (hasSelectedRole) {
      if (hasUserToken) {
        if (hasCompletedProfile) {
          Get.offAll(() => BaseView());
        } else {
          Get.offAll(() => CreateProfileScreen());
        }
      } else {
        Get.offAll(() => const RoleTypeScreen());
      }
    }

    UserPermissions.handleLocationPermission().then((value) {
      UserPermissions.requestCameraAndMicrophonePermission();
    });
  }

  Future<void> selectRole(String role) async {
    await prefs.setRole(role);
    log("role set to: ${prefs.getRole()}");
    Get.to(() => const SignInScreen());
  }
}
