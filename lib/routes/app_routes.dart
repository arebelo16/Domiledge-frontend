// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:staywise_frontend/features/auth/screens/login_page.dart';
import 'package:staywise_frontend/features/home/screens/home_page.dart';
import 'package:staywise_frontend/features/auth/screens/register_page.dart';

final appRoutes = <String, WidgetBuilder>{
  '/login': (_) => const LoginPage(),
  '/home': (_) => const HomePage(),
  '/register': (_) => const RegisterPage(),
};
