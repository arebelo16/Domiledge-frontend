import 'package:flutter/material.dart';

import 'config/themes.dart';
import 'routes/app_routes.dart';

class DomiledgeApp extends StatelessWidget {
  const DomiledgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domiledge',
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: appRoutes,
    );
  }
}
