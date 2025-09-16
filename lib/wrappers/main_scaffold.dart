import 'package:flutter/material.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import 'app_bar/main_app_bar_web.dart';
import 'drawer/main_drawer_mobile.dart';
import 'navigation/popup_menu_item_icon.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int selectedIndex;

  MainScaffold({
    super.key,
    required this.body,
    required this.title,
    this.selectedIndex = 0,
  });

  final _authController = AuthController();

  Future<void> _handleMenuSelection(BuildContext context, String value) async {
    switch (value) {
      case 'account':
        final navigator = Navigator.of(context);
        navigator.pushReplacementNamed(AppRoutes.account);
        break;
      case 'logout':
        final navigator = Navigator.of(context);
        await _authController.logout();
        navigator.pushReplacementNamed(AppRoutes.login);
        break;
    }
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.properties);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.account);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 1024;

    if (!isNarrow) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            MainAppBarWeb(),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      drawerEnableOpenDragGesture: isNarrow,
      drawerEdgeDragWidth: isNarrow ? 28 : 0,
      drawer: isNarrow ? MainDrawerMobile(onNavTap: _onNavTap) : null,

      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        elevation: 0.5,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menu',
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: const [
            SizedBox(width: 4),
            Icon(Icons.apartment, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Domiledge',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: .3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alternar tema em breve...')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => const [
              PopupMenuItemIcon(
                value: 'account',
                icon: Icons.person,
                text: 'Minha conta',
              ),
              PopupMenuItemIcon(
                value: 'logout',
                icon: Icons.logout,
                text: 'Logout',
              ),
            ],
          ),
        ],
      ),

      body: body,
      bottomNavigationBar: null,
    );
  }
}
