// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter, 

import 'dart:io';
import 'package:base_project/configs/app_configs.dart';
import 'package:base_project/services/_mixins_api.dart';
import 'package:base_project/services/api_exceptions.dart';
import 'package:base_project/services/interceptors.dart';
import 'package:base_project/utils/extensions.dart';
import 'package:base_project/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';


enum RequestMethod {
  /// get
  get,

  /// post
  post,

  // /// patch
  // patch,

  // /// delete
  delete,

  // /// put
  // put,

  // /// Multipart request
  // multipartRequest,
}

enum HeaderMethod { langHeader, tokenHeader }

class WebAPIService with WebAPIMixin {
  factory WebAPIService() => WebAPIService._initialise();
  WebAPIService._initialise()
      : _dio = Dio(
          BaseOptions(
            // connectTimeout: 5000, receiveTimeout: 3000,
            headers: {
              'accept': 'application/json',
            },
          ),
        ) {
    if (AppConfig.isDebug) {
      dio.interceptors
        ..add(
          LogInterceptor(
            responseHeader: false,
            responseBody: true,
            requestBody: true,
          ),
        )
        ..add(AppStackInterceptorBuilder.appStackInterceptor);
    }
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      return client;
    };
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<bool> initTokenToHeader({bool initToken = true}) =>
      getTokenFromSharedPref().then((token) {
        // if (token?.isEmpty ?? true) {
        //   return true;
        // }
        if (_dio.options.headers.containsKey('Session-Token')) {
          _dio.options.headers.remove('Session-Token');
        }
        if (initToken) {
          _dio.options.headers.putIfAbsent('Session-Token', () => '$token');
          debugPrint('Session-Token==>$token');
        }
        return true;
      });

  ///initialize language code in header
  Future<bool> initLangPrefToHeader() =>
      getLanguageSharedPref().then((languageCode) async {
        if (_dio.options.headers.containsKey('lang')) {
          _dio.options.headers.remove('lang');
        }
        _dio.options.headers.putIfAbsent('lang', () => languageCode ?? 'en');
        return true;
      });

  Future<Response> fetchData({
    required String url,
    required HeaderMethod headerMethod,
    RequestMethod method = RequestMethod.get,
    Map<String, dynamic>? body = const {},
    Map<String, dynamic>? params = const {},
    File? file,
  }) async {
    try {
      final uri = Uri.parse('$urlBase$url').toString().log('URI');

      Response response;

      switch (method) {
        case RequestMethod.get:
          if (headerMethod == HeaderMethod.tokenHeader) {
            response = await initLangPrefToHeader()
                .then(
              (value) => initTokenToHeader()
                  // ignore: inference_failure_on_function_invocation
                  .then((value) => dio.get(uri, queryParameters: params)),
            )
                .catchError(
              // ignore: body_might_complete_normally_catch_error
              (ex) {
                onDioError(ex as DioException, 'apiName');
              },
              test: (ex) => ex is DioException,
            );
          } else {
            response = await initLangPrefToHeader()
                .then((value) => dio.get(uri, queryParameters: params));
          }
          response.log('response data');

        case RequestMethod.post:
          body.log('response');
          if (headerMethod == HeaderMethod.tokenHeader) {
            response = await initLangPrefToHeader().then(
              (value) => initTokenToHeader().then(
                (value) => dio.post(
                  uri,
                  data: FormData.fromMap(body ?? {}),
                ),
              ),
            );
          } else {
            response = await initLangPrefToHeader().then(
              (value) => dio.post(
                uri,
                data: FormData.fromMap(body ?? {}),
              ),
            );
          }

          response.log('response data');

        case RequestMethod.delete:
          if (headerMethod == HeaderMethod.tokenHeader) {
            response = await initLangPrefToHeader().then(
              (value) => initTokenToHeader()
                  .then((value) => dio.delete(uri, queryParameters: params)),
            );
          } else {
            response = await initLangPrefToHeader().then(
              (value) => dio.delete(uri, queryParameters: params),
            );
          }

          response.log('response data');
      }
      final res = await validateResStatusData(response);
      return res;
    } on DioException catch (e) {
      onDioError(e, urlBase);
      return Future.error(
        APIException(
          enumProperty: EnumAPIExceptions.dataSuccessFalse,
          message: 'Unexpected error',
        ),
      );
    }

    //  on SocketException {
    //   return Future.error(
    //     APIException(
    //       enumProperty: EnumAPIExceptions.sessionExpired,
    //       message: 'No Internet connection',
    //     ),
    //   );
    // } on FormatException {
    //   showToast('Bad Response format');
    //   return Future.error(
    //     APIException(
    //       enumProperty: EnumAPIExceptions.invalidResultType,
    //       message: 'Bad response format',
    //     ),
    //   );
    // } on Exception {
    //   return Future.error(
    //     APIException(
    //       enumProperty: EnumAPIExceptions.dataSuccessFalse,
    //       message: 'Unexpected error',
    //     ),
    //   );
    // }
  }

  ///initialize tenant code in header
  // Future<bool> initTenantPrefToHeader() =>
  //     getTenantCodeSharedPref().then((tenantCode) async {
  //       if (_dio.options.headers.containsKey('tenant')) {
  //         _dio.options.headers.remove('tenant');
  //       }
  //       _dio.options.headers.putIfAbsent('tenant', () => tenantCode ?? '0');
  //       return true;
  //     });
}
