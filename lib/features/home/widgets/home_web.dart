import 'package:flutter/material.dart';
import '../../../wrappers/main_scaffold.dart';

class HomeWeb extends StatelessWidget {
  const HomeWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Início', // Só usado em mobile/tablet
      selectedIndex: 0,
      body: Column(
        children: [
          // HERO
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey.shade600,
            child: const Center(
              child: ElevatedButton(
                onPressed: null,
                child: Text("HERO BTN"),
              ),
            ),
          ),

          // BODY
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Center(
                child: Text("Conteúdo adicional"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
