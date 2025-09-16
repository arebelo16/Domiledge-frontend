import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/browser.dart' as dio_web;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../config/env.dart';

class HttpService {
  final Dio _dio;
  CookieJar? _jar;
  String? _csrfToken;
  String _csrfHeader = 'X-XSRF-TOKEN';

  HttpService._(this._dio);

  factory HttpService() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        validateStatus: (s) => s != null && s < 600,
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    CookieJar? jar;

    if (kIsWeb) {
      final adapter = dio_web.BrowserHttpClientAdapter()
        ..withCredentials = true;
      dio.httpClientAdapter = adapter;
      dio.options.extra['withCredentials'] = true;
    } else {
      jar = CookieJar();
      dio.interceptors.add(CookieManager(jar));
    }

    final service = HttpService._(dio);
    service._jar = jar;

    // -------- CSRF fetch --------
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final m = options.method.toUpperCase();
          final needsCsrf =
              m == 'POST' || m == 'PUT' || m == 'PATCH' || m == 'DELETE';
          if (needsCsrf) {
            if (service._csrfToken == null) {
              await service._refreshCsrfTokenIfNeeded(dio);
            }
            final t = service._csrfToken;
            if (t != null && t.isNotEmpty) {
              options.headers[service._csrfHeader] = t;
            }
          }
          handler.next(options);
        },

        onResponse: (response, handler) async {
          final code = response.statusCode ?? 0;
          if (code == 401) {
            service
                .clearCsrf();
          } else if (code == 403 && _looksLikeCsrfError(response)) {
            final req = response.requestOptions;
            final alreadyRetried = req.extra['csrfRetried'] == true;
            final mutating = _isMutating(req.method);
            if (mutating && !alreadyRetried) {
              service.clearCsrf();
              final retried = await service._retryWithFreshCsrf(dio, req);
              return handler.resolve(retried);
            }

            service.clearCsrf();
          }
          handler.next(response);
        },

        onError: (err, handler) async {
          handler.next(err);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: false,
        error: true,
      ),
    );

    return service;
  }

  // ===================== Internals =====================

  static bool _isMutating(String method) {
    final m = method.toUpperCase();
    return m == 'POST' || m == 'PUT' || m == 'PATCH' || m == 'DELETE';
  }

  static bool _looksLikeCsrfError(Response r) {
    final data = r.data;
    if (data is Map) {
      final err = data['error']?.toString().toLowerCase() ?? '';
      final msg = data['message']?.toString().toLowerCase() ?? '';
      if (err.contains('csrf') || msg.contains('csrf')) return true;
    }

    final hdr = r.headers.value('X-CSRF-ERROR')?.toLowerCase() ?? '';
    return hdr.contains('invalid') || hdr.contains('csrf');
  }

  Future<void> _refreshCsrfTokenIfNeeded(Dio dio) async {
    if (_csrfToken != null) return;
    try {
      final res = await dio.get('/auth/csrf');
      if (res.statusCode == 200 && res.data is Map) {
        final map = Map<String, dynamic>.from(res.data as Map);
        _csrfToken = map['token'] as String?;
        _csrfHeader = (map['headerName'] as String?) ?? 'X-XSRF-TOKEN';
      }
    } catch (_) {}
  }

  Future<Response> _retryWithFreshCsrf(Dio dio, RequestOptions original) async {
    await _refreshCsrfTokenIfNeeded(dio);

    final newHeaders = Map<String, dynamic>.from(original.headers);
    if (_csrfToken != null && _csrfToken!.isNotEmpty) {
      newHeaders[_csrfHeader] = _csrfToken!;
    } else {
      newHeaders.remove(_csrfHeader);
    }

    return dio.request(
      original.path,
      data: original.data,
      queryParameters: original.queryParameters,
      options: Options(
        method: original.method,
        headers: newHeaders,
        responseType: original.responseType,
        followRedirects: original.followRedirects,
        sendTimeout: original.sendTimeout,
        receiveTimeout: original.receiveTimeout,
        contentType: original.contentType,
        listFormat: original.listFormat,
        // marca para não entrar em loop
        extra: {...original.extra, 'csrfRetried': true},
      ),
      cancelToken: original.cancelToken,
      onReceiveProgress: original.onReceiveProgress,
      onSendProgress: original.onSendProgress,
    );
  }

  // ===================== Helpers JSON =====================

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) => _dio.post(path, data: data, queryParameters: queryParameters);

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) => _dio.put(path, data: data, queryParameters: queryParameters);

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) => _dio.patch(path, data: data, queryParameters: queryParameters);

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _dio.delete(path, queryParameters: queryParameters);

  Future<Response> postForm(
    String path,
    Map<String, String> fields, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(
      path,
      data: fields,
      queryParameters: queryParameters,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  void clearCsrf() => _csrfToken = null;

  Future<void> clearSession() async {
    clearCsrf();
    try {
      await _jar?.deleteAll();
    } catch (_) {}
  }

  Future<Response> postMultipart(
    String path, {
    required String fieldName,
    required String filePath,
    Map<String, String>? fields,
    Map<String, dynamic>? queryParameters,
  }) async {
    final form = FormData.fromMap({
      if (fields != null) ...fields,
      fieldName: await MultipartFile.fromFile(filePath),
    });
    return _dio.post(
      path,
      data: form,
      queryParameters: queryParameters,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
