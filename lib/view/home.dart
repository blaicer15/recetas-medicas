import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:recetas/src/components/home/personas.dart';
import 'package:recetas/src/components/home/recetas.dart';
import 'package:recetas/src/components/navigation_bar.dart';
import 'package:recetas/src/cubit/navigation/navigation_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final log = Logger();
    return BlocProvider(
        create: (context) => NavigationBarCubit(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
            ),
            body: CustomScrollView(
              slivers: [
                BlocBuilder<NavigationBarCubit, NavigationBarState>(
                    builder: (context, state) {
                  log.d(state.tab);
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
                })
              ],
            ),
            bottomNavigationBar: const BarNavigation(),
            floatingActionButton:
                BlocBuilder<NavigationBarCubit, NavigationBarState>(
              builder: (context, state) {
                return FloatingActionButton(
                  onPressed: () {
                    if (state.tab == 0) {
                      context.push("/addRecipe");
                    }
                    if (state.tab == 1) {
                      context.push("/addPerson");
                    }
                  },
                  child: const Icon(Icons.add),
                );
              },
            )));
  }
}
