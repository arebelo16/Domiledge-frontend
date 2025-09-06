import 'package:flutter/material.dart';
import '../../account/model/user_profile.dart';

class HeaderCard extends StatelessWidget {
  final UserProfile profile;

  const HeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isNarrow = MediaQuery.of(context).size.width < 720;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [cs.primaryContainer.withOpacity(.65), cs.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: cs.outlineVariant, width: .8),
        ),
        child: isNarrow
            ? _ColumnContent(tt, cs)
            : Row(
                children: [
                  _Avatar(cs),
                  const SizedBox(width: 20),
                  Expanded(child: _Info(tt, cs)),
                  const SizedBox(width: 16),
                  _Right(tt, cs),
                ],
              ),
      ),
    );
  }

  Widget _ColumnContent(TextTheme tt, ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          _Avatar(cs),
          const SizedBox(width: 16),
          Expanded(child: _Info(tt, cs)),
        ],
      ),
      const SizedBox(height: 12),
      _Right(tt, cs),
    ],
  );

  Widget _Avatar(ColorScheme cs) => CircleAvatar(
    radius: 34,
    backgroundColor: cs.primary.withOpacity(.12),
    child: Icon(Icons.person, color: cs.primary),
  );

  Widget _Chip(ColorScheme cs, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: cs.surfaceVariant,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(text, style: const TextStyle(fontSize: 12)),
  );

  Widget _Info(TextTheme tt, ColorScheme cs) => Wrap(
    spacing: 10,
    runSpacing: 6,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(
        profile.name,
        style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      _Chip(cs, profile.role),
      _Chip(cs, 'Plano: ${profile.plan}'),
      _Chip(cs, 'Último login: ${_fmt(profile.lastLoginAt)}'),
    ],
  );

  Widget _Right(TextTheme tt, ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(profile.email, style: tt.bodyMedium),
      const SizedBox(height: 6),
      Text(
        'Conta criada em ${_fmt(profile.createdAt)}',
        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
    ],
  );

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
