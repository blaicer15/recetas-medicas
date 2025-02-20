import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _log = Logger();

  RecipeCubit() : super(RecipeInitial()) {
    loadData();
  }

  void addNewMedicine() {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final newMedicine = {
      'medicina_id': null,
      'fecha_inicio': null,
      'dias_tratamiento': null,
      'intervalo_horas': null,
      'dosis': null,
      'fechas_programadas': <DateTime>[],
      'proxima_dosis': null,
      'fecha_fin': null,
    };

    final updatedMedicines = [
      ...currentState.prescriptionMedicines,
      newMedicine
    ];
    _log.d(updatedMedicines);
    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
  }

  Future<void> loadData() async {
    emit(RecipeLoading());
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Obtener el ID de la persona responsable

        final responsableData = await supabase
            .from('personas')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();

        final medicines = await supabase
            .from('medicinas')
            .select('id, nombre, nombre_generico, miligramos, es_pediatrico');
        if (responsableData != null) {
          final responsableId = responsableData['id'];

          // Obtener pacientes asociados al responsable
          final patients = await supabase
              .from('personas')
              .select('id, nombre, apellido_paterno, apellido_materno')
              .neq('responsable_id',
                  responsableId); // Excluir al responsable de la lista

          // Aquí puedes manejar los pacientes obtenidos
          emit(RecipeLoaded(
            patients: patients,
            medicines: medicines,
            prescriptionMedicines: [],
          ));
        } else {
          emit(RecipeLoaded(
            patients: [],
            medicines: medicines,
            prescriptionMedicines: [],
          ));
        }
      }
    } catch (e) {
      _log.e(e.toString());
      emit(RecipeError(e.toString()));
    }
  }

  void removeMedicine(String medicineId) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final updatedMedicines = currentState.prescriptionMedicines
        .where((med) => med['medicina_id'] != medicineId)
        .toList();

    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
  }

  Future<void> saveRecipe() async {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    if (!_validateRecipe(currentState)) {
      emit(RecipeError('Por favor complete todos los campos requeridos'));
      return;
    }

    try {
      emit(RecipeLoading());

      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      // Obtener el ID del responsable
      final responsableData = await supabase
          .from('personas')
          .select('id')
          .eq('user_id', user.id)
          .single();

      // Crear la receta
      final recipeData = {
        'persona_id': currentState.selectedPatientId,
        'responsable_id': responsableData['id'],
        'notas': currentState.notes,
      };

      final recipeResponse =
          await supabase.from('recetas').insert(recipeData).select().single();

      // Insertar los medicamentos de la receta
      for (final medicine in currentState.prescriptionMedicines) {
        final medicineData = {
          'receta_id': recipeResponse['id'],
          'medicina_id': medicine['medicina_id'],
          'dias_tratamiento': medicine['dias_tratamiento'],
          'fecha_inicio': medicine['fecha_inicio'].toIso8601String(),
          'intervalo_horas': medicine['intervalo_horas'],
          'dosis': medicine['dosis'],
        };

        await supabase.from('receta_medicamentos').insert(medicineData);
      }

      emit(currentState.copyWith(savedSuccessfully: true));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  void selectPatient(String patientId) {
    if (state is! RecipeLoaded) return;
    emit((state as RecipeLoaded).copyWith(selectedPatientId: patientId));
  }

  void setMedicineAlarm(String medicineId) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final medicine = currentState.prescriptionMedicines
        .firstWhere((med) => med['medicina_id'] == medicineId);

    _log.d('Setting alarm for medicine: ${medicine['medicina_id']}');
    // Implementar lógica de alarmas aquí
  }

  void updateMedicineDosis(String medicineId, String dosis) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final updatedMedicines = currentState.prescriptionMedicines.map((med) {
      if (med['medicina_id'] == medicineId) {
        return {...med, 'dosis': dosis};
      }
      return med;
    }).toList();

    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
  }

  void updateMedicineId(String oldId, String newId) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final updatedMedicines = currentState.prescriptionMedicines.map((med) {
      if (med['medicina_id'] == oldId) {
        return {...med, 'medicina_id': newId};
      }
      return med;
    }).toList();

    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
  }

  void updateMedicineInterval(String medicineId, int interval) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final updatedMedicines = currentState.prescriptionMedicines.map((med) {
      if (med['medicina_id'] == medicineId) {
        return {...med, 'intervalo_horas': interval};
      }
      return med;
    }).toList();

    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
    _calculateMedicineSchedule(medicineId);
  }

  void updateMedicineStartDate(String medicineId, DateTime startDate) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final updatedMedicines = currentState.prescriptionMedicines.map((med) {
      if (med['medicina_id'] == medicineId) {
        return {...med, 'fecha_inicio': startDate};
      }
      return med;
    }).toList();

    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
    _calculateMedicineSchedule(medicineId);
  }

  void updateMedicineTreatmentDays(String medicineId, int days) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final updatedMedicines = currentState.prescriptionMedicines.map((med) {
      if (med['medicina_id'] == medicineId) {
        return {...med, 'dias_tratamiento': days};
      }
      return med;
    }).toList();

    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
    _calculateMedicineSchedule(medicineId);
  }

  void updateNotes(String notes) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;
    emit(currentState.copyWith(notes: notes));
  }

  void _calculateMedicineSchedule(String medicineId) {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;

    final medicineIndex = currentState.prescriptionMedicines
        .indexWhere((med) => med['medicina_id'] == medicineId);
    if (medicineIndex == -1) return;

    final medicine = currentState.prescriptionMedicines[medicineIndex];

    if (medicine['fecha_inicio'] == null ||
        medicine['dias_tratamiento'] == null ||
        medicine['intervalo_horas'] == null) return;

    final startDate = medicine['fecha_inicio'] as DateTime;
    final treatmentDays = medicine['dias_tratamiento'] as int;
    final intervalHours = medicine['intervalo_horas'] as int;

    final endDate = startDate.add(Duration(days: treatmentDays));
    final scheduledDates = <DateTime>[];
    var currentDate = startDate;

    while (currentDate.isBefore(endDate)) {
      scheduledDates.add(currentDate);
      currentDate = currentDate.add(Duration(hours: intervalHours));
    }

    final updatedMedicine = {
      ...medicine,
      'fecha_fin': endDate,
      'fechas_programadas': scheduledDates,
      'proxima_dosis': scheduledDates.firstWhere(
        (date) => date.isAfter(DateTime.now()),
        orElse: () => endDate,
      ),
    };

    final updatedMedicines = [...currentState.prescriptionMedicines];
    updatedMedicines[medicineIndex] = updatedMedicine;

    emit(currentState.copyWith(prescriptionMedicines: updatedMedicines));
  }

  bool _validateRecipe(RecipeLoaded state) {
    if (state.selectedPatientId == null ||
        state.prescriptionMedicines.isEmpty) {
      return false;
    }
    return false;
  }
}
