import 'dart:async';

import 'package:CyberTrace/features/splash_screen/view/spalsh_screen.dart';
import 'package:CyberTrace/helpers/sp_helper.dart';
import 'package:CyberTrace/services/api_exceptions.dart';
import 'package:CyberTrace/utils/app_build_methods.dart';
import 'package:CyberTrace/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:CyberTrace/utils/sp_keys.dart' as sp_keys;
import 'package:shared_preferences/shared_preferences.dart';

mixin WebAPIMixin {
  /// Returns the token from Shared Preference
  /// Token is saved as key pair of [sp_keys.keyToken]
  /// Throws exception in case of any error
  Future<String?> getTokenFromSharedPref() => SharedPreferences.getInstance()
      .then<String?>((sp) => sp.getString(sp_keys.keyToken));

  /// Returns opted language code from Shared Preference
  /// Token is saved as key pair of [sp_keys.keyLanguageCode]
  /// Throws exception in case of any error
  Future<String?> getLanguageSharedPref() {
    return SharedPreferences.getInstance().then<String?>(
      (sp) => sp.getString(sp_keys.keyLanguageCode),
    );
  }

  /// Handle the dio error in call
  void onDioError(DioException error, String apiName) {
    String? msg;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        break;
      case DioExceptionType.sendTimeout:
        break;
      case DioExceptionType.receiveTimeout:
        break;
      case DioExceptionType.unknown:
        msg = 'Please check your internet connection and try again';

      case DioExceptionType.badResponse:

        /// Check the api response has data
        if (error.response?.data == null) {
          throw APIException(
            enumProperty: EnumAPIExceptions.httpStatusError,
            message: msg ?? '$apiName:${error.message}',
            data: [error.error],
          );
        }

        if (error.response!.data is Map) {
          final data = error.response!.data as Map;
          if (data.containsKey('message')) {
            if (data['message'] == 'Invalid login details') {
              _onInvalidToken();
              throw APIException(
                enumProperty: EnumAPIExceptions.invalidToken,
                message: 'Token expired',
              );
            }
            showToast(data['message'].toString());
            throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data['message'].toString(),
              data: error.response,
            );
          }

          if (data.containsKey('StatusDesc')) {
            if ([
              'invalid session',
              'invalid session.',
              'not a valid session',
              'not a valid session.',
            ].contains(data['StatusDesc']?.toString().toLowerCase())) {
              showToast(error.message ?? '');
              throw APIException(
                enumProperty: EnumAPIExceptions.invalidToken,
                message: data['StatusDesc'].toString(),
                data: error.response,
              );
            }
          }

          if (data.containsKey('message')) {
            if (data['message'] == 'Invalid login details.') {
              _onInvalidToken();

              throw APIException(
                enumProperty: EnumAPIExceptions.invalidToken,
                message: 'Token expired',
                data: error.response,
              );
            }

            throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data['message'].toString(),
              data: error.response,
            );
          }
        }

      case DioExceptionType.cancel:
        msg = 'The request has been cancelled.';
      case DioExceptionType.badCertificate:
        throw APIException(
          enumProperty: EnumAPIExceptions.badCertificate,
          message: msg ?? '$apiName:${error.message}',
          data: [error.response?.data],
        );
      case DioExceptionType.connectionError:
        msg = 'Failed to connect.';
        throw APIException(
          enumProperty: EnumAPIExceptions.httpStatusError,
          message: msg,
          data: [error.response?.data],
        );
    }
    throw APIException(
      enumProperty: EnumAPIExceptions.httpStatusError,
      message: msg ?? '$apiName:${error.message}',
      data: [error.response?.data],
    );
  }

  Future<Response<dynamic>> validateResStatusData(
    Response<dynamic> response,
  ) async {
    if (response.data == null) {
      throw APIException(
        enumProperty: EnumAPIExceptions.apiResultEmpty,
        message: 'The response is empty from server',
      );
    }

    if (response.data is! Map) {
      throw APIException(
        enumProperty: EnumAPIExceptions.invalidResultType,
        message: 'Invalid result type from API response',
      );
    }

    final data = response.data as Map;

    if (data.containsKey('_status')) {
      if (data['_status']?.toString() == '500') {
        String? msg = 'API response error from server';
        if (data.containsKey('message') &&
            (data['message']?.toString().isNotEmpty ?? false)) {
          msg = data['message'].toString();
        }
        throw APIException(
          enumProperty: EnumAPIExceptions.dataSuccessFalse,
          message: msg,
        );
      }

      if (data['_status']?.toString() == '422') {
        String? msg = 'Validation Error';
        if (data.containsKey('message') &&
            (data['message']?.toString().isNotEmpty ?? false)) {
          msg = data['message'].toString();
        }
        throw APIException(
          enumProperty: EnumAPIExceptions.dataSuccessFalse,
          message: msg,
        );
      }
      if (data['_status']?.toString() == '401') {
        String? msg = 'Validation Error';
        if (data.containsKey('message') &&
            (data['message']?.toString().isNotEmpty ?? false)) {
          msg = data['message'].toString();
        }
        throw APIException(
          enumProperty: EnumAPIExceptions.dataSuccessFalse,
          message: msg,
        );
      }
    }

    return response;
  }

  Future<void> _onInvalidToken() async {
    try {
      final sp = await SpHelper.getSP();

      await sp.clear();
      
      await Navigator.pushReplacementNamed(
        AppUtils.navKey.currentContext!,
        SplashScreen.routeName,
      );
      showToast('Unauthenticated');
    } on Exception catch (e) {
      showToast(e.toString());
    }
  }
}
