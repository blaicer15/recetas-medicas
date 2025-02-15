import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:recetas/src/bloc/add_person/add_person_bloc.dart';

class FormPerson extends StatelessWidget {
  static const double _padding = 16.0;
  static const double _spacing = 16.0;
  static const double _maxWidth = 600.0;

  final _log = Logger();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  FormPerson({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPersonBloc, AddPersonState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Persona guardada exitosamente')),
          );
        } else if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(state.errorMessage ?? 'Error al guardar la persona'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) => LayoutBuilder(
        builder: (context, constraints) {
          final isTabletOrDesktop = constraints.maxWidth > 600;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(_padding),
              child: Container(
                constraints: const BoxConstraints(maxWidth: _maxWidth),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isTabletOrDesktop)
                        _buildTabletLayout(context, state)
                      else
                        _buildMobileLayout(context, state),
                      const SizedBox(height: _spacing),
                      _buildSubmitButton(context, state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateField(BuildContext context, AddPersonState state) {
    final birthdate = context.watch<AddPersonBloc>().state.birthdate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fecha de Nacimiento'),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(
            text: birthdate.value != null
                ? _dateFormat.format(birthdate.value!)
                : 'Seleccionar fecha',
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            errorText: birthdate.displayError?.toString(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _showDatePicker(context),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          onTap: () => _showDatePicker(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AddPersonState state) {
    return Column(
      children: [
        _buildTextField(
          context: context,
          labelText: "Nombre (s)",
          initialValue: state.nombre.value,
          error: state.nombre.error,
          onChanged: (value) {
            context.read<AddPersonBloc>().add(AddPersonNameChanged(value));
          },
        ),
        const SizedBox(height: _spacing),
        _buildTextField(
          context: context,
          labelText: "Apellido paterno",
          initialValue: state.firstSurname.value,
          error: state.firstSurname.error,
          onChanged: (value) {
            context
                .read<AddPersonBloc>()
                .add(AddPersonFirstSurnameChanged(value));
          },
        ),
        const SizedBox(height: _spacing),
        _buildTextField(
          context: context,
          labelText: "Apellido materno",
          initialValue: state.secondSurname.value,
          error: state.secondSurname.error,
          onChanged: (value) {
            context
                .read<AddPersonBloc>()
                .add(AddPersonSecondSurnameChanged(value));
          },
        ),
        const SizedBox(height: _spacing),
        _buildDateField(context, state),
        const SizedBox(height: _spacing),
        _buildTextField(
          context: context,
          labelText: "Peso (kg)",
          initialValue: state.weight.value?.toString(),
          error: state.weight.displayError?.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            context.read<AddPersonBloc>().add(
                  AddPersonWeightChanged(double.tryParse(value)),
                );
          },
        ),
        const SizedBox(height: _spacing),
        _buildTextField(
          context: context,
          labelText: "Estatura (m)",
          initialValue: state.height.value?.toString(),
          error: state.height.displayError?.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            context.read<AddPersonBloc>().add(
                  AddPersonHeightChanged(double.tryParse(value)),
                );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, AddPersonState state) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: state.isValid
            ? () =>
                context.read<AddPersonBloc>().add(const AddPersonSubmitted())
            : null,
        child: state.status == FormzSubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : const Text("Guardar"),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, AddPersonState state) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                context: context,
                labelText: "Nombre (s)",
                initialValue: state.nombre.value,
                error: state.nombre.error,
                onChanged: (value) {
                  context
                      .read<AddPersonBloc>()
                      .add(AddPersonNameChanged(value));
                },
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(
              child: _buildTextField(
                context: context,
                labelText: "Apellido paterno",
                initialValue: state.firstSurname.value,
                error: state.firstSurname.error,
                onChanged: (value) {
                  context
                      .read<AddPersonBloc>()
                      .add(AddPersonFirstSurnameChanged(value));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: _spacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                context: context,
                labelText: "Apellido materno",
                initialValue: state.secondSurname.value,
                error: state.secondSurname.error,
                onChanged: (value) {
                  context
                      .read<AddPersonBloc>()
                      .add(AddPersonSecondSurnameChanged(value));
                },
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(child: _buildDateField(context, state)),
          ],
        ),
        const SizedBox(height: _spacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                context: context,
                labelText: "Peso (kg)",
                initialValue: state.weight.value?.toString(),
                error: state.weight.displayError?.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  context.read<AddPersonBloc>().add(
                        AddPersonWeightChanged(double.tryParse(value)),
                      );
                },
              ),
            ),
            const SizedBox(width: _spacing),
            Expanded(
              child: _buildTextField(
                context: context,
                labelText: "Estatura (m)",
                initialValue: state.height.value?.toString(),
                error: state.height.displayError?.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  context.read<AddPersonBloc>().add(
                        AddPersonHeightChanged(double.tryParse(value)),
                      );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String labelText,
    TextInputType? keyboardType,
    String? error,
    required void Function(String) onChanged,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        errorText: error,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null && context.mounted) {
      context.read<AddPersonBloc>().add(AddPersonBirthdateChanged(picked));
    }
  }
}
