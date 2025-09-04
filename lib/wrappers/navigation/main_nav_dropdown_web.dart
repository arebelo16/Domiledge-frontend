import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class WebDropdownMenu extends StatefulWidget {
  final String title;
  final List<DropdownItem> items;

  const WebDropdownMenu({super.key, required this.title, required this.items});

  @override
  State<WebDropdownMenu> createState() => _WebDropdownMenuState();
}

class _WebDropdownMenuState extends State<WebDropdownMenu> {
  final GlobalKey _key = GlobalKey();

  void _showDropdownMenu(BuildContext context) async {
    final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        0,
      ),
      color: const Color.fromARGB(217, 245, 245, 245),
      items: widget.items
          .map((item) => PopupMenuItem<String>(
        value: item.label,
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(item.label),
          ],
        ),
      ))
          .toList(),
    );

    if (selected == 'Ver propriedades') {
      Navigator.of(context).pushReplacementNamed(AppRoutes.properties);
    }


    if (selected != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecionado: $selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: () => _showDropdownMenu(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 1.1,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class DropdownItem {
  final String label;
  final IconData icon;

  const DropdownItem({required this.label, required this.icon});
}
