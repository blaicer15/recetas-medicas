import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recetas/src/bloc/medication/medication_bloc.dart';
import 'package:recetas/src/model/medication_form.dart';

class MedicationForm extends StatelessWidget {
  const MedicationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MedicationNameInput(),
            const SizedBox(height: 16),
            _GenericNameInput(),
            const SizedBox(height: 16),
            _IsPediatricSwitch(),
            const SizedBox(height: 16),
            _DosageInput(),
            const SizedBox(height: 16),
            _DescriptionInput(),
            const SizedBox(height: 24),
            _SubmitButton(),
          ],
        );
      },
    );
  }
}

class MedicationFormPage extends StatelessWidget {
  const MedicationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicationBloc(),
      child: const MedicationFormView(),
    );
  }
}

class MedicationFormView extends StatelessWidget {
  const MedicationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationBloc, MedicationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('¡Medicamento guardado exitosamente!')),
          );
        }
        if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error al guardar'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Nuevo Medicamento')),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: MedicationForm(),
        ),
      ),
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextField(
          key: const Key('medicationForm_descriptionInput_textField'),
          maxLines: 3,
          onChanged: (description) => context
              .read<MedicationBloc>()
              .add(DescriptionChanged(description)),
          decoration: InputDecoration(
            labelText: 'Descripción (opcional)',
            errorText: state.description.error == DescriptionError.invalid
                ? 'Ingrese una descripción válida'
                : null,
          ),
        );
      },
    );
  }
}

class _DosageInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      buildWhen: (previous, current) => previous.dosage != current.dosage,
      builder: (context, state) {
        return TextField(
          key: const Key('medicationForm_dosageInput_textField'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (dosage) => context.read<MedicationBloc>().add(
                DosageChanged(double.tryParse(dosage)),
              ),
          decoration: InputDecoration(
            labelText: 'Dosis (mL)',
            errorText: state.dosage.error == DosageError.invalid
                ? 'Ingrese una dosis válida'
                : null,
          ),
        );
      },
    );
  }
}

class _GenericNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      buildWhen: (previous, current) =>
          previous.genericName != current.genericName,
      builder: (context, state) {
        return TextField(
          key: const Key('medicationForm_genericNameInput_textField'),
          onChanged: (name) =>
              context.read<MedicationBloc>().add(GenericNameChanged(name)),
          decoration: InputDecoration(
            labelText: 'Nombre genérico (opcional)',
            errorText: state.genericName.error == GenericNameError.invalid
                ? 'Ingrese un nombre genérico válido'
                : null,
          ),
        );
      },
    );
  }
}

class _IsPediatricSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      buildWhen: (previous, current) =>
          previous.isPediatric != current.isPediatric,
      builder: (context, state) {
        return Row(
          children: [
            Switch(
              value: state.isPediatric,
              onChanged: (value) =>
                  context.read<MedicationBloc>().add(IsPediatricChanged(value)),
            ),
            const Text('¿Es pediátrico?'),
          ],
        );
      },
    );
  }
}

class _MedicationNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      buildWhen: (previous, current) =>
          previous.medicationName != current.medicationName,
      builder: (context, state) {
        return TextField(
          key: const Key('medicationForm_nameInput_textField'),
          onChanged: (name) =>
              context.read<MedicationBloc>().add(MedicationNameChanged(name)),
          decoration: InputDecoration(
            labelText: 'Nombre del medicamento',
            errorText: state.medicationName.error == MedicationNameError.empty
                ? 'El nombre no puede estar vacío'
                : state.medicationName.error == MedicationNameError.invalid
                    ? 'Ingrese un nombre válido'
                    : null,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationBloc, MedicationState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValid
              ? () {
                  context
                      .read<MedicationBloc>()
                      .add(const MedicationSubmitted());
                }
              : null,
          child: state.status == FormzSubmissionStatus.inProgress
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                )
              : const Text('Guardar'),
        );
      },
    );
  }
}
