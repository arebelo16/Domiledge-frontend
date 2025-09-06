import 'package:flutter/material.dart';
import '../data/account_api.dart';
import '../data/dto/user_profile_dto.dart';
import '../data/dto/active_session_dto.dart';
import '../model/user_profile.dart';
import '../model/active_session.dart';
import '../utils/theme_mapper.dart';

class AccountController {
  final _api = AccountApi();

  Future<UserProfile> fetchProfile() async {
    final dto = await _api.getMe();

    return UserProfile(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      role: dto.role,
      phone: dto.phone,
      country: dto.country,
      city: dto.city,
      address: dto.address,
      createdAt: dto.createdAt,
      lastLoginAt: dto.lastLoginAt,
      twoFactorEnabled: dto.twoFactorEnabled,
      themeMode: ThemeMapper.toMode(dto.theme),
      notifyEmail: dto.notifyEmail,
      notifyPush: dto.notifyPush,
      plan: dto.plan,
      vatNumber: dto.vatNumber,
      companyName: dto.companyName,
    );
  }

  Future<UserProfile> updateProfile(UserProfile model) async {
    final dto = UserProfileDto(
      id: model.id,
      name: model.name,
      email: model.email,
      role: model.role,
      theme: ThemeMapper.toApi(model.themeMode),
      twoFactorEnabled: model.twoFactorEnabled,
      notifyEmail: model.notifyEmail,
      notifyPush: model.notifyPush,
      plan: model.plan,
      createdAt: model.createdAt,
      lastLoginAt: model.lastLoginAt,
      phone: model.phone,
      country: model.country,
      city: model.city,
      address: model.address,
      vatNumber: model.vatNumber,
      companyName: model.companyName,
    );

    final updated = await _api.updateMe(dto);

    return UserProfile(
      id: updated.id,
      name: updated.name,
      email: updated.email,
      role: updated.role,
      phone: updated.phone,
      country: updated.country,
      city: updated.city,
      address: updated.address,
      createdAt: updated.createdAt,
      lastLoginAt: updated.lastLoginAt,
      twoFactorEnabled: updated.twoFactorEnabled,
      themeMode: ThemeMapper.toMode(updated.theme),
      notifyEmail: updated.notifyEmail,
      notifyPush: updated.notifyPush,
      plan: updated.plan,
      vatNumber: updated.vatNumber,
      companyName: updated.companyName,
    );
  }

  Future<void> changePassword({
    required String current,
    required String next,
  }) => _api.changePassword(current: current, next: next);

  Future<void> toggle2FA(bool enable) => _api.toggle2FA(enable);

  Future<List<ActiveSession>> fetchSessions() async {
    final list = await _api.sessions();
    return list.map(_mapSession).toList();
  }

  Future<void> revokeSession(ActiveSession s) =>
      _api.revokeSession(s.id);

  Future<void> exportData() => _api.exportData();
  Future<void> deleteAccount() => _api.deleteAccount();

  ActiveSession _mapSession(ActiveSessionDto d) => ActiveSession(
    id: d.id,
    device: d.device,
    ip: d.ip,
    lastSeen: d.lastSeen,
  );
}
