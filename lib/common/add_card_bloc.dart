import 'dart:developer';
import 'package:bee_kind/models/response_models/add_card-response_model.dart';
import 'package:bee_kind/services/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/network_strings.dart';

class AddCardBloc {
  dynamic _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  void saveCard({

    required BuildContext context,
    required String cardToken,
    required VoidCallback setProgressBar,
  }) async {
    print("save Cardsasa");
    setProgressBar();

    _onFailure = () {
      Navigator.pop(context);
    };

    log("CARD TOKEN: $cardToken");

    _formData = {'paymentMethodId': cardToken};

    log('Add Card Payload: $_formData');

    await _postRequest(
      endPoint: NetworkStrings.ADD_NEW_CARD_ENDPOINT,
      context: context,
    );

    _onSuccess = () {
      Navigator.pop(context);
      _validateAddresses(context);
    };

    _onFailure = () {
      Navigator.pop(context);
    };

    _validateResponse();
  }

  final network = Network();

  /// Post Request
  Future<void> _postRequest({
    required String endPoint,
    required BuildContext context,
  }) async {
    _response = await network.postRequest(
      endPoint: endPoint,
      data: _formData,
      onFailure: _onFailure,
      isHeaderRequire: true,
      isErrorToast: false,
      isToast: true,
    );
  }

  /// Validate Response
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
        response: _response,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
        isToast: true,
      );
    }
  }

  void _validateAddresses(BuildContext context) {
    try {
      // Parse the card data correctly
      final cardJson = _response?.data['data'];
      final card = AddCardResponseModel.fromJson(cardJson);

      log("card added: ${card.toJson()}");

      AppDialogs.showToast(_response?.data['message']);

      Navigator.pop(context);
    } catch (e, stackTrace) {
      log("Error parsing card: $e\n$stackTrace");
      AppDialogs.showToast("Something went wrong");
    }
  }
}
