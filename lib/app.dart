import 'package:flutter/material.dart';
import 'config/themes.dart';
import 'routes/app_routes.dart';

class StayWiseApp extends StatelessWidget {
  const StayWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayWise',
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: appRoutes,
    );
  }
}
