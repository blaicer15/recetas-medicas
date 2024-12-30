import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Home View'),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Recetas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Personas',
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción del botón flotante
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
