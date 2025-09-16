import '../../../core/utils/result.dart';
import '../data/account_api.dart';
import '../data/dto/active_session_dto.dart';
import '../data/dto/user_profile_dto.dart';
import '../model/active_session.dart';
import '../model/user_profile.dart';
import '../utils/user_profile_mapper.dart';

class AccountController {
  final _api = AccountApi();

  // ===================== PROFILE =====================

  Future<Result<UserProfile>> fetchProfileResult() async {
    final res = await _api.getMe();
    return res.when(
      success: (UserProfileDto dto) =>
          Result.success(UserProfileMapper.mapUser(dto)),
      failure: (msg) => Result.failure(msg),
    );
  }

  Future<Result<UserProfile>> updateProfileResult(UserProfile model) async {
    final dto = UserProfileMapper.toDto(model);
    final res = await _api.updateMe(dto);
    return res.when(
      success: (UserProfileDto updated) =>
          Result.success(UserProfileMapper.mapUser(updated)),
      failure: (msg) => Result.failure(msg),
    );
  }

  // ===================== SECURITY =====================

  Future<Result<bool>> changePasswordResult({
    required String current,
    required String next,
  }) async {
    final res = await _api.changePassword(current: current, next: next);
    return res;
  }

  Future<Result<bool>> toggle2FAResult(bool enable) async {
    final res = await _api.toggle2FA(enable);
    return res;
  }

  // ===================== SESSIONS =====================

  Future<Result<List<ActiveSession>>> fetchSessionsResult() async {
    final res = await _api.sessions();
    return res.when(
      success: (List<ActiveSessionDto> dtos) =>
          Result.success(dtos.map(ActiveSession.fromDto).toList()),
      failure: (msg) => Result.failure(msg),
    );
  }

  Future<Result<bool>> revokeSessionResult(ActiveSession s) async {
    final res = await _api.revokeSession(s.id);
    return res;
  }

  // ===================== DATA & ACCOUNT =====================

  Future<Result<bool>> exportDataResult() => _api.exportData();

  Future<Result<bool>> deleteAccountResult() => _api.deleteAccount();
}
