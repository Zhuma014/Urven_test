import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:urven/data/configs/app_config.dart';
import 'package:urven/data/preferences/preferences_manager.dart';


class DioService {
  late Dio _dio;
  BaseOptions? _baseOptions;
  final Map<String, String> _baseHeaders = {};

  static final DioService _instance = DioService.internal();

  DioService.internal() {
    _baseOptions = BaseOptions(
      baseUrl: AppConfigs.API_BASE_URL,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      validateStatus: (status) {
        if (status == null) return false;
        return status < 500;
      },
    );

    _dio = Dio(_baseOptions);

    if (AppConfigs.IS_DEBUG) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      )); // Logging interceptor
    }
  }

  factory DioService() => _instance;

  Future get({
    required String path,
    Map<String, dynamic>? requestParams,
  }) async {
    String? bearerToken = getBearerToken();
    if (bearerToken != null) {
      _baseHeaders['authorization'] = bearerToken;
      _baseOptions?.headers = _baseHeaders;
    }

    return (await _dio.get(
      path,
      queryParameters: requestParams,
    ))
        .data;
  }

  Future post({
    required String path,
    Map<String, dynamic>? requestParams,
    Map<String, dynamic>? body,
    FormData? data,
  }) async {
    String? bearerToken = getBearerToken();
    if (bearerToken != null) {
      _baseHeaders['Authorization'] = bearerToken;
      _baseOptions?.headers = _baseHeaders;
    }

    return (await _dio.post(
      path,
      queryParameters: requestParams,
      data: data ?? body,
    ))
        .data;
  }

  Future postFile({
    required String path,
    Map<String, dynamic>? requestParams,
    FormData? formData,
  }) async {
    String? bearerToken = getBearerToken();
    if (bearerToken != null) {
      _baseHeaders['authorization'] = bearerToken;
      _baseOptions?.headers = _baseHeaders;
    }

    return (await _dio.post(
      path,
      queryParameters: requestParams,
      data: formData,
    ))
        .data;
  }

  Future put({
    required String path,
    Map<String, dynamic>? requestParams,
    Map<String, dynamic>? body,
  }) async {
    String? bearerToken = getBearerToken();
    if (bearerToken != null) {
      _baseHeaders['Authorization'] = bearerToken;
      _baseOptions?.headers = _baseHeaders;
    }

    return (await _dio.put(
      path,
      queryParameters: requestParams,
      data: body,
    ))
        .data;
  }

  Future patch({
    required String path,
    Map<String, dynamic>? requestParams,
    Map? body,
  }) async {
    String? bearerToken = getBearerToken();
    if (bearerToken != null) {
      _baseHeaders['authorization'] = bearerToken;
      _baseOptions?.headers = _baseHeaders;
    }

    return (await _dio.patch(
      path,
      queryParameters: requestParams,
      data: jsonEncode(body),
    ))
        .data;
  }

  Future delete({
    required String path,
    Map<String, dynamic>? requestParams,
  }) async {
    String? bearerToken = getBearerToken();
    if (bearerToken != null) {
      _baseHeaders['authorization'] = bearerToken;
      _baseOptions?.headers = _baseHeaders;
    }

    FormData formData = FormData();
    return (await _dio.delete(
      path,
      queryParameters: requestParams,
      data: formData,
    ))
        .data;
  }

  String? getBearerToken() {
    String? token = PreferencesManager.instance.getAccessToken();
    if (token == null) return null;
    return 'Bearer $token';
  }
}


    // Refresh token, when token is expired. And call original endpoint again after refreshing the token
    // _dio.interceptors
    //     .add(InterceptorsWrapper(onError: (error, errorInterceptorHandler) async {
    //       if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
    //         await refreshToken();
    //         return _retry(error.requestOptions);
    //       }
    //       return errorInterceptorHandler.next(error);
    // }));
  


  // Future<SignIn> refreshToken() async {
  //   try {
  //     String refreshToken = PreferencesManager.instance.getRefreshToken();
  //     Map<String, dynamic> data = {
  //       'refresh_token': refreshToken
  //     };
  //     return SignIn.map(await post(path: REFRESH_TOKEN, body: data));
  //   } catch (error) {
  //     print("askldjaskldjalksd errrorrr refreshToken" + error.toString());
  //     return SignIn.withError(error);
  //   }
  // }
  //
  // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   final options = new Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //   );
  //   return this._dio.request<dynamic>(requestOptions.path,
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options);
  // }

 