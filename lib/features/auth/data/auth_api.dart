// lib/features/auth/data/auth_api.dart
import 'package:dio/dio.dart';
import 'package:web/web.dart' hide Response;

import '../../../core/services/http_services.dart';
import '../../../core/utils/result.dart';

class AuthApi {
  AuthApi._();

  static final HttpService _http = HttpService();

  static Future<Result<bool>> login(String email, String password) async {
    try {
      final res = await _http.postForm('/auth/login', {
        'login': email,
        'password': password,
      });

      if (res.statusCode == 200) {
        return Result.success(true);
      }

      return Result.failure(null);
    } catch (e) {
      return Result.failure('Erro no login: $e');
    }
  }

  static Future<Result<Map<String, dynamic>>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final Response res = await _http.post(
        '/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      if (res.statusCode == 200) {
        final data = (res.data is Map<String, dynamic>)
            ? res.data as Map<String, dynamic>
            : <String, dynamic>{};
        return Result.success(data);
      }

      if (res.statusCode == 400) {
        try {
          final map = (res.data is Map)
              ? Map<String, dynamic>.from(res.data as Map)
              : const <String, dynamic>{};
          return Result.failure(map['error']?.toString() ?? 'Invalid data');
        } catch (_) {
          return Result.failure('Invalid data');
        }
      }

      return Result.failure('Unexpected error (${res.statusCode}).');
    } catch (e) {
      return Result.failure('Erro no registo: $e');
    }
  }

  static Future<Result<bool>> isAuthenticated() async {
    try {
      final res = await _http.get('/account/me');
      if (res.statusCode == HttpStatus.ok) {
        return Result.success(true);
      }
      return Result.failure('Não esta autenticado.');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  static Future<void> logout() async {
    _http.clearSession();
    await _http.post('/auth/logout');
  }

  static Future<Result<bool>> accountExists(String email) async {
    try {
      final r = await _http.get(
        '/auth/account-exists',
        queryParameters: {'email': email},
      );
      if (r.statusCode == HttpStatus.ok) {
        return Result.success(true);
      }
      return Result.failure('Não foi possível verificar a conta.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 400) {
        return Result.success(false);
      }
      return Result.failure('Falha a verificar a conta.');
    } catch (_) {
      return Result.failure('Erro inesperado.');
    }
  }

  static Future<Result<bool>> requestPasswordReset(String email) async {
    try {
      final r = await _http.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      if (r.statusCode == HttpStatus.accepted) return Result.success(true);
      return Result.failure('Não foi possível processar o pedido.');
    } on DioException catch (e) {
      return Result.failure(
        e.response?.data?['error']?.toString() ?? 'Falha de rede.',
      );
    } catch (_) {
      return Result.failure('Erro inesperado.');
    }
  }

  static Future<Result<bool>> validateReset(String rid, String token) async {
    try {
      final r = await _http.get(
        '/auth/reset-password/validate',
        queryParameters: {'rid': rid, 'token': token},
      );
      if (r.statusCode == HttpStatus.ok) return Result.success(true);
      return Result.failure('Link inválido ou expirado.');
    } on DioException catch (_) {
      return Result.failure('Link inválido ou expirado.');
    } catch (_) {
      return Result.failure('Erro inesperado.');
    }
  }

  static Future<Result<bool>> performReset({
    required String rid,
    required String token,
    required String newPassword,
  }) async {
    try {
      final r = await _http.post(
        '/auth/reset-password',
        data: {'rid': rid, 'token': token, 'newPassword': newPassword},
      );
      if (r.statusCode == HttpStatus.noContent) return Result.success(true);
      return Result.failure('Não foi possível redefinir a password.');
    } on DioException catch (e) {
      return Result.failure(
        e.response?.data?['error']?.toString() ??
            'Falha ao redefinir password.',
      );
    } catch (_) {
      return Result.failure('Erro inesperado.');
    }
  }
}
