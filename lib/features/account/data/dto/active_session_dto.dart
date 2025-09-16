import '../../../../core/utils/coverters.dart';

class ActiveSessionDto {
  final String id;
  final String device;
  final String ip;
  final DateTime lastSeen;
  final bool current;

  const ActiveSessionDto({
    required this.id,
    required this.device,
    required this.ip,
    required this.lastSeen,
    this.current = false,
  });

  factory ActiveSessionDto.fromJson(Map<String, dynamic> j) => ActiveSessionDto(
    id: j['id'],
    device: j['device'],
    ip: j['ip'],
    lastSeen: DateTime.parse(j['lastSeen']),
    current: toBool(j['current']),
  );
}
