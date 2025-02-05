import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recetas_medicas/src/bloc/home/home_bloc.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: const Center(
          child: Text('Home View'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(onTap: (value) {
        if (value ==0) {
          
        }
      }, items: const [
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
