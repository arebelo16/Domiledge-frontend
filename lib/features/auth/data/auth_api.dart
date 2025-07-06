import 'dart:convert';

import 'package:staywise_frontend/features/auth/model/login_request.dart';
import 'package:staywise_frontend/features/auth/model/auth_response.dart';
import '../../../config/env.dart';
import '../../../core/services/http_services.dart';

class AuthApi {
  final HttpService _httpService = HttpService();

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _httpService.post('${Env.apiUrl}/auth/login', request.toJson());

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed');
    }
  }
}
