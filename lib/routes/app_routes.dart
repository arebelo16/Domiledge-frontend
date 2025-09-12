import 'package:domiledge_frontend/features/account/screens/profile_page.dart';
import 'package:domiledge_frontend/features/properties/screens/properties_page.dart';
import 'package:flutter/material.dart';

import '../features/auth/screens/login_page.dart';
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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const RequireAuth(child: HomePage()),
        );
      case AppRoutes.properties:
        final id = (settings.arguments as Map?)?['selectedId'] as String?;
        return MaterialPageRoute(
          builder: (_) =>
              RequireAuth(child: PropertiesPage(initialSelectedId: id)),
        );
      case AppRoutes.account:
        return MaterialPageRoute(
          builder: (_) => const RequireAuth(child: ProfilePage()),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const GuestOnly(child: LoginPage()),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const GuestOnly(child: RegisterPage()),
        );

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
