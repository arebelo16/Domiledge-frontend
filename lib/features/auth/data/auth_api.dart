import '../../../core/services/http_services.dart';
import '../../../core/utils/result.dart';
import '../model/auth_response.dart';
import '../model/login_request.dart';
import '../model/register_request.dart';

class AuthApi {
  final _http = HttpService();

  Future<String?> login(LoginRequest request) async {
    final res = await _http.post(
      '/auth/login',
      data: request.toJson(),
      authRequired: false,
    );
    if (res.statusCode == 200) return AuthResponse.fromJson(res.data).token;
    return null;
  }

  Future<Result<bool>> register(RegisterRequest request) async {
    try {
      final res = await _http.post(
        '/auth/register',
        data: request.toJson(),
        authRequired: false,
      );
      if (res.statusCode == 200) return Result.success(true);
      final error = res.data is Map
          ? (res.data['error'] ?? 'Unknown error')
          : 'Unknown error';
      return Result.failure(error);
    } catch (_) {
      return Result.failure('Network error');
    }
  }

  Future<void> logout() async {
    await _http.post('/auth/logout', authRequired: true);
  }
}
