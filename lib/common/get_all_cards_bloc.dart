import 'dart:developer';
import 'package:bee_kind/models/response_models/card_response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/network_strings.dart';

class GetCardBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  final network = Network();

  Future<void> getAllCards({
    required BuildContext context,
    required VoidCallback setProgressBar,
    required Function(CardResponseModel model) onCardsLoaded,
  }) async {
    setProgressBar();

    // PRE-DEFINE FAILURE HANDLER
    _onFailure = () {
      // AppDialogs.showToast("Failed to fetch cards");
    };

    // PRE-DEFINE SUCCESS HANDLER
    _onSuccess = () {
      try {
        final json = _response?.data;
        final model = CardResponseModel.fromJson(json);

        log("✔ GET CARDS SUCCESS — ${model.data?.cards?.length} cards");

        onCardsLoaded(model);
      } catch (e, st) {
        log("Parsing error: $e\n$st");
        AppDialogs.showToast("Failed to parse cards.");
      }
    };

    // Now make the request
    await _getRequest(endPoint: NetworkStrings.getAllCards, context: context);

    // Validate using SAFE custom logic
    _validateResponse();
  }

  Future<void> _getRequest({
    required String endPoint,
    required BuildContext context,
  }) async {
    _response = await network.getRequest(
      endPoint: endPoint,
      isHeaderRequire: true,
      isToast: false,
      isErrorToast: false,
      onFailure: _onFailure,
    );
  }

  /// ------------------------------------------
  /// FIXED VALIDATION
  /// ------------------------------------------
  void _validateResponse() {
    if (_response == null) {
      _onFailure?.call();
      return;
    }

    final json = _response?.data;

    log("🔎 RAW CARD RESPONSE: $json");

    // Backend success check
    if (json is Map && json["status"] == true) {
      _onSuccess?.call();
    } else {
      _onFailure?.call();
    }
  }
}
