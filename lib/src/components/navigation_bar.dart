import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/cubit/navigation/navigation_cubit.dart';

class BarNavigation extends StatelessWidget {
  const BarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBarCubit, NavigationBarState>(
      builder: (context, state) {
        return NavigationBar(
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.list),
              icon: Icon(Icons.list_outlined),
              label: 'Recetas',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.people),
              icon: Icon(Icons.people_outline),
              label: 'Personas',
            ),
          ],
          selectedIndex: state.tab,
          onDestinationSelected: (value) =>
              context.read<NavigationBarCubit>().setTab(value),
        );
      },
    );
  }
}
