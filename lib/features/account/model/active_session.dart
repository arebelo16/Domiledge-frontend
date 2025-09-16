import '../data/dto/active_session_dto.dart';

class ActiveSession {
  final String id;
  final String device;
  final String ip;
  final DateTime lastSeen;
  final bool current;

  const ActiveSession({
    required this.id,
    required this.device,
    required this.ip,
    required this.lastSeen,
    this.current = false,
  });

  factory ActiveSession.fromDto(ActiveSessionDto dto) => ActiveSession(
    id: dto.id,
    device: dto.device,
    ip: dto.ip,
    lastSeen: dto.lastSeen,
    current: dto.current,
  );
}
