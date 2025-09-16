import 'dart:io' show HttpStatus;

import 'package:dio/dio.dart';

import '../../../core/services/http_services.dart';
import '../../../core/utils/result.dart';
import 'dto/active_session_dto.dart';
import 'dto/user_profile_dto.dart';

class AccountApi {
  final HttpService _http;

  AccountApi() : _http = HttpService();

  String _extractError(Response? r, String fallback) {
    final data = r?.data;
    if (data is Map && data['error'] is String) return data['error'] as String;
    if (r?.statusCode == HttpStatus.unauthorized) return 'Não autenticado';
    return fallback;
  }

  // ===================== Endpoints =====================

  Future<Result<UserProfileDto>> getMe() async {
    try {
      final r = await _http.get('/account/me');
      if (r.statusCode == HttpStatus.ok) {
        return Result.success(
          UserProfileDto.fromJson(Map<String, dynamic>.from(r.data)),
        );
      }
      return Result.failure(_extractError(r, 'Erro a obter perfil'));
    } on DioException catch (e) {
      return Result.failure(_extractError(e.response, 'Erro a obter perfil'));
    } catch (_) {
      return Result.failure('Erro a obter perfil');
    }
  }

  Future<Result<UserProfileDto>> updateMe(UserProfileDto dto) async {
    try {
      final r = await _http.put('/account/me', data: dto.toUpdateJson());
      if (r.statusCode == HttpStatus.ok) {
        return Result.success(
          UserProfileDto.fromJson(Map<String, dynamic>.from(r.data)),
        );
      }
      return Result.failure(_extractError(r, 'Erro a atualizar perfil'));
    } on DioException catch (e) {
      return Result.failure(
        _extractError(e.response, 'Erro a atualizar perfil'),
      );
    } catch (_) {
      return Result.failure('Erro a atualizar perfil');
    }
  }

  Future<Result<bool>> changePassword({
    required String current,
    required String next,
  }) async {
    try {
      final r = await _http.post(
        '/account/me/change-password',
        data: {'current': current, 'next': next},
      );
      if (r.statusCode == HttpStatus.noContent ||
          r.statusCode == HttpStatus.ok) {
        return Result.success(true);
      }
      return Result.failure(_extractError(r, 'Erro a alterar password'));
    } on DioException catch (e) {
      return Result.failure(
        _extractError(e.response, 'Erro a alterar password'),
      );
    } catch (_) {
      return Result.failure('Erro a alterar password');
    }
  }

  Future<Result<bool>> toggle2FA(bool enable) async {
    try {
      final r = await _http.post(
        '/account/me/2fa/${enable ? 'enable' : 'disable'}',
      );
      if (r.statusCode == HttpStatus.noContent ||
          r.statusCode == HttpStatus.ok) {
        return Result.success(true);
      }
      return Result.failure(_extractError(r, 'Erro ao alternar 2FA'));
    } on DioException catch (e) {
      return Result.failure(_extractError(e.response, 'Erro ao alternar 2FA'));
    } catch (_) {
      return Result.failure('Erro ao alternar 2FA');
    }
  }

  Future<Result<List<ActiveSessionDto>>> sessions() async {
    try {
      final r = await _http.get('/account/me/sessions');
      if (r.statusCode == HttpStatus.ok) {
        final list = (r.data as List? ?? const []).cast<Map>();
        final dtos = list
            .map((e) => ActiveSessionDto.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return Result.success(dtos);
      }
      return Result.failure(_extractError(r, 'Erro a obter sessões'));
    } on DioException catch (e) {
      return Result.failure(_extractError(e.response, 'Erro a obter sessões'));
    } catch (_) {
      return Result.failure('Erro a obter sessões');
    }
  }

  Future<Result<bool>> revokeSession(String id) async {
    try {
      final r = await _http.delete('/account/me/sessions/$id');
      if (r.statusCode == HttpStatus.noContent ||
          r.statusCode == HttpStatus.ok) {
        _http.clearSession();
        return Result.success(true);
      }
      return Result.failure(_extractError(r, 'Erro a revogar sessão'));
    } on DioException catch (e) {
      return Result.failure(_extractError(e.response, 'Erro a revogar sessão'));
    } catch (_) {
      return Result.failure('Erro a revogar sessão');
    }
  }

  Future<Result<bool>> exportData() async {
    try {
      final r = await _http.post('/account/me/export');
      if (r.statusCode == HttpStatus.accepted ||
          r.statusCode == HttpStatus.ok) {
        return Result.success(true);
      }
      return Result.failure(_extractError(r, 'Erro a exportar dados'));
    } on DioException catch (e) {
      return Result.failure(_extractError(e.response, 'Erro a exportar dados'));
    } catch (_) {
      return Result.failure('Erro a exportar dados');
    }
  }

  Future<Result<bool>> deleteAccount() async {
    try {
      final r = await _http.delete('/account/me');
      if (r.statusCode == HttpStatus.noContent ||
          r.statusCode == HttpStatus.accepted ||
          r.statusCode == HttpStatus.ok) {
        return Result.success(true);
      }
      return Result.failure(_extractError(r, 'Erro a eliminar conta'));
    } on DioException catch (e) {
      return Result.failure(_extractError(e.response, 'Erro a eliminar conta'));
    } catch (_) {
      return Result.failure('Erro a eliminar conta');
    }
  }
}
