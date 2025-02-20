import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recetas/src/model/medication.dart';
import 'package:recetas/src/model/medication/duration_inpuy.dart';
import 'package:recetas/src/model/medication/interval_input.dart';
import 'package:recetas/src/model/medication/medication_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'medication_schedule_event.dart';
part 'medication_schedule_state.dart';

class MedicationFormBloc
    extends Bloc<MedicationFormEvent, MedicationFormState> {
  final SupabaseClient supabase = Supabase.instance.client;
  // final FlutterLocalNotificationsPlugin notifications;

  MedicationFormBloc() : super(MedicationFormState()) {
    on<LoadMedicationList>(_onLoadMedicationList);
    on<MedicationChanged>(_onMedicationChanged);
    on<IntervalChanged>(_onIntervalChanged);
    on<DurationChanged>(_onDurationChanged);
    on<StartDateChanged>(_onStartDateChanged);
    on<StartTimeChanged>(_onStartTimeChanged);
    on<CalculateSchedule>(_onCalculateSchedule);
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onCalculateSchedule(
    CalculateSchedule event,
    Emitter<MedicationFormState> emit,
  ) {
    if (state.interval.isValid && state.duration.isValid) {
      final intervalHours = int.tryParse(state.interval.value) ?? 0;
      final durationDays = int.tryParse(state.duration.value) ?? 0;

      if (intervalHours > 0 && durationDays > 0) {
        final startDateTime = DateTime(
          state.startDate.year,
          state.startDate.month,
          state.startDate.day,
          state.startTime.hour,
          state.startTime.minute,
        );

        final endDate = startDateTime.add(Duration(days: durationDays));
        final scheduledTimes = <DateTime>[];

        var currentTime = startDateTime;
        while (currentTime.isBefore(endDate)) {
          scheduledTimes.add(currentTime);
          currentTime = currentTime.add(Duration(hours: intervalHours));
        }

        emit(state.copyWith(scheduledTimes: scheduledTimes));
      }
    }
  }

  void _onDurationChanged(
    DurationChanged event,
    Emitter<MedicationFormState> emit,
  ) {
    final duration = DurationInput.dirty(event.duration);
    emit(state.copyWith(
      duration: duration,
      isValid: Formz.validate([state.medication, state.interval, duration]),
    ));
    add(CalculateSchedule());
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<MedicationFormState> emit,
  ) async {
    if (state.status.isFailure) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final startDateTime = DateTime(
        state.startDate.year,
        state.startDate.month,
        state.startDate.day,
        state.startTime.hour,
        state.startTime.minute,
      );

      // Guardar en Supabase
      await supabase.from('receta_medicamentos').insert({
        'medicina_id': state.medication.value,
        'dias_tratamiento': int.parse(state.duration.value),
        'fecha_inicio': startDateTime.toIso8601String(),
        'intervalo_horas': int.parse(state.interval.value),
        'fechas_programadas':
            state.scheduledTimes.map((dt) => dt.toIso8601String()).toList(),
      });

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Error al guardar: ${e.toString()}',
      ));
    }
  }

  void _onIntervalChanged(
    IntervalChanged event,
    Emitter<MedicationFormState> emit,
  ) {
    final interval = IntervalInput.dirty(event.interval);
    emit(state.copyWith(
      interval: interval,
      isValid: Formz.validate([state.medication, interval, state.duration]),
    ));
    add(CalculateSchedule());
  }

  Future<void> _onLoadMedicationList(
    LoadMedicationList event,
    Emitter<MedicationFormState> emit,
  ) async {
    try {
      final response = await supabase.from('medicinas').select('*');
      final medications =
          (response as List).map((json) => Medication.fromJson(json)).toList();
      emit(state.copyWith(medications: medications));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Error al cargar medicamentos: ${e.toString()}',
      ));
    }
  }

  void _onMedicationChanged(
    MedicationChanged event,
    Emitter<MedicationFormState> emit,
  ) {
    final medication = MedicationInput.dirty(event.medication);
    emit(state.copyWith(
      medication: medication,
      isValid: Formz.validate([medication, state.interval, state.duration]),
    ));
    add(CalculateSchedule());
  }

  void _onStartDateChanged(
    StartDateChanged event,
    Emitter<MedicationFormState> emit,
  ) {
    emit(state.copyWith(startDate: event.date));
    add(CalculateSchedule());
  }

  void _onStartTimeChanged(
    StartTimeChanged event,
    Emitter<MedicationFormState> emit,
  ) {
    emit(state.copyWith(startTime: event.time));
    add(CalculateSchedule());
  }
}
