import '../../../core/services/http_services.dart';
import 'dto/user_profile_dto.dart';
import 'dto/active_session_dto.dart';

class AccountApi {
  final _http = HttpService();

  Future<UserProfileDto> getMe() async {
    final r = await _http.get('/account/me');
    if (r.statusCode == 200) {
      return UserProfileDto.fromJson(Map<String, dynamic>.from(r.data));
    }
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro a obter perfil')
          : 'Erro a obter perfil',
    );
  }

  Future<UserProfileDto> updateMe(UserProfileDto dto) async {
    final r = await _http.put('/account/me', data: dto.toUpdateJson());
    if (r.statusCode == 200) {
      return UserProfileDto.fromJson(Map<String, dynamic>.from(r.data));
    }
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro a atualizar perfil')
          : 'Erro a atualizar perfil',
    );
  }

  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    final r = await _http.post(
      '/account/me/change-password',
      data: {'current': current, 'next': next},
    );
    if (r.statusCode == 200 || r.statusCode == 204) return;
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro a alterar password')
          : 'Erro a alterar password',
    );
  }

  Future<void> toggle2FA(bool enable) async {
    final r = await _http.post(
      '/account/me/2fa/${enable ? 'enable' : 'disable'}',
    );
    if (r.statusCode == 200 || r.statusCode == 204) return;
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro ao alternar 2FA')
          : 'Erro ao alternar 2FA',
    );
  }

  Future<List<ActiveSessionDto>> sessions() async {
    final r = await _http.get('/account/me/sessions');
    if (r.statusCode == 200) {
      return (r.data as List)
          .cast<Map>()
          .map((e) => ActiveSessionDto.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro a obter sessões')
          : 'Erro a obter sessões',
    );
  }

  Future<void> revokeSession(String id) async {
    final r = await _http.delete('/account/me/sessions/$id');
    if (r.statusCode == 200 || r.statusCode == 204) return;
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro a revogar sessão')
          : 'Erro a revogar sessão',
    );
  }

  Future<void> exportData() async {
    final r = await _http.post('/account/me/export');
    if (r.statusCode == 200 || r.statusCode == 202) return;
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro a exportar dados')
          : 'Erro a exportar dados',
    );
  }

  Future<void> deleteAccount() async {
    final r = await _http.delete('/account/me');
    if (r.statusCode == 200 || r.statusCode == 202 || r.statusCode == 204)
      return;
    throw Exception(
      r.data is Map
          ? (r.data['error'] ?? 'Erro a eliminar conta')
          : 'Erro a eliminar conta',
    );
  }
}
