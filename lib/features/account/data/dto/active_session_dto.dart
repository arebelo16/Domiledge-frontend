class ActiveSessionDto {
  final String id;
  final String device;
  final String ip;
  final DateTime lastSeen;

  const ActiveSessionDto({
    required this.id,
    required this.device,
    required this.ip,
    required this.lastSeen,
  });

  factory ActiveSessionDto.fromJson(Map<String, dynamic> j) => ActiveSessionDto(
    id: j['id'],
    device: j['device'],
    ip: j['ip'],
    lastSeen: DateTime.parse(j['lastSeen']),
  );
}
