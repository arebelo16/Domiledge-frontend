import 'package:dio/dio.dart';
import 'package:domiledge_frontend/core/services/storage_services.dart';

import '../../../config/env.dart';

class HttpService {
  final Dio _dio = Dio();

  HttpService() {
    _dio.options.baseUrl = Env.apiUrl;
  }

  Future<Response<dynamic>> post(String url, {Map<String, dynamic>? data, bool authRequired = true}) async {
    final token = authRequired ? await StorageService.getToken() : null;
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return _dio.post(
      url,
      data: data,
      options: Options(
        headers: headers,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  Future<Response<dynamic>> get(String url, {bool authRequired = true}) async {
    final token = authRequired ? await StorageService.getToken() : null;
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return _dio.get(url, options: Options(headers: headers));
  }

  Future<Response<dynamic>> put(String url, {Map<String, dynamic>? data}) async {
    final token = await StorageService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return _dio.put(url, data: data, options: Options(headers: headers));
  }

  Future<Response<dynamic>> delete(String url) async {
    final token = await StorageService.getToken();
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return _dio.delete(url, options: Options(headers: headers));
  }

  /// Multipart upload (ex.: cover image)
  Future<Response<dynamic>> postMultipart(
      String url, {
        required String fieldName,
        required String filePath,
        Map<String, String>? fields,
      }) async {
    final token = await StorageService.getToken();
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final form = FormData.fromMap({
      if (fields != null) ...fields,
      fieldName: await MultipartFile.fromFile(filePath),
    });

    return _dio.post(
      url,
      data: form,
      options: Options(headers: headers, contentType: 'multipart/form-data'),
    );
  }
}
