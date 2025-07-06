import 'package:staywise_frontend/features/auth/data/auth_api.dart';
import 'package:staywise_frontend/features/auth/model/login_request.dart';
import '../../../core/services/storage_services.dart';

class AuthController {
  final AuthApi _api = AuthApi();

  Future<bool> login(String username, String password) async {
    try {
      final response = await _api.login(LoginRequest(username: username, password: password));
      await StorageService.saveToken(response.token);
      return true;
    } catch (_) {
      return false;
    }
  }
}
