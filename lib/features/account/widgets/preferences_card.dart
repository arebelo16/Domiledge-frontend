import 'package:flutter/material.dart';
import 'section_card.dart';

class PreferencesCard extends StatefulWidget {
  final ThemeMode themeMode;
  final bool email;
  final bool push;
  final bool saving;
  final Future<void> Function(ThemeMode, bool, bool) onSave;

  const PreferencesCard({
    super.key,
    required this.themeMode,
    required this.email,
    required this.push,
    required this.saving,
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
      title: 'Preferências',
      subtitle: 'Tema e notificações.',
      child: Column(
        children: [
          DropdownButtonFormField<ThemeMode>(
            value: theme,
            items: const [
              DropdownMenuItem(value: ThemeMode.light, child: Text('Claro')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Escuro')),
              DropdownMenuItem(value: ThemeMode.system, child: Text('Sistema')),
            ],
            onChanged: (v) => setState(() => theme = v ?? ThemeMode.system),
            decoration: const InputDecoration(labelText: 'Tema', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          SwitchListTile(title: const Text('Notificações por email'), value: email, onChanged: (v) => setState(() => email = v)),
          SwitchListTile(title: const Text('Notificações push'), value: push, onChanged: (v) => setState(() => push = v)),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: widget.saving ? null : () => widget.onSave(theme, email, push),
              icon: widget.saving
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          )
        ],
      ),
    );
  }
}
