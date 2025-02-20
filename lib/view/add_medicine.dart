import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/bloc/add_medicine/add_medicine_bloc.dart';
import 'package:recetas/src/components/medicine/add_medicine.dart';

class AddMedicine extends StatelessWidget {
  const AddMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Agregar medicina"),
        ),
        body: BlocProvider(
          create: (context) => AddMedicineBloc(),
          child: const AddMedicineComponent(),
        ));
  }
}
