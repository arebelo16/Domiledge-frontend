import 'package:domiledge_frontend/routes/app_routes.dart';
import 'package:domiledge_frontend/shared/widgets/notify.dart';
import 'package:flutter/material.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../navigation/main_nav_dropdown_web.dart';

class MainAppBarWeb extends StatelessWidget implements PreferredSizeWidget {
  MainAppBarWeb({super.key});

  static const double _barHeight = 64;
  static const double _sideMinWidth = 180;
  final _authController = AuthController();

  @override
  Size get preferredSize => const Size.fromHeight(_barHeight);

  Future<void> _logout(BuildContext context) async {
    try {
      await _authController.logout();

      Notify.show(
        context,
        'Terminaste sessão com sucesso.',
        title: 'Logout',
        type: NotifyType.info,
        duration: const Duration(seconds: 3),
      );
    } catch (_) {
    } finally {
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    }
  }

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
            // Logo / Branding
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: _sideMinWidth,
                child: Row(
                  children: const [
                    Icon(Icons.apartment, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
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

            // Menus
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                WebDropdownMenu(
                  title: 'PROPERTIES',
                  items: [
                    DropdownItem(
                      label: 'Ver propriedades',
                      icon: Icons.apartment,
                    ),
                    DropdownItem(label: 'Adicionar nova', icon: Icons.add_home),
                  ],
                ),
                SizedBox(width: 28),
                WebDropdownMenu(
                  title: 'INSIGHTS',
                  items: [
                    DropdownItem(label: 'Ocupação', icon: Icons.timeline),
                    DropdownItem(
                      label: 'Sugestões de preço',
                      icon: Icons.price_change,
                    ),
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

            // Theme and Profile
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

                    PopupMenuButton<String>(
                      tooltip: "Conta",
                      offset: const Offset(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSelected: (value) async {
                        switch (value) {
                          case 'profile':
                            if (context.mounted) {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.account);
                            }
                            break;
                          case 'logout':
                            await _logout(context);
                            break;
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'profile',
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Minha conta'),
                          ),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'logout',
                          child: ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                          ),
                        ),
                      ],
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 18, color: Colors.grey),
                      ),
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
