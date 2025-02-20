import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recetas/src/bloc/medication_schedule/medication_schedule_bloc.dart';
import 'package:recetas/src/components/medication/date_selector.dart';
import 'package:recetas/src/components/medication/dropdown.dart';
import 'package:recetas/src/components/medication/duration.dart';
import 'package:recetas/src/components/medication/interval.dart';
import 'package:recetas/src/components/medication/preview.dart';
import 'package:recetas/src/components/medication/submit_button.dart';

class MedicationScheduleForm extends StatelessWidget {
  const MedicationScheduleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicationFormBloc()..add(LoadMedicationList()),
      child: const MedicationScheduleFormView(),
    );
  }
}

class MedicationScheduleFormView extends StatelessWidget {
  const MedicationScheduleFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationFormBloc, MedicationFormState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Medicamento programado con éxito!')),
          );
          Navigator.pop(context);
        }
        if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Programar Medicamento')),
        body: BlocBuilder<MedicationFormBloc, MedicationFormState>(
          builder: (context, state) {
            if (state.status == FormzSubmissionStatus.inProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: ListView(
                  children: [
                    const MedicationDropdown(),
                    const SizedBox(height: 16),
                    const IntervalField(),
                    const SizedBox(height: 16),
                    const DurationField(),
                    const SizedBox(height: 16),
                    const DateTimeSelector(),
                    const SizedBox(height: 24),
                    if (state.scheduledTimes.isNotEmpty)
                      SchedulePreview(times: state.scheduledTimes),
                    const SizedBox(height: 24),
                    const SubmitButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
