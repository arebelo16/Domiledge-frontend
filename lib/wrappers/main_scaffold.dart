import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../core/services/storage_services.dart';
import '../routes/app_routes.dart';
import '../features/auth/controllers/auth_controller.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('My account (em breve)')),
        );
        break;
      case 'logout':
        final navigator = Navigator.of(context);
        await _authController.logout();
        await StorageService.clearToken();
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
    final isTablet = width >= 600 && width < 1024;
    final isWeb = kIsWeb && width >= 1024;

    if (isWeb) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            const MainAppBarWeb(),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: isWeb,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alternar tema em breve...')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => [
              PopupMenuItemIcon(
                value: 'account',
                icon: Icons.person,
                text: 'My account',
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
      drawer: isTablet || !kIsWeb ? MainDrawerMobile(onNavTap: _onNavTap) : null,
      body: body,
      bottomNavigationBar: isWeb || isTablet
          ? null
          : BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onNavTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.apartment), label: 'Propriedades'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Conta'),
        ],
      ),
    );
  }
}
