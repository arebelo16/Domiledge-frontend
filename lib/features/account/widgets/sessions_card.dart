import 'package:flutter/material.dart';
import '../../account/model/active_session.dart';
import 'section_card.dart';

class SessionsCard extends StatefulWidget {
  final Future<List<ActiveSession>> Function() loader;
  final Future<void> Function(ActiveSession) revoke;
  final bool dense;

  const SessionsCard({
    super.key,
    required this.loader,
    required this.revoke,
    this.dense = false,
  });

  @override
  State<SessionsCard> createState() => _SessionsCardState();
}

class _SessionsCardState extends State<SessionsCard> {
  late Future<List<ActiveSession>> _f;

  @override
  void initState() {
    super.initState();
    _f = widget.loader();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      dense: widget.dense,
      icon: Icons.devices_other,
      title: 'Sessões Ativas',
      child: FutureBuilder<List<ActiveSession>>(
        future: _f,
        builder: (context, s) {
          if (!s.hasData) return const LinearProgressIndicator();
          final list = s.data!;
          if (list.isEmpty) return const Text('Sem sessões ativas.');
          return Column(
            children: list.map((e) {
              return ListTile(
                dense: true,
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.laptop_mac, size: 20),
                title: Text(
                  e.device,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${e.ip} • ${_fmt(e.lastSeen)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: TextButton(
                  onPressed: () async {
                    await widget.revoke(e);
                    setState(() => _f = widget.loader());
                  },
                  child: const Text('Revogar'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
