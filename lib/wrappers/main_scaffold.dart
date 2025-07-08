import 'package:flutter/material.dart';

import '../core/services/storage_services.dart';
import '../features/auth/controllers/auth_controller.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final _authController = AuthController();

  MainScaffold({super.key, required this.body, required this.title});

  Future<void> _handleMenuSelection(BuildContext context, String value) async {
    switch (value) {
      case 'account':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('My account (soon)')),
        );
        break;

      case 'logout':
        final navigator = Navigator.of(context);
        final messenger = ScaffoldMessenger.of(context);

        final success = await _authController.logout();

        if (success) {
          await StorageService.clearToken();
          navigator.pushReplacementNamed('/login');
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text('Erro ao fazer logout')),
          );
        }
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle),
          onSelected: (value) => _handleMenuSelection(context, value),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'account',
              child: Text('My account'),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
