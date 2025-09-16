import 'package:flutter/material.dart';

class PopupMenuItemIcon extends PopupMenuEntry<String> {
  final String value;
  final String text;
  final IconData icon;

  const PopupMenuItemIcon({
    super.key,
    required this.value,
    required this.text,
    required this.icon,
  });

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(String? value) => this.value == value;

  @override
  State<PopupMenuItemIcon> createState() => _PopupMenuItemIconState();
}

class _PopupMenuItemIconState extends State<PopupMenuItemIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, widget.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(widget.icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(width: 12),
            Text(widget.text),
          ],
        ),
      ),
    );
  }
}
