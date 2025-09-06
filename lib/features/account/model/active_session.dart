class ActiveSession {
  final String id;
  final String device;
  final String ip;
  final DateTime lastSeen;

  const ActiveSession({
    required this.id,
    required this.device,
    required this.ip,
    required this.lastSeen,
  });
}