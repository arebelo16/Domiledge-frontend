import 'package:flutter/material.dart';
import '../../../wrappers/main_scaffold.dart';
import '../widgets/properties_panel_web.dart';

class PropertiesPage extends StatelessWidget {
  final String? initialSelectedId;
  const PropertiesPage({super.key, this.initialSelectedId});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Propriedades',
      body: PropertiesPanelWeb(initialSelectedId: initialSelectedId),
      selectedIndex: 1,
    );
  }
}
