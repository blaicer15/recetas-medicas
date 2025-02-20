import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/bloc/medication_schedule/medication_schedule_bloc.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationFormBloc, MedicationFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValid
              ? () {
                  context.read<MedicationFormBloc>().add(FormSubmitted());
                }
              : null,
          child: const Text('Programar Medicamento'),
        );
      },
    );
  }
}
