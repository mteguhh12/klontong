import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:klontong/src/data/app_api.dart';
import 'package:klontong/src/data/preferences/app_preferences.dart';
import 'package:klontong/src/utils/app_config.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/logger.dart';
import 'package:klontong/src/utils/utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const _defaultConnectTimeout = Duration(minutes: 1);
const _defaultReceiveTimeout = Duration(minutes: 1);

class AppClient {
  late AppApi appClient;
  late Link link;
  late Dio dio;

  AppClient._privateConstructor() {
    _setupClient();
  }

  static final AppClient _instance = AppClient._privateConstructor();

  factory AppClient() {
    return _instance;
  }

  void _setupClient() {
    dio = Dio(BaseOptions(
        baseUrl: AppConfig.environment.apiEndpoint,
        receiveTimeout: Duration(minutes: 1),
        connectTimeout: Duration(minutes: 1),
        contentType: "application/json;charset=UTF-8"));
    dio
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};

    // if (AppConfig.environment != Environment.PRODUCTION) {
    //   dio.interceptors.add(alice.getDioInterceptor());
    // }
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 1000));
    }

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      //options.headers["Accept-Language"] = appPreferences.appLanguage;
      String? deviceToken =
          appPreferences.getString(Const.HEADER_KEY_DEVICE_TOKEN);
      if (deviceToken == null) {
        deviceToken = Utils.getRandString(255);
        appPreferences.setData(Const.HEADER_KEY_DEVICE_TOKEN, deviceToken);
      }
      options.headers["X-Device-Token"] = deviceToken;
      // String? accessToken = appPreferences.loginResponse?.accessToken;
      // String? accessToken = "";
      // if (!Utils.isEmpty(accessToken) && accessToken != null) {
      //   options.headers["Authorization"] = "Bearer $accessToken";
      //   dio.options.headers["Authorization"] = "Bearer $accessToken";
      // } else {
      //   options.headers.remove("Authorization");
      //   dio.options.headers.remove("Authorization");
      // }
      return handler.next(options);
    }, onResponse: (response, handler) async {
      if (response.data is Map && response.data?["errors"] != null) {
        return handler.reject(DioException(
            requestOptions: response.requestOptions,
            error: "${response.data["errors"].toString()}",
            type: DioExceptionType.unknown,
            response: response));
      }
      return handler.next(response);
    }, onError: (DioException error, ErrorInterceptorHandler handler) async {
      logger.d("DioError request: ${error.requestOptions.toString()}");
      logger.d("DioError message: ${error.message}");
      if (error.response?.statusCode == 401) {
        logger.e("UnAuthorization");

        return handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: error,
            type: error.type,
            response: error.response));
      }
      if (error.error is SocketException) {
        logger.e("${error.error}");
      }
      return handler.next(error); //continue
    }));
    appClient = AppApi(dio);
  }
}

AppApi appClient = AppClient().appClient;
Link link = AppClient().link;
Dio dio = AppClient().dio;
