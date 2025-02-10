import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/components/home/personas.dart';
import 'package:recetas/src/components/home/recetas.dart';
import 'package:recetas/src/components/navigation_bar.dart';
import 'package:recetas/src/cubit/navigation/navigation_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: BlocProvider(
          create: (context) => NavigationBarCubit(),
          child: BlocBuilder<NavigationBarCubit, NavigationBarState>(
              builder: (context, state) {
            switch (state.tab) {
              case 0:
                return const Recetas();
              case 1:
                return const Personas();
              default:
                return const Center(
                  child: Text('No seleccionado'),
                );
            }
          }),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => NavigationBarCubit(),
          child: const BarNavigation(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Acción del botón flotante
          },
          child: const Icon(Icons.add),
        ));
  }
}
