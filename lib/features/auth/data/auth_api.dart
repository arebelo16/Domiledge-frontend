import 'dart:developer';

import '../../../config/env.dart';
import '../../../core/services/http_services.dart';
import '../../../core/utils/result.dart';
import '../model/auth_response.dart';
import '../model/login_request.dart';
import '../model/register_request.dart';

class AuthApi {
  final _http = HttpService();

  Future<String?> login(LoginRequest request) async {
    final response = await _http.post(
      '${Env.apiUrl}/auth/login',
      data: request.toJson(),
      authRequired: false,
    );
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data).token;
    }
    return null;
  }

  Future<Result<bool>> register(RegisterRequest request) async {
    try {
      final response = await _http.post(
        '${Env.apiUrl}/auth/register',
        data: request.toJson(),
        authRequired: false,
      );

      if (response.statusCode == 200) {
        return Result.success(true);
      } else {
        final error = response.data['error'] ?? 'Unknown error';
        return Result.failure(error);
      }
    } catch (e) {
      return Result.failure('Network error');
    }
  }

  Future<void> logout() async {
    final response = await _http.post('${Env.apiUrl}/auth/logout');
    if (response.statusCode != 200)
      log("Logout from server failed. ${response.statusMessage}");
  }
}
