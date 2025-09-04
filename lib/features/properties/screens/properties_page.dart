import 'package:flutter/material.dart';
import '../../../wrappers/main_scaffold.dart';
import '../widgets/properties_panel_web.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Propriedades',
      body: const PropertiesPanelWeb(),
      selectedIndex: 1,
    );
  }
}
