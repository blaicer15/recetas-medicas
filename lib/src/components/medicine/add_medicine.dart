import 'package:flutter/material.dart';
import 'package:recetas/src/components/medicine/form_medicine.dart';

class AddMedicineComponent extends StatelessWidget {
  const AddMedicineComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar medicina"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: FormMedicine(),
      ),
    );
  }
}
