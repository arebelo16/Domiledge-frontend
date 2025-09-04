import 'package:flutter/material.dart';
import '../navigation/main_nav_dropdown_web.dart';

class MainAppBarWeb extends StatelessWidget {
  const MainAppBarWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade400,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                WebDropdownMenu(
                  title: 'ACCOUNT',
                  items: [
                    DropdownItem(label: 'Perfil', icon: Icons.person),
                    DropdownItem(label: 'Preferências', icon: Icons.settings),
                    DropdownItem(label: 'Logout', icon: Icons.logout),
                  ],
                ),
                SizedBox(width: 24),
                WebDropdownMenu(
                  title: 'PROPERTIES',
                  items: [
                    DropdownItem(label: 'Ver propriedades', icon: Icons.apartment),
                    DropdownItem(label: 'Adicionar nova', icon: Icons.add_home),
                  ],
                ),
                SizedBox(width: 24),
                WebDropdownMenu(
                  title: 'INSIGHTS',
                  items: [
                    DropdownItem(label: 'Ocupação', icon: Icons.timeline),
                    DropdownItem(label: 'Sugestões de preço', icon: Icons.price_change),
                  ],
                ),
                SizedBox(width: 24),
                WebDropdownMenu(
                  title: 'INVOICES',
                  items: [
                    DropdownItem(label: 'Histórico', icon: Icons.receipt_long),
                    DropdownItem(label: 'Emitir fatura', icon: Icons.add_chart),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Alternar tema (TODO)")),
                  );
                },
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
