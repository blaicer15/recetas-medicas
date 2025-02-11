import 'package:flutter/material.dart';

class AddPerson extends StatelessWidget {
  const AddPerson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text("Nombre(s)"),
            subtitle: TextField(
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text("Apellido paterno"),
            subtitle: TextField(
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text("Apellido materno"),
            subtitle: TextField(
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text("Edad"),
            subtitle: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text("Peso"),
            subtitle: TextField(
              maxLength: 5,
              keyboardType: TextInputType.number,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text("Estatura"),
            subtitle: TextField(
              maxLength: 5,
              keyboardType: TextInputType.number,
              onChanged: (value) {},
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Guardar"))
        ],
      ),
    );
  }
}
