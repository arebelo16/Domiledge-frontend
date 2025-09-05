import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget web;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.web,
  });

  @override
  Widget build(BuildContext context) => web;
  // Widget build(BuildContext context) {
  //   final width = MediaQuery.of(context).size.width;
  //   if (kIsWeb && width >= 1024) {
  //     return web;
  //   } else if (width >= 600) {
  //     return tablet;
  //   } else {
  //     return mobile;
  //   }
  // }
}
