import 'package:flutter/material.dart';

class HomeTablet extends StatelessWidget {
  const HomeTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Domiledge", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Alternar tema (TODO)")),
                );
              },
            ),
            const SizedBox(width: 4),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 16),
          ],
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Início'),
              Tab(text: 'Propriedades'),
              Tab(text: 'Conta'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("Tablet: Início")),
            Center(child: Text("Tablet: Propriedades")),
            Center(child: Text("Tablet: Conta")),
          ],
        ),
      ),
    );
  }
}
