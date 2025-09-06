import 'package:flutter/material.dart';
import 'section_card.dart';

class SecurityCard extends StatefulWidget {
  final bool twoFA;
  final Future<void> Function(bool) onToggle2FA;
  final Future<void> Function(String, String) onChangePassword;

  const SecurityCard({
    super.key,
    required this.twoFA,
    required this.onToggle2FA,
    required this.onChangePassword,
  });

  @override
  State<SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends State<SecurityCard> {
  final _curr = TextEditingController();
  final _next = TextEditingController();
  final _conf = TextEditingController();

  @override
  void dispose() {
    _curr.dispose(); _next.dispose(); _conf.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Segurança',
      subtitle: 'Protege a tua conta.',
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Autenticação de dois fatores (2FA)'),
            subtitle: Text(widget.twoFA ? 'Ativo' : 'Inativo'),
            value: widget.twoFA,
            onChanged: (v) => widget.onToggle2FA(v),
          ),
          const Divider(),
          Align(alignment: Alignment.centerLeft, child:
          Text('Alterar palavra-passe', style: Theme.of(context).textTheme.titleSmall)),
          const SizedBox(height: 8),
          _pwd(_curr, 'Password atual'),
          const SizedBox(height: 8),
          _pwd(_next, 'Nova password'),
          const SizedBox(height: 8),
          _pwd(_conf, 'Confirmar password'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {
                if (_next.text.isEmpty || _next.text != _conf.text) return;
                widget.onChangePassword(_curr.text, _next.text);
                _curr.clear(); _next.clear(); _conf.clear();
              },
              icon: const Icon(Icons.lock_reset),
              label: const Text('Alterar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pwd(TextEditingController c, String label) =>
      TextField(controller: c, obscureText: true,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()));
}
