import '../../../core/services/storage_services.dart';
import '../data/auth_api.dart';
import '../model/login_request.dart';
import '../model/register_request.dart';

class AuthController {
  final _api = AuthApi();

  Future<bool> login(String username, String password) async {
    final token = await _api.login(LoginRequest(username: username, password: password));
    if (token != null) {
      await StorageService.saveToken(token);
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String email) async {
    return await _api.register(RegisterRequest(username: username, password: password, email: email));
  }

  Future<bool> logout() async {
    return await _api.logout();
  }
}
                           