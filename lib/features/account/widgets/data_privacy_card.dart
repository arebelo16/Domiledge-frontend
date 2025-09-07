import 'package:flutter/material.dart';
import 'section_card.dart';

class DataPrivacyCard extends StatelessWidget {
  final Future<void> Function() onExport;
  final Future<void> Function() onDelete;

  const DataPrivacyCard({
    super.key,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Dados & Privacidade',
      subtitle: 'Exporta dados ou elimina a conta.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Receberás um link por email com o export.'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onExport,
            icon: const Icon(Icons.download),
            label: const Text('Exportar dados (GDPR)'),
          ),
          const Divider(height: 24),
          const Text(
            'Zona de perigo',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          FilledButton.tonalIcon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFEBEE),
              foregroundColor: Colors.red.shade700,
            ),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Eliminar conta'),
                  content: const Text(
                    'Esta ação é permanente. Queres mesmo eliminar a conta?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              if (ok == true) await onDelete();
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Eliminar conta'),
          ),
        ],
      ),
    );
  }
}
