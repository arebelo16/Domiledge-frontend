import 'package:domiledge_frontend/features/account/utils/theme_mapper.dart';

import '../data/dto/user_profile_dto.dart';
import '../model/user_profile.dart';

class UserProfileMapper {
  static UserProfile mapUser(UserProfileDto dto) => UserProfile(
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

  static UserProfileDto toDto(UserProfile m) => UserProfileDto(
    id: m.id,
    name: m.name,
    email: m.email,
    role: m.role,
    theme: ThemeMapper.toApi(m.themeMode),
    twoFactorEnabled: m.twoFactorEnabled,
    notifyEmail: m.notifyEmail,
    notifyPush: m.notifyPush,
    plan: m.plan,
    createdAt: m.createdAt,
    lastLoginAt: m.lastLoginAt,
    phone: m.phone,
    country: m.country,
    city: m.city,
    address: m.address,
    vatNumber: m.vatNumber,
    companyName: m.companyName,
  );
}
