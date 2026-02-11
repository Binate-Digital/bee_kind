import 'dart:developer';

import 'package:bee_kind/main.dart';
import 'package:bee_kind/services/connectivity.dart';
import 'package:bee_kind/services/logger_interceptors.dart';
import 'package:bee_kind/services/shared_prefs_services.dart';
import 'package:bee_kind/utils/app_dialogs.dart';
import 'package:bee_kind/utils/app_navigation.dart';
import 'package:bee_kind/utils/app_route_names.dart';
import 'package:bee_kind/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Network {
  static Dio? _dio;
  static CancelToken? _cancelRequestToken;

  static Network? _network;

  static ConnectivityManager? _connectivityManager;

  Network._createInstance();

  factory Network() {
    // factory with constructor, return some value
    if (_network == null) {
      _network =
          Network._createInstance(); // This is executed only once, singleton object

      _dio = _getDio();
      _dio?.interceptors.add(LoggingInterceptor());
      _cancelRequestToken = _getCancelToken();

      _connectivityManager = ConnectivityManager();
    }
    return _network!;
  }

  static Dio _getDio() {
    // BaseOptions options = new BaseOptions(
    //   connectTimeout: 20000,
    // );
    return _dio ??= Dio(
      BaseOptions(
        validateStatus: (status) {
          if (status == null) return false;
          return status <= 500; // allow 200–499
        },
      ),
    );
  }

  static CancelToken _getCancelToken() {
    return _cancelRequestToken ??= CancelToken();
  }

  // inside Network class
  Future<Response?> getDirect(String url) async {
    try {
      final dio = Dio();
      return await dio.get(url);
    } catch (e) {
      log("DIRECTIONS API ERROR: $e");
      return null;
    }
  }

  ////////////////// Get Request /////////////////////////
  Future<Response?> getRequest({
    //  required BuildContext context,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    //  VoidCallback? onFailure(dynamic response)?,
    VoidCallback? onFailure,
    String? isCustomUrl,
    bool isToast = true,
    bool isErrorToast = true,
    int connectTimeOut = 20000,
    required bool isHeaderRequire,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        final url = isCustomUrl ?? (NetworkStrings.baseUrl + endPoint);
        final headers = await _setHeader(isHeaderRequire: isHeaderRequire);
        log('Network GET -> URL: $url');
        log('Network GET -> queryParameters: $queryParameters');
        log('Network GET -> headers: $headers');
        final temp = await _dio!.get(
          url,
          queryParameters: queryParameters,
          cancelToken: _cancelRequestToken,
          options: Options(
            headers: headers,
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );
        log('Network GET response -> status: ${temp.statusCode}');
        try {
          log('Network GET response -> headers: ${temp.headers.map}');
        } catch (_) {}
        try {
          log('Network GET response -> data: ${temp.data}');
        } catch (_) {}
        if (temp.data is Map && temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }
        response = temp;
        // response =
        //print(response);
      } on DioException catch (e) {
        // print("exception is "+e.toString());
        //  log("Error:${e.response.toString()}");
        //response=e.response;
        debugPrint('repose is $response');
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }

    return response;
  }

  ////////////////// Patch Request /////////////////////////
  Future<Response?> patchRequest({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 50000,
    bool isErrorToast = true,
    bool isHeaderRequire = false,
    Function(int, int)? progress,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);

        final temp = await _dio!.patch(
          NetworkStrings.baseUrl + endPoint,
          data: data,
          queryParameters: queryParameters,
          cancelToken: _cancelRequestToken,
          onSendProgress: progress,
          options: Options(
            headers: await _setHeader(isHeaderRequire: isHeaderRequire),
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );

        if (temp.data is Map && temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }

        response = temp;
      } on DioException catch (e) {
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint PATCH Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }

    return response;
  }




  Future<Response?> postRequestiWthoutHeader({
    required String endPoint,
    dynamic data,
    dynamic token="",
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 50000,
    bool isErrorToast = true,
    bool isHeaderRequire = false,
    Function(int, int)? progress,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);

        final temp = await _dio!.patch(
          NetworkStrings.baseUrl + endPoint,
          data: data,
          queryParameters: queryParameters,
          cancelToken: _cancelRequestToken,
          onSendProgress: progress,
          options: Options(
            headers: await _setHeader1(isHeaderRequire: isHeaderRequire,token: token),
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );

        if (temp.data is Map && temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }

        response = temp;
      } on DioException catch (e) {
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint PATCH Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }

    return response;
  }

  ////////////////// Post Request /////////////////////////
  Future<Response?> postRequest({
    // required BuildContext context,
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 50000,
    bool isErrorToast = true,
    bool isHeaderRequire = false,
    Function(int, int)? progress,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        final temp = await _dio!.post(
          NetworkStrings.baseUrl + endPoint,
          data: data,
          cancelToken: _cancelRequestToken,
          onSendProgress: progress,
          queryParameters: queryParameters,
          options: Options(
            headers: await await _setHeader(isHeaderRequire: isHeaderRequire),
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );
        if (temp.data is Map && temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }
        response = temp;
      } on DioException catch (e) {
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }
    return response;
  }




  Future<Response?> postRequestWithoutHeader({
    // required BuildContext context,
    required String endPoint,
    dynamic data,
    dynamic token="",
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 50000,
    bool isErrorToast = true,
    bool isHeaderRequire = false,
    Function(int, int)? progress,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        final temp = await _dio!.post(
          NetworkStrings.baseUrl + endPoint,
          data: data,
          cancelToken: _cancelRequestToken,
          onSendProgress: progress,
          queryParameters: queryParameters,
          options: Options(
            headers: await await _setHeader1(isHeaderRequire: isHeaderRequire,token: token),
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );
        if (temp.data is Map && temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }
        response = temp;
      } on DioException catch (e) {
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }
    return response;
  }




  ////////////////// Post Request Raw Data /////////////////////////
  Future<Response?> postRequestRawData({
    required BuildContext context,
    required String endPoint,
    Map<String, dynamic>? body,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 50000,
    bool isErrorToast = true,
    required bool isHeaderRequire,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        final temp = await _dio!.post(
          NetworkStrings.baseUrl + endPoint,
          data: body,
          cancelToken: _cancelRequestToken,
          options: Options(
            headers: await await _setHeader(isHeaderRequire: isHeaderRequire),
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );
        if (temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }
        response = temp;
      } on DioException catch (e) {
        //   response=e.response;
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }
    return response;
  }

  ////////////////// Put Request /////////////////////////
  Future<Response?> putRequest({
    required BuildContext context,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 20000,
    bool isErrorToast = true,
    required bool isHeaderRequire,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        final temp = await _dio!.put(
          NetworkStrings.baseUrl + endPoint,
          queryParameters: queryParameters,
          cancelToken: _cancelRequestToken,
          options: Options(
            headers: await await _setHeader(isHeaderRequire: isHeaderRequire),
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );
        if (temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }
        response = temp;
        //print(response);
      } on DioException catch (e) {
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }

    return response;
  }

  ////////////////// Delete Request /////////////////////////
  Future<Response?> deleteRequest({
    //required BuildContext context,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 20000,
    bool isErrorToast = true,
    required bool isHeaderRequire,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = Duration(milliseconds: connectTimeOut);
        final temp = await _dio!.delete(
          NetworkStrings.baseUrl + endPoint,
          queryParameters: queryParameters,
          cancelToken: _cancelRequestToken,
          options: Options(
            headers: await await _setHeader(isHeaderRequire: isHeaderRequire),
            sendTimeout: Duration(milliseconds: connectTimeOut),
            receiveTimeout: Duration(milliseconds: connectTimeOut),
          ),
        );
        if (temp.data['message'] != null) {
          final msg = temp.data['message'].toString();
          temp.data['message'] = msg;
        }
        response = temp;
        debugPrint(response.toString());
      } on DioException catch (e) {
        _validateException(
          response: e.response,
          message: e.message,
          onFailure: onFailure,
          isToast: isToast,
          isErrorToast: isErrorToast,
        );
        debugPrint("$endPoint Dio: ${e.message}");
      }
    } else {
      _noInternetConnection(onFailure: onFailure, isErrorToast: isErrorToast);
    }
    return response;
  }

  ////////////////// Set Header /////////////////////
  _setHeader({required bool isHeaderRequire}) async {
    SharedPrefs prefs = SharedPrefs();
    String? token = prefs.getUserToken();
    log("token is inside header: $token");
    if (isHeaderRequire) {
      return {
        'Accept': NetworkStrings.accept,
        'Authorization': "Bearer $token",
      };
    } else {
      return {'Accept': NetworkStrings.accept};
    }
  }


  _setHeader1({required bool isHeaderRequire,token}) async {

    if (isHeaderRequire) {
      return {
        'Accept': NetworkStrings.accept,
        'Authorization': "Bearer $token",
      };
    } else {
      return {'Accept': NetworkStrings.accept};
    }
  }

  ////////////////// Validate Response /////////////////////
  void validateResponse({
    Response? response,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
    bool isToast = true,
    bool isThirdPartyApiRequest = false,
  }) {
    var validateResponseData = response?.data;
    log('resp $validateResponseData');

    if (validateResponseData != null) {
      isToast
          ? AppDialogs.showToast(validateResponseData['message'] ?? "")
          : null;

      if (response!.statusCode == NetworkStrings.success) {
        if (validateResponseData['status'] == NetworkStrings.apiSuccessStatus) {
          if (onSuccess != null) {
            onSuccess();
          }
        } else if (isThirdPartyApiRequest == true) {
          if (onSuccess != null) {
            onSuccess();
          }
        } else {
          if (onFailure != null) {
            onFailure();
          }
        }
      } else {
        debugPrint("else calling");
        if (onFailure != null) {
          onFailure();
        }
        //log(response.statusCode.toString());
      }
    }
  }

  void _validateException({
    Response? response,
    String? message,
    bool isToast = true,
    bool? isErrorToast,
    VoidCallback? onFailure,
  }) async {
    BuildContext? appContext = StaticData.navigatorKey.currentState?.context;

    if (onFailure != null) {
      onFailure();
    }
    if (response?.statusCode == NetworkStrings.badRequest) {
      if (response?.data["message"] != null) {
        final msg = response?.data["message"].toString();
        isToast ? AppDialogs.showToast(msg.toString()) : null;
      }
    } else {
      isToast
          ? AppDialogs.showToast(response?.statusMessage ?? "Network Error")
          : null;
    }

    if (response?.statusCode == NetworkStrings.unauthorized) {
      AppDialogs.showToast(response?.statusMessage ?? "Network Error");
      AppNavigation.navigateToRemovingAll(
        appContext,
        AppRouteNames.roleTypeScreen,
      );
    }
  }

  /// ----------------- No Internet Connection -----------------
  void _noInternetConnection({VoidCallback? onFailure, bool? isErrorToast}) {
    if (onFailure != null) {
      onFailure();
    }
    isErrorToast == true
        ? AppDialogs.showToast("No Internet Connection!")
        : null;
  }
}
