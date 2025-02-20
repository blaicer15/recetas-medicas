import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recetas/src/bloc/medication_schedule/medication_schedule_bloc.dart';

class MedicationDropdown extends StatelessWidget {
  const MedicationDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationFormBloc, MedicationFormState>(
      buildWhen: (previous, current) =>
          previous.medication != current.medication ||
          previous.medications != current.medications,
      builder: (context, state) {
        return ListTile(
          title: const Text('Medicamento'),
          subtitle: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              errorText: state.medication.isNotValid
                  ? 'Seleccione un medicamento'
                  : null,
            ),
            value:
                state.medication.value.isEmpty ? null : state.medication.value,
            items: state.medications.map((med) {
              return DropdownMenuItem(
                value: med.id,
                child: Text(med.nombre),
              );
            }).toList(),
            onChanged: (value) {
              context.read<MedicationFormBloc>().add(
                    MedicationChanged(value ?? ''),
                  );
            },
          ),
          trailing: InkWell(
            child: const Icon(Icons.add),
            onTap: () {
              context.push('/addMedicine');
            },
          ),
        );
      },
    );
  }
}
