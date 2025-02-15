import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recetas/src/bloc/add_medicine/add_medicine_bloc.dart';

class FormMedicine extends StatelessWidget {
  const FormMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMedicineBloc, AddMedicineState>(
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _NombreInput(),
              const _NombreGenericoInput(),
              SwitchListTile(
                title: const Text('¿Es pediátrico?'),
                value: state.isPediatric,
                onChanged: (value) => context
                    .read<AddMedicineBloc>()
                    .add(SetIsPediatric(isPediatric: value)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: state.isValid
                    ? () => context
                        .read<AddMedicineBloc>()
                        .add(const SetSubmitted())
                    : null,
                child: const Text('Guardar'),
              ),
              // Mostrar mensaje de éxito o error
              if (state.status == FormzSubmissionStatus.success)
                const Text('Medicamento guardado correctamente')
              else if (state.status == FormzSubmissionStatus.failure)
                const Text('Error al guardar el medicamento'),
            ],
          ),
        );
      },
    );
  }
}

class _NombreGenericoInput extends StatelessWidget {
  const _NombreGenericoInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
        (AddMedicineBloc bloc) => bloc.state.nombreGenerico.displayError);

    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Nombre Genérico', errorText: displayError),
      onChanged: (value) => context
          .read<AddMedicineBloc>()
          .add(SetGenericNameChanged(nombreGenerico: value)),
    );
  }
}

class _NombreInput extends StatelessWidget {
  const _NombreInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context
        .select((AddMedicineBloc bloc) => bloc.state.nombre.displayError);

    return TextFormField(
      decoration: InputDecoration(labelText: 'Nombre', errorText: displayError),
      onChanged: (value) =>
          context.read<AddMedicineBloc>().add(SetNombreChanged(nombre: value)),
      // Mostrar error si el nombre está vacío
    );
  }
}
