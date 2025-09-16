import 'package:flutter/material.dart';

import '../../../core/utils/replace_url.dart';
import '../../../core/utils/result.dart';
import '../../../routes/app_routes.dart';
import '../data/auth_api.dart';

class RequireAuth extends StatefulWidget {
  final Widget child;

  const RequireAuth({super.key, required this.child});

  @override
  State<RequireAuth> createState() => _RequireAuthState();
}

class _RequireAuthState extends State<RequireAuth> {
  late final Future<Result<bool>> _authFuture = AuthApi.isAuthenticated();
  bool _navigated = false;

  void _goLogin() {
    if (_navigated) return;
    _navigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      replaceUrl(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<bool>>(
      future: _authFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final result = snapshot.data!;
          if (result.isFailure || result.data != true) {
            _goLogin();
            return const SizedBox.shrink();
          }
        }

        return widget.child;
      },
    );
  }
}
