import 'package:domiledge_frontend/core/utils/result.dart';
import '../data/auth_api.dart';

class AuthController {
  const AuthController();

  Future<bool> login(String email, String password) async {
    return await AuthApi.login(email, password);
  }

  Future<bool> isAuthenticated() async {
    return await AuthApi.isAuthenticated();
  }

  Future<void> logout() async {
    await AuthApi.logout();
  }

  ///TODO Register (stub for now). Replace with real API call when ready.
  Future<Result<bool>> register(String username, String password, String email) async {
    return Result.failure('Register not implemented with sessions yet');
  }
}
