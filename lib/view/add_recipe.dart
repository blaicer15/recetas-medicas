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
                            _buildMedicationsList(context, state),
                            const SizedBox(height: 16),
                            _buildAddMedicationButton(context),
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

  Widget _buildAddMedicationButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // context.read<RecipeCubit>().addNewMedicine();
        context.push("/addMedication");
      },
      icon: const Icon(Icons.add),
      label: const Text('Agregar Medicamento'),
    );
  }

  Widget _buildDateTimePicker(BuildContext context, RecipeLoaded state,
      Map<String, dynamic> medication) {
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
              medication['startDate'] != null
                  ? _formatDateTime(medication['startDate'])
                  : 'Selecciona fecha y hora',
            ),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: medication['startDate'] ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && context.mounted) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                      medication['startDate'] ?? DateTime.now()),
                );
                if (pickedTime != null && context.mounted) {
                  final startDate = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  context.read<RecipeCubit>().updateMedicineStartDate(
                        medication['medicineId'],
                        startDate,
                      );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoseIntervalInput(BuildContext context, RecipeLoaded state,
      Map<String, dynamic> medication) {
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
                context.read<RecipeCubit>().updateMedicineInterval(
                      medication['medicineId'],
                      interval,
                    );
              }
            },
            initialValue: medication['doseInterval']?.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildDosesList(RecipeLoaded state, Map<String, dynamic> medication) {
    final doses = medication['doses'] as List<DateTime>? ?? [];
    return ExpansionTile(
      title: const Text(
        "Dosis programadas",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: doses.isEmpty
          ? [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No hay dosis programadas"),
              )
            ]
          : doses
              .map((dose) => ListTile(
                    title: Text(_formatDateTime(dose)),
                    leading: const Icon(Icons.calendar_today),
                  ))
              .toList(),
    );
  }

  Widget _buildEndDate(RecipeLoaded state, Map<String, dynamic> medication) {
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
              medication['endDate'] != null
                  ? _formatDateTime(medication['endDate'])
                  : 'Calculando...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationsList(BuildContext context, RecipeLoaded state) {
    return Column(
      children: [
        for (var medication in state.medicines)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(medication['medicineName'] ?? 'Medicamento'),
              subtitle: Text('ID: ${medication['medicineId']}'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMedicineDropdown(context, state, medication),
                      const SizedBox(height: 16),
                      _buildTreatmentDaysInput(context, state, medication),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(context, state, medication),
                      const SizedBox(height: 16),
                      _buildDoseIntervalInput(context, state, medication),
                      const SizedBox(height: 16),
                      _buildEndDate(state, medication),
                      const SizedBox(height: 16),
                      _buildNextDose(state, medication),
                      const SizedBox(height: 16),
                      _buildDosesList(state, medication),
                      const SizedBox(height: 16),
                      _buildSetAlarmButton(context, medication),
                      const SizedBox(height: 8),
                      _buildRemoveMedicationButton(context, medication),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMedicineDropdown(BuildContext context, RecipeLoaded state,
      Map<String, dynamic> medication) {
    return ListTile(
      title: const Text("Seleccione un medicamento"),
      subtitle: DropdownButton<String>(
        value: medication['medicineId'],
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
                      ),
                      if (medicine['generic_name'] != null)
                        Text(
                          medicine['generic_name'].toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<RecipeCubit>().updateMedicineId(
                  medication['medicineId'],
                  value,
                );
          }
        },
        isExpanded: true,
      ),
    );
  }

  Widget _buildNextDose(RecipeLoaded state, Map<String, dynamic> medication) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Próxima dosis",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              medication['nextDose'] != null
                  ? _formatDateTime(medication['nextDose'])
                  : 'Pendiente de calcular',
            ),
            leading: const Icon(Icons.notification_important),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveMedicationButton(
      BuildContext context, Map<String, dynamic> medication) {
    return TextButton.icon(
      onPressed: () {
        context.read<RecipeCubit>().removeMedicine(medication['medicineId']);
      },
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text('Eliminar Medicamento',
          style: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildSaveButton(BuildContext context, RecipeLoaded state) {
    bool isValid = state.selectedPatientId != null &&
        state.medicines.isNotEmpty &&
        state.medicines.every((medication) =>
            medication['medicineId'] != null &&
            medication['startDate'] != null &&
            medication['treatmentDays'] != null &&
            medication['doseInterval'] != null);

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
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Receta guardada exitosamente'),
                      ),
                    );
                  }
                }).catchError((error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar la receta: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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

  Widget _buildSetAlarmButton(
      BuildContext context, Map<String, dynamic> medication) {
    return ElevatedButton.icon(
      onPressed: () {
        // Aquí se implementaría la lógica para configurar la alarma
        context.read<RecipeCubit>().setMedicineAlarm(medication['medicineId']);
      },
      icon: const Icon(Icons.alarm_add),
      label: const Text('Configurar Alarma'),
    );
  }

  Widget _buildTreatmentDaysInput(BuildContext context, RecipeLoaded state,
      Map<String, dynamic> medication) {
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
                context.read<RecipeCubit>().updateMedicineTreatmentDays(
                      medication['medicineId'],
                      days,
                    );
              }
            },
            initialValue: medication['treatmentDays']?.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDropdown(BuildContext context, RecipeLoaded state) {
    return ListTile(
      title: const Text(
        "Seleccione una persona",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: DropdownButtonFormField<String>(
        isExpanded: true,
        value: state.selectedPatientId,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
        items: state.patients
            .map((user) => DropdownMenuItem<String>(
                  value: user['id'] as String,
                  child: Text(
                    user['nombre'] as String,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<RecipeCubit>().selectPatient(value);
          }
        },
      ),
      trailing: InkWell(
        child: const Icon(Icons.person_add),
        onTap: () => context.push("/addPerson"),
        onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Agregar persona")),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
