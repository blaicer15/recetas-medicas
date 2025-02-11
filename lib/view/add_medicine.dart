import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetas/src/cubit/recetas/add_receta_cubit.dart';

class AddMedicine extends StatelessWidget {
  const AddMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => AddRecetaCubit(),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Nombre del medicamento"),
              subtitle: TextField(
                onChanged: (value) =>
                    context.read<AddRecetaCubit>().changeNombre(value),
              ),
            ),
            ListTile(
              title: const Text("Nombre generico del medicamento"),
              subtitle: TextField(
                onChanged: (value) =>
                    context.read<AddRecetaCubit>().changeNombreGenerico(value),
              ),
            ),
            ListTile(
              title: const Text("Cantidad a tomar en ML"),
              subtitle: TextField(
                onChanged: (value) => context
                    .read<AddRecetaCubit>()
                    .changeMl(value.isEmpty ? 0 : double.parse(value)),
              ),
            ),
            RichText(text: const TextSpan(text: "Tiempo de tratamiento")),
            BlocBuilder<AddRecetaCubit, AddRecetaState>(
              builder: (context, state) {
                return ListTile(
                  title: const Text("Fecha y hora de inicio"),
                  subtitle: Text(_formatDateTime(state.startDate)),
                  onTap: () => _selectStartDateTime(context),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<AddRecetaCubit, AddRecetaState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Días de tratamiento',
                                helperText: 'Número de días',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final days = int.tryParse(value);
                                if (days != null) {
                                  context
                                      .read<AddRecetaCubit>()
                                      .changeTratamientoDias(days);
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Intervalo de horas',
                                helperText: 'Horas entre dosis',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final hours = int.tryParse(value);
                                if (hours != null) {
                                  context
                                      .read<AddRecetaCubit>()
                                      .changeInterval(hours);
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text("Fecha y hora de finalización"),
                        subtitle: Text(_formatDateTime(state.endDate)),
                      ),
                      if (state.interval > 0) _buildSchedule(state),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule(AddRecetaState state) {
    final schedule = <DateTime>[];
    var currentTime = state.startDate;
    final endTime = state.endDate;

    while (currentTime.isBefore(endTime)) {
      schedule.add(currentTime);
      currentTime = currentTime.add(Duration(hours: state.interval));
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Programación de dosis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Dosis ${index + 1}'),
                subtitle: Text(_formatDateTime(schedule[index])),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'No seleccionada';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectStartDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: context.read<AddRecetaCubit>().state.startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    );

    if (context.mounted) {
      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (context.mounted) {
            context.read<AddRecetaCubit>().changeStartDate(combinedDateTime);
          }
        }
      }
    }
  }
}
