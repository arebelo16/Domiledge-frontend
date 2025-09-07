import 'package:flutter/material.dart';
import 'section_card.dart';

class PreferencesCard extends StatefulWidget {
  final ThemeMode themeMode;
  final bool email;
  final bool push;
  final Future<void> Function(ThemeMode, bool, bool) onSave;

  const PreferencesCard({
    super.key,
    required this.themeMode,
    required this.email,
    required this.push,
    required this.onSave,
  });

  @override
  State<PreferencesCard> createState() => _PreferencesCardState();
}

class _PreferencesCardState extends State<PreferencesCard> {
  late ThemeMode theme;
  late bool email;
  late bool push;

  @override
  void initState() {
    super.initState();
    theme = widget.themeMode;
    email = widget.email;
    push = widget.push;
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.tune_rounded,
      title: 'Preferências',
      subtitle: 'Tema e notificações.',
      child: Column(
        children: [
          DropdownButtonFormField<ThemeMode>(
            value: theme,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: ThemeMode.light, child: Text('Claro')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Escuro')),
              DropdownMenuItem(value: ThemeMode.system, child: Text('Sistema')),
            ],
            onChanged: (v) => setState(() => theme = v ?? ThemeMode.system),
            decoration: const InputDecoration(
              labelText: 'Tema',
              border: OutlineInputBorder(),
              filled: true,
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile.adaptive(
            value: email,
            onChanged: (v) => setState(() => email = v),
            contentPadding: EdgeInsets.zero,
            title: const Text('Notificações por email'),
          ),
          SwitchListTile.adaptive(
            value: push,
            onChanged: (v) => setState(() => push = v),
            contentPadding: EdgeInsets.zero,
            title: const Text('Notificações push'),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              icon: const Icon(Icons.save),
              onPressed: () => widget.onSave(theme, email, push),
              label: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
