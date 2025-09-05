import 'package:flutter/material.dart';
import '../navigation/main_nav_dropdown_web.dart';

class MainAppBarWeb extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBarWeb({super.key});

  static const double _barHeight = 64;
  static const double _sideMinWidth = 180; // reserva p/ logo à esquerda

  @override
  Size get preferredSize => const Size.fromHeight(_barHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.shade400,
      elevation: 0.5,
      child: Container(
        height: _barHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: _sideMinWidth,
                child: Row(
                  children: [
                    // TODO: trocar por Image.asset('assets/logo.png', height: 28)
                    const Icon(Icons.apartment, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'Domiledge',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                WebDropdownMenu(
                  title: 'ACCOUNT',
                  items: [
                    DropdownItem(label: 'Perfil', icon: Icons.person),
                    DropdownItem(label: 'Preferências', icon: Icons.settings),
                    DropdownItem(label: 'Logout', icon: Icons.logout),
                  ],
                ),
                SizedBox(width: 28),
                WebDropdownMenu(
                  title: 'PROPERTIES',
                  items: [
                    DropdownItem(label: 'Ver propriedades', icon: Icons.apartment),
                    DropdownItem(label: 'Adicionar nova', icon: Icons.add_home),
                  ],
                ),
                SizedBox(width: 28),
                WebDropdownMenu(
                  title: 'INSIGHTS',
                  items: [
                    DropdownItem(label: 'Ocupação', icon: Icons.timeline),
                    DropdownItem(label: 'Sugestões de preço', icon: Icons.price_change),
                  ],
                ),
                SizedBox(width: 28),
                WebDropdownMenu(
                  title: 'INVOICES',
                  items: [
                    DropdownItem(label: 'Histórico', icon: Icons.receipt_long),
                    DropdownItem(label: 'Emitir fatura', icon: Icons.add_chart),
                  ],
                ),
              ],
            ),

            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: _sideMinWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
