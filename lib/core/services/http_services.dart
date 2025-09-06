import 'package:dio/dio.dart';
import 'package:domiledge_frontend/core/services/storage_services.dart';
import '../../config/env.dart';
import 'package:flutter/foundation.dart';

class HttpService {
  final Dio _dio;

  HttpService._(this._dio);

  factory HttpService() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        validateStatus: (s) => s != null && s < 500,
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: false,
        error: true,
        logPrint: (o) {
          if (kDebugMode) debugPrint(o.toString());
        },
      ),
    );

    return HttpService._(dio);
  }

  Future<Response> get(String path, {bool authRequired = true}) async {
    return _dio.get(
      path,
      options: Options(headers: await _headers(authRequired)),
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    bool authRequired = true,
  }) async {
    return _dio.post(
      path,
      data: data,
      options: Options(headers: await _headers(authRequired)),
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    bool authRequired = true,
  }) async {
    return _dio.put(
      path,
      data: data,
      options: Options(headers: await _headers(authRequired)),
    );
  }

  Future<Response> delete(String path, {bool authRequired = true}) async {
    return _dio.delete(
      path,
      options: Options(headers: await _headers(authRequired)),
    );
  }

  Future<Response> postMultipart(
    String path, {
    required String fieldName,
    required String filePath,
    Map<String, String>? fields,
  }) async {
    final form = FormData.fromMap({
      if (fields != null) ...fields,
      fieldName: await MultipartFile.fromFile(filePath),
    });
    return _dio.post(
      path,
      data: form,
      options: Options(
        headers: await _headers(true),
        contentType: 'multipart/form-data',
      ),
    );
  }

  Future<Map<String, String>> _headers(bool authRequired) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authRequired) {
      final token = await StorageService.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
