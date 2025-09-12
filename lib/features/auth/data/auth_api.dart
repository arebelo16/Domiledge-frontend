import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart' show BrowserClient;
import '../../../config/env.dart';

class AuthApi {
  AuthApi._();

  static final http.Client _client = kIsWeb
      ? (BrowserClient()..withCredentials = true)
      : http.Client();

  static String get _base => Env.apiUrl;

  static Uri _u(String p) => Uri.parse('$_base$p');

  static Future<String?> _fetchCsrfToken() async {
    try {
      final res = await _client
          .get(_u('/auth/csrf'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final m = jsonDecode(res.body) as Map<String, dynamic>;
        return m['token'] as String?;
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> login(String email, String password) async {
    final token =
        await _fetchCsrfToken();

    final body =
        'email=${Uri.encodeQueryComponent(email)}&password=${Uri.encodeQueryComponent(password)}';

    final res = await _client.post(
      _u('/auth/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        if (token != null) 'X-XSRF-TOKEN': token,
      },
      body: body,
    );
    return res.statusCode == 200;
  }

  static Future<bool> isAuthenticated() async {
    try {
      final res = await _client
          .get(_u('/auth/me'))
          .timeout(const Duration(seconds: 8));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<void> logout() async {
    final token = await _fetchCsrfToken();
    await _client.post(
      _u('/auth/logout'),
      headers: {if (token != null) 'X-XSRF-TOKEN': token},
    );
  }
}
