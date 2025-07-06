import 'package:flutter/material.dart';
import 'package:staywise_frontend/features/auth/screens/login_page.dart';

import '../features/home/screens/home_page.dart';

final appRoutes = <String, WidgetBuilder>{
  '/login': (_) => const LoginPage(),
  '/home': (_) => const HomePage(),
};
