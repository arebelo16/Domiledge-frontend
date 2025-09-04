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
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
  }


  Future<Response> get(String url) async {
    final token = await StorageService.getToken();
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return _dio.get(url, options: Options(headers: headers));
  }
}
