import 'package:flutter/material.dart';

class Recetas extends StatelessWidget {
  const Recetas({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Titulo $index"),
          subtitle: Text("Subtitulo ${index + 1}"),
        );
      },
      itemCount: 10,
    );
  }
}
