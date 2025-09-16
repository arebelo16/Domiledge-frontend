import 'package:domiledge_frontend/core/utils/replace_url.dart';
import 'package:domiledge_frontend/core/utils/result.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../data/auth_api.dart';

class GuestOnly extends StatefulWidget {
  final Widget child;

  const GuestOnly({super.key, required this.child});

  @override
  State<GuestOnly> createState() => _GuestOnlyState();
}

class _GuestOnlyState extends State<GuestOnly> {
  late final Future<Result<bool>> _authFuture = AuthApi.isAuthenticated();

  bool _navigated = false;

  void _goHome() {
    if (_navigated) return;
    _navigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      replaceUrl(AppRoutes.home);
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
          if (result.isSuccess && result.data == true) {
            _goHome();
            return const SizedBox.shrink();
          }
        }

        return widget.child;
      },
    );
  }
}
