import 'package:flutter/material.dart';

class MainDrawerMobile extends StatelessWidget {
  final void Function(BuildContext, int) onNavTap;
  const MainDrawerMobile({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade400),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.apartment, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text('Domiledge Menu',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () => onNavTap(context, 0),
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text('Propriedades'),
            onTap: () => onNavTap(context, 1),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Conta'),
            onTap: () => onNavTap(context, 2),
          ),
        ],
      ),
    );
  }
}
