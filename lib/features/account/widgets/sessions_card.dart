import 'package:flutter/material.dart';

import '../../account/model/active_session.dart';
import 'section_card.dart';

class SessionsCard extends StatefulWidget {
  final Future<List<ActiveSession>> Function() loader;
  final Future<void> Function(ActiveSession) revoke;

  /// Chamado quando o loader apanha 401 (ou quando o chamador quiser tratar).
  final VoidCallback? onUnauthenticated;

  /// Chamado quando o utilizador revoga a PRÓPRIA sessão.
  final VoidCallback? onSelfRevoked;

  final bool dense;

  const SessionsCard({
    super.key,
    required this.loader,
    required this.revoke,
    this.onUnauthenticated,
    this.onSelfRevoked,
    this.dense = false,
  });

  @override
  State<SessionsCard> createState() => _SessionsCardState();
}

class _SessionsCardState extends State<SessionsCard> {
  late Future<List<ActiveSession>> _f;
  final Set<String> _revoking = {};

  @override
  void initState() {
    super.initState();
    _f = _load();
  }

  Future<List<ActiveSession>> _load() async {
    try {
      return await widget.loader();
    } catch (_) {
      widget.onUnauthenticated?.call();
      rethrow;
    }
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
          if (s.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          if (s.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Não foi possível carregar as sessões.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _f = _load()),
                  child: const Text('Tentar novamente'),
                ),
              ],
            );
          }
          final list = s.data ?? const <ActiveSession>[];
          if (list.isEmpty) return const Text('Sem sessões ativas.');

          return Column(
            children: list.map((e) {
              final isBusy = _revoking.contains(e.id);
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
                  '${e.ip} • ${_fmt(e.lastSeen)}${e.current ? ' • Este dispositivo' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: TextButton(
                  onPressed: isBusy ? null : () => _onRevokePressed(context, e),
                  child: isBusy
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Revogar'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _onRevokePressed(
    BuildContext context,
    ActiveSession sess,
  ) async {
    final bool isSelf = sess.current == true;
    final ok = await _confirmRevoke(context, isSelf: isSelf);
    if (ok != true) return;

    setState(() => _revoking.add(sess.id));
    try {
      await widget.revoke(sess);
      if (isSelf) {
        widget.onSelfRevoked?.call();
        return;
      }
      if (mounted) setState(() => _f = _load());
    } finally {
      if (mounted) setState(() => _revoking.remove(sess.id));
    }
  }

  Future<bool?> _confirmRevoke(BuildContext context, {required bool isSelf}) {
    final title = isSelf ? 'Revogar a tua sessão?' : 'Revogar esta sessão?';
    final body = isSelf
        ? 'Vais terminar a sessão atual e serás desconectado. Continuar?'
        : 'Tens a certeza que queres terminar esta sessão?';

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Revogar'),
          ),
        ],
      ),
    );
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
