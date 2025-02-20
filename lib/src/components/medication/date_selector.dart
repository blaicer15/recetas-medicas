import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/bloc/medication_schedule/medication_schedule_bloc.dart';

class DateTimeSelector extends StatelessWidget {
  const DateTimeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationFormBloc, MedicationFormState>(
      buildWhen: (previous, current) =>
          previous.startDate != current.startDate ||
          previous.startTime != current.startTime,
      builder: (context, state) {
        return Column(
          children: [
            ListTile(
              title: const Text('Fecha de inicio'),
              subtitle: Text(
                '${state.startDate.day}/${state.startDate.month}/${state.startDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  if (context.mounted) {
                    context
                        .read<MedicationFormBloc>()
                        .add(StartDateChanged(date));
                  }
                }
              },
            ),
            ListTile(
              title: const Text('Hora de inicio'),
              subtitle: Text(
                '${state.startTime.hour}:${state.startTime.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: state.startTime,
                );
                if (time != null) {
                  if (context.mounted) {
                    context
                        .read<MedicationFormBloc>()
                        .add(StartTimeChanged(time));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
