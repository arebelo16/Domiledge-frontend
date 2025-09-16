import 'package:domiledge_frontend/features/account/screens/profile_page.dart';
import 'package:domiledge_frontend/features/properties/screens/properties_page.dart';
import 'package:flutter/material.dart';

import '../features/auth/screens/login_page.dart';
import '../features/auth/screens/login_with_reset_popup.dart';
import '../features/auth/screens/register_page.dart';
import '../features/auth/widgets/guest_only.dart';
import '../features/auth/widgets/require_auth.dart';
import '../features/home/screens/home_page.dart';
import '../features/home/screens/not_found_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String properties = '/properties';
  static const String account = '/account';
  static const String reset = '/reset';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final raw = settings.name ?? '/';
    final uri = Uri.parse(raw);

    switch (uri.path) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const RequireAuth(child: HomePage()),
          settings: settings,
        );

      case properties:
        final id = (settings.arguments as Map?)?['selectedId'] as String?;
        return MaterialPageRoute(
          builder: (_) =>
              RequireAuth(child: PropertiesPage(initialSelectedId: id)),
          settings: settings,
        );

      case account:
        return MaterialPageRoute(
          builder: (_) => const RequireAuth(child: ProfilePage()),
          settings: settings,
        );

      case login:
        final uri = Uri.parse(settings.name ?? '');
        return MaterialPageRoute(
          builder: (_) =>
              GuestOnly(child: LoginPage(queryParams: uri.queryParameters)),
          settings: RouteSettings(name: login),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const GuestOnly(child: RegisterPage()),
          settings: RouteSettings(
            name: register,
            arguments: settings.arguments,
          ),
        );

      case reset:
        final rid = uri.queryParameters['rid'];
        final token = uri.queryParameters['token'];
        return MaterialPageRoute(
          builder: (ctx) => LoginWithResetPopup(rid: rid, token: token),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
          settings: settings,
        );
    }
  }
}
