import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/bloc/add_person/add_person_bloc.dart';
import 'package:recetas/src/components/person/form.dart';

class AddPerson extends StatelessWidget {
  const AddPerson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar persona"),
      ),
      body: BlocProvider(
        create: (context) => AddPersonBloc(),
        child: FormPerson(),
      ),
    );
  }
}
