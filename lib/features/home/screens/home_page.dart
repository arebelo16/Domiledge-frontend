import 'package:flutter/material.dart';

import '../../../wrappers/main_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Welcome!',
      body: const Center(child: Text('Logged in.')),
    );
  }
}
