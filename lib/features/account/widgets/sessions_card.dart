import 'package:flutter/material.dart';
import '../../account/model/active_session.dart';
import 'section_card.dart';

class SessionsCard extends StatefulWidget {
  final Future<List<ActiveSession>> Function() loader;
  final Future<void> Function(ActiveSession) onRevoke;
  const SessionsCard({super.key, required this.loader, required this.onRevoke});

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
      title: 'Sessões Ativas',
      subtitle: 'Gestão de devices ligados.',
      child: FutureBuilder<List<ActiveSession>>(
        future: _f,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator());
          }
          final list = s.data ?? const <ActiveSession>[];
          if (list.isEmpty) {
            return const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline),
              title: Text('Sem sessões ativas.'),
            );
          }
          return Column(
            children: list.map((e) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.devices_other),
              title: Text(e.device),
              subtitle: Text('${e.ip} • ${_fmt(e.lastSeen)}'),
              trailing: TextButton(
                onPressed: () async { await widget.onRevoke(e); setState(() => _f = widget.loader()); },
                child: const Text('Revogar'),
              ),
            )).toList(),
          );
        },
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year} '
          '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
}
