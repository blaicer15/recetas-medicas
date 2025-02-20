import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/bloc/medication_schedule/medication_schedule_bloc.dart';

class DurationField extends StatelessWidget {
  const DurationField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationFormBloc, MedicationFormState>(
      buildWhen: (previous, current) => previous.duration != current.duration,
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Duración (días)',
            errorText: state.duration.isNotValid
                ? 'Ingrese una duración válida'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context.read<MedicationFormBloc>().add(
                  DurationChanged(value),
                );
          },
        );
      },
    );
  }
}
