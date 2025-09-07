class UserProfileDto {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? country;
  final String? city;
  final String? address;
  final String theme; // 'light' | 'dark' | 'system'
  final bool twoFactorEnabled;
  final bool notifyEmail;
  final bool notifyPush;
  final String plan;
  final String? vatNumber;
  final String? companyName;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const UserProfileDto({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.theme,
    required this.twoFactorEnabled,
    required this.notifyEmail,
    required this.notifyPush,
    required this.plan,
    required this.createdAt,
    required this.lastLoginAt,
    this.phone,
    this.country,
    this.city,
    this.address,
    this.vatNumber,
    this.companyName,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> j) => UserProfileDto(
    id: j['id'],
    name: j['name'],
    email: j['email'],
    role: j['role'] ?? 'User',
    theme: j['theme'] ?? 'light',
    twoFactorEnabled: j['twoFactorEnabled'] ?? false,
    notifyEmail: j['notifyEmail'] ?? true,
    notifyPush: j['notifyPush'] ?? false,
    plan: j['plan'] ?? 'Free',
    createdAt: DateTime.parse(j['createdAt']),
    lastLoginAt: DateTime.parse(j['lastLoginAt']),
    phone: j['phone'],
    country: j['country'],
    city: j['city'],
    address: j['address'],
    vatNumber: j['vatNumber'],
    companyName: j['companyName'],
  );

  Map<String, dynamic> toUpdateJson() => {
    'name': name,
    'phone': phone,
    'country': country,
    'city': city,
    'address': address,
    'theme': theme,
    'twoFactorEnabled': twoFactorEnabled,
    'notifyEmail': notifyEmail,
    'notifyPush': notifyPush,
    'plan': plan,
    'vatNumber': vatNumber,
    'companyName': companyName,
  };
}
