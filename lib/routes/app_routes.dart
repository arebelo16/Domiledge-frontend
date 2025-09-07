import 'package:domiledge_frontend/features/account/screens/profile_page.dart';
import 'package:domiledge_frontend/features/properties/screens/properties_page.dart';
import 'package:flutter/material.dart';

import '../features/auth/screens/login_page.dart';
import '../features/auth/screens/register_page.dart';
import '../features/home/screens/home_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String properties = '/properties';
  static const String account = '/account';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    home: (_) => const HomePage(),
    account: (_) => const ProfilePage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case properties:
        final id = (settings.arguments as Map?)?['selectedId'] as String?;
        return MaterialPageRoute(builder: (_) => PropertiesPage(initialSelectedId: id));
      case account:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      default:
        final builder = routes[settings.name];
        return MaterialPageRoute(builder: builder ?? (_) => const HomePage());
    }
  }
}
