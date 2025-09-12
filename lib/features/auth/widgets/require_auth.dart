import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../data/auth_api.dart';

class RequireAuth extends StatelessWidget {
  final Widget child;
  const RequireAuth({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthApi.isAuthenticated(),
      builder: (context, s) {
        if (!s.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (s.data == true) return child;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        });
        return const SizedBox.shrink();
      },
    );
  }
}