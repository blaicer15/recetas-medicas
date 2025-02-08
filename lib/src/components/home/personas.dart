import 'package:flutter/material.dart';

class Personas extends StatelessWidget {
  const Personas({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Nombre de la persona agregada $index"),
          subtitle: Text(
              "Tipo de persona agregada: Hijo, Padre, Esposa ${index + 1}"),
        );
      },
      itemCount: 10,
    );
  }
}
