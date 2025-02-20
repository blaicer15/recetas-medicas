import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/bloc/medication_schedule/medication_schedule_bloc.dart';

class IntervalField extends StatelessWidget {
  const IntervalField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationFormBloc, MedicationFormState>(
      buildWhen: (previous, current) => previous.interval != current.interval,
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Intervalo (horas)',
            errorText: state.interval.isNotValid
                ? 'Ingrese un intervalo válido (1-24 horas)'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context.read<MedicationFormBloc>().add(
                  IntervalChanged(value),
                );
          },
        );
      },
    );
  }
}
