import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final bool dense; // << novo

  const SectionCard({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.child,
    this.actions,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, dense ? 12 : 16, 16, dense ? 12 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant, width: .8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(icon, size: 20, color: cs.primary),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (!dense && subtitle != null)
                        Text(
                          subtitle!,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (actions != null) Row(children: actions!),
              ],
            ),
            if (!dense)
              const SizedBox(height: 12)
            else
              const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
