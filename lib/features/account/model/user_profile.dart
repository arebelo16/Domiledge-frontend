import 'package:flutter/material.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? country;
  final String? city;
  final String? address;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool twoFactorEnabled;
  final ThemeMode themeMode;
  final bool notifyEmail;
  final bool notifyPush;
  final String plan;
  final String? vatNumber;
  final String? companyName;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.lastLoginAt,
    required this.twoFactorEnabled,
    required this.themeMode,
    required this.notifyEmail,
    required this.notifyPush,
    required this.plan,
    this.phone,
    this.country,
    this.city,
    this.address,
    this.vatNumber,
    this.companyName,
  });

  UserProfile copyWith({
    String? name,
    String? phone,
    String? country,
    String? city,
    String? address,
    ThemeMode? themeMode,
    bool? twoFactorEnabled,
    bool? notifyEmail,
    bool? notifyPush,
    String? plan,
    String? vatNumber,
    String? companyName,
  }) => UserProfile(
    id: id,
    name: name ?? this.name,
    email: email,
    role: role,
    createdAt: createdAt,
    lastLoginAt: lastLoginAt,
    twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
    themeMode: themeMode ?? this.themeMode,
    notifyEmail: notifyEmail ?? this.notifyEmail,
    notifyPush: notifyPush ?? this.notifyPush,
    plan: plan ?? this.plan,
    phone: phone ?? this.phone,
    country: country ?? this.country,
    city: city ?? this.city,
    address: address ?? this.address,
    vatNumber: vatNumber ?? this.vatNumber,
    companyName: companyName ?? this.companyName,
  );
}
