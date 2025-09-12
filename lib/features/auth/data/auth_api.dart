import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;
import '../../../config/env.dart';

class AuthApi {
  AuthApi._();

  static final http.Client _client = http.Client();

  static String get _base => Env.apiUrl;

  static Uri _u(String path) => Uri.parse('$_base$path');

  static Future<bool> login(String email, String password) async {
    await _prefetchCsrf();

    final body =
        'email=${Uri.encodeQueryComponent(email)}&password=${Uri.encodeQueryComponent(password)}';

    final res = await _client.post(
      _u('/auth/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        ..._csrfHeaderIfPresent(),
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
    await _prefetchCsrf();
    final res = await _client.post(
      _u('/auth/logout'),
      headers: _csrfHeaderIfPresent(),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      // TODO: handle errors or logging if needed
    }
  }

  // =================== CSRF helpers ===================

  /// Force Backend to issue the XSRF-TOKEN cookie
  /// This should be called before sending state-changing requests (POST, PUT, PATCH, DELETE)
  static Future<void> _prefetchCsrf() async {
    await _client.get(_u('/auth/me'));
  }

  /// Read the XSRF-TOKEN cookie and return it as a header.
  static Map<String, String> _csrfHeaderIfPresent() {
    final token = _readCookie('XSRF-TOKEN');
    return token == null ? const {} : {'X-XSRF-TOKEN': token};
  }

  /// Read cookies in Web
  static String? _readCookie(String name) {
    final cookieStr = web.document.cookie ?? '';
    if (cookieStr.isEmpty) return null;

    for (final part in cookieStr.split(';')) {
      final kv = part.trim().split('=');
      if (kv.length == 2 && kv.first == name) {
        return Uri.decodeComponent(kv[1]);
      }
    }
    return null;
  }
}
