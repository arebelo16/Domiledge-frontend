import 'package:flutter/material.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Domiledge", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: false,
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
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Início'),
              Tab(text: 'Propriedades'),
              Tab(text: 'Conta'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("Página: Início")),
            Center(child: Text("Página: Propriedades")),
            Center(child: Text("Página: Conta")),
          ],
        ),
      ),
    );
  }
}
