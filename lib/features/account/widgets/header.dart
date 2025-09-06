import 'package:flutter/material.dart';
import '../../account/model/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile p;
  const ProfileHeader({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 32, child: Icon(Icons.person, size: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Wrap(
                spacing: 12, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(p.name, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  _chip(p.role), _chip('Plano: ${p.plan}'), _chip('Último login: ${_fmt(p.lastLoginAt)}'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(p.email, style: t.bodyMedium),
                const SizedBox(height: 4),
                Text('Conta criada em ${_fmt(p.createdAt)}',
                    style: t.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _chip(String s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: const Color(0xFFF3F5F8), borderRadius: BorderRadius.circular(999)),
    child: Text(s, style: const TextStyle(fontSize: 12)),
  );

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year} '
          '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
}
