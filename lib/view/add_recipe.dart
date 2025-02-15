import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recetas/src/cubit/recipe/recipe_cubit.dart';

class AddRecipe extends StatelessWidget {
  const AddRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => RecipeCubit(),
        child: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeError) {
              return Center(child: Text(state.message));
            } else if (state is RecipeLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildUserDropdown(context, state),
                  _buildMedicineDropdown(context, state),
                  _buildDateTimePicker(context, state),
                  _buildTreatmentDaysInput(context, state),
                  _buildDoseIntervalInput(context, state),
                  _buildEndDate(state),
                  _buildDosesList(state)
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(BuildContext context, RecipeLoaded state) {
    return ListTile(
      title: const Text("Fecha y hora de inicio"),
      subtitle: Text(state.startDate != null
          ? _formatDateTime(state.startDate!)
          : 'Selecciona fecha y hora'),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: state.startDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          if (context.mounted) {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(state.startDate ?? DateTime.now()),
            );
            if (pickedTime != null) {
              final startDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              if (context.mounted) {
                context.read<RecipeCubit>().changeStartDate(startDate);
              }
            }
          }
        }
      },
    );
  }

  Widget _buildDoseIntervalInput(BuildContext context, RecipeLoaded state) {
    return ListTile(
      title: const Text("Intervalo entre dosis (horas)"),
      subtitle: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          final interval = int.tryParse(value);
          if (interval != null) {
            context.read<RecipeCubit>().changeDoseInterval(interval);
          }
        },
        initialValue: state.doseInterval?.toString(),
      ),
    );
  }

  Widget _buildDosesList(RecipeLoaded state) {
    return ExpansionTile(
      title: const Text("Dosis programadas"),
      children: state.doses
          .map((dose) => ListTile(
                title: Text(_formatDateTime(dose)),
              ))
          .toList(),
    );
  }

  Widget _buildEndDate(RecipeLoaded state) {
    return ListTile(
      title: const Text("Fecha de finalización"),
      subtitle: Text(state.endDate != null
          ? _formatDateTime(state.endDate!)
          : 'Calculando...'),
    );
  }

  Widget _buildMedicineDropdown(BuildContext context, RecipeLoaded state) {
    return ListTile(
      title: const Text("Seleccione un medicamento"),
      subtitle: DropdownButton<String>(
        value: state.selectedMedicineId,
        items: state.medicines
            .map((medicine) => DropdownMenuItem<String>(
                  value: medicine['id'] as String,
                  child: Text(medicine['name'] as String),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<RecipeCubit>().selectMedicine(value);
          }
        },
      ),
      trailing: InkWell(
        child: const Icon(Icons.vaccines),
        onTap: () => context.go("/addMedicine"),
        onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Agregar medicamento")),
        ),
      ),
    );
  }

  Widget _buildTreatmentDaysInput(BuildContext context, RecipeLoaded state) {
    return ListTile(
      title: const Text("Días de tratamiento"),
      subtitle: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          final days = int.tryParse(value);
          if (days != null) {
            context.read<RecipeCubit>().changeTreatmentDays(days);
          }
        },
        initialValue: state.treatmentDays?.toString(),
      ),
    );
  }

  Widget _buildUserDropdown(BuildContext context, RecipeLoaded state) {
    return ListTile(
      title: const Text("Selecciona una persona"),
      subtitle: DropdownButton<String>(
        value: state.selectedUserId,
        items: state.users
            .map((user) => DropdownMenuItem<String>(
                  value: user['id'] as String,
                  child: Text(user['name'] as String),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<RecipeCubit>().selectUser(value);
          }
        },
      ),
      trailing: InkWell(
        child: const Icon(Icons.plus_one),
        onTap: () => context.push("/addPerson"),
        onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Agregar una persona")),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'No seleccionada';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
