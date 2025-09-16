import 'package:flutter/material.dart';

import '../../../shared/widgets/responsive_layout.dart';
import '../widgets/home_mobile.dart';
import '../widgets/home_tablet.dart';
import '../widgets/home_web.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: HomeMobile(),
      tablet: HomeTablet(),
      web: HomeWeb(),
    );
  }
}
