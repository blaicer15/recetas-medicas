import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recetas/src/cubit/recipe/recipe_cubit.dart';

class AddRecipe extends StatelessWidget {
  const AddRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Receta'),
      ),
      body: BlocProvider(
        create: (context) => RecipeCubit(),
        child: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeError) {
              return Center(child: Text(state.message));
            } else if (state is RecipeLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildUserDropdown(context, state),
                            const SizedBox(height: 16),
                            _buildMedicineDropdown(context, state),
                            const SizedBox(height: 16),
                            _buildDateTimePicker(context, state),
                            const SizedBox(height: 16),
                            _buildTreatmentDaysInput(context, state),
                            const SizedBox(height: 16),
                            _buildDoseIntervalInput(context, state),
                            const SizedBox(height: 16),
                            _buildEndDate(state),
                            const SizedBox(height: 16),
                            _buildDosesList(state),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildSaveButton(context, state),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fecha y hora de inicio",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              state.startDate != null
                  ? _formatDateTime(state.startDate!)
                  : 'Selecciona fecha y hora',
            ),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: state.startDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && context.mounted) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(state.startDate ?? DateTime.now()),
                );
                if (pickedTime != null && context.mounted) {
                  final startDate = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  context.read<RecipeCubit>().changeStartDate(startDate);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoseIntervalInput(BuildContext context, RecipeLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Intervalo entre dosis (horas)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Ingrese el intervalo en horas",
            ),
            onChanged: (value) {
              final interval = int.tryParse(value);
              if (interval != null) {
                context.read<RecipeCubit>().changeDoseInterval(interval);
              }
            },
            initialValue: state.doseInterval?.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildDosesList(RecipeLoaded state) {
    return ExpansionTile(
      title: const Text(
        "Dosis programadas",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: state.doses.isEmpty
          ? [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No hay dosis programadas"),
              )
            ]
          : state.doses
              .map((dose) => ListTile(
                    title: Text(_formatDateTime(dose)),
                    leading: const Icon(Icons.calendar_today),
                  ))
              .toList(),
    );
  }

  Widget _buildEndDate(RecipeLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fecha de finalización",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              state.endDate != null
                  ? _formatDateTime(state.endDate!)
                  : 'Calculando...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineDropdown(BuildContext context, RecipeLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medicamento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: state.selectedMedicineId,
            decoration: const InputDecoration(
              hintText: "Seleccione un medicamento",
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
            items: state.medicines
                .map((medicine) => DropdownMenuItem<String>(
                      value: medicine['id'] as String,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            medicine['nombre']?.toString() ?? 'Sin nombre',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (medicine['generic_name'] != null)
                            Text(
                              medicine['generic_name'].toString(),
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<RecipeCubit>().selectMedicine(value);
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.vaccines),
              onPressed: () => context.push("/addMedicine"),
              tooltip: "Agregar medicamento",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, RecipeLoaded state) {
    bool isValid = state.selectedUserId != null &&
        state.selectedMedicineId != null &&
        state.startDate != null &&
        state.treatmentDays != null &&
        state.doseInterval != null;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isValid
            ? () {
                context.read<RecipeCubit>().saveRecipe().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Receta guardada exitosamente'),
                    ),
                  );
                  context.pop();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar la receta: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
        child: const Text(
          'Guardar Receta',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTreatmentDaysInput(BuildContext context, RecipeLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Días de tratamiento",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Ingrese los días de tratamiento",
            ),
            onChanged: (value) {
              final days = int.tryParse(value);
              if (days != null) {
                context.read<RecipeCubit>().changeTreatmentDays(days);
              }
            },
            initialValue: state.treatmentDays?.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDropdown(BuildContext context, RecipeLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Persona",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: state.selectedUserId,
            decoration: const InputDecoration(
              hintText: "Seleccione una persona",
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
            items: state.users
                .map((user) => DropdownMenuItem<String>(
                      value: user['id'] as String,
                      child: Text(
                        user['nombre']
                            as String, // Cambiado de 'name' a 'nombre'
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<RecipeCubit>().selectUser(value);
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => context.push("/addPerson"),
              tooltip: "Agregar persona",
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'No seleccionada';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
