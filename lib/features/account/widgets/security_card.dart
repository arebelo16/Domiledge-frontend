import 'package:flutter/material.dart';
import 'section_card.dart';

class SecurityCard extends StatelessWidget {
  final bool is2FAEnabled;
  final Future<void> Function(bool) onToggle2FA;
  final Future<void> Function(String current, String next) onChangePassword;

  const SecurityCard({
    super.key,
    required this.is2FAEnabled,
    required this.onToggle2FA,
    required this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    final curr = TextEditingController();
    final next = TextEditingController();
    final conf = TextEditingController();

    return SectionCard(
      icon: Icons.shield,
      title: 'Segurança',
      subtitle: 'Protege a tua conta.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 2FA switch explícito
          SwitchListTile.adaptive(
            value: is2FAEnabled,
            onChanged: onToggle2FA,
            title: const Text('Autenticação de dois fatores (2FA)'),
            subtitle: Text(is2FAEnabled ? 'Ativo' : 'Inativo'),
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.qr_code_2),
          ),
          const Divider(height: 24),
          Text(
            'Alterar palavra-passe',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: curr,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password atual',
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: next,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nova password',
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: conf,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirmar password',
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.lock_reset),
              onPressed: () {
                if (next.text.isNotEmpty && next.text == conf.text) {
                  onChangePassword(curr.text, next.text);
                }
              },
              label: const Text('Alterar'),
            ),
          ),
        ],
      ),
    );
  }
}
