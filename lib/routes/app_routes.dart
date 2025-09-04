import 'package:domiledge_frontend/features/properties/screens/properties_page.dart';
import 'package:domiledge_frontend/features/properties/widgets/properties_panel_web.dart';
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
    properties: (_) => const PropertiesPage()
  };
}
