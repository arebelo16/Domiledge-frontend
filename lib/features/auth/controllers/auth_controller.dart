import 'package:domiledge_frontend/core/utils/result.dart';

import '../data/auth_api.dart';

class AuthController {
  const AuthController();

  Future<Result<bool>> login(String email, String password) =>
      AuthApi.login(email, password);

  Future<Result<bool>> isAuthenticated() => AuthApi.isAuthenticated();

  Future<void> logout() => AuthApi.logout();

  Future<Result<Map<String, dynamic>>> register(
    String username,
    String email,
    String password,
  ) {
    return AuthApi.register(
      username: username,
      email: email,
      password: password,
    );
  }

  Future<Result<bool>> accountExists(String email) =>
      AuthApi.accountExists(email);

  Future<Result<bool>> requestPasswordReset(String email) =>
      AuthApi.requestPasswordReset(email);

  Future<Result<bool>> validateReset(String rid, String token) =>
      AuthApi.validateReset(rid, token);

  Future<Result<bool>> resetPassword({
    required String rid,
    required String token,
    required String newPassword,
  }) => AuthApi.performReset(rid: rid, token: token, newPassword: newPassword);
}
