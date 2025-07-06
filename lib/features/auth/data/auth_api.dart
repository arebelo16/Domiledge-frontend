import 'package:http/src/response.dart';

import '../../../core/services/http_services.dart';
import '../model/login_request.dart';
import '../model/register_request.dart';
import '../model/auth_response.dart';
import '../../../config/env.dart';

class AuthApi {
  final _http = HttpService();

  Future<String?> login(LoginRequest request) async {
    final response = await _http.post('${Env.apiUrl}/auth/login', data: request.toJson());
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data).token;
    }
    return null;
  }

  Future<bool> register(RegisterRequest request) async {
    final response = await _http.post('${Env.apiUrl}/auth/register', data: request.toJson());
    return response.statusCode == 200;
  }
}