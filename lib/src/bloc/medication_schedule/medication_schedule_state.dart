part of 'medication_schedule_bloc.dart';

class MedicationFormState {
  final FormzSubmissionStatus status;
  final MedicationInput medication;
  final IntervalInput interval;
  final DurationInput duration;
  final DateTime startDate;
  final TimeOfDay startTime;
  final List<Medication> medications;
  final List<DateTime> scheduledTimes;
  final String? errorMessage;
  final bool isValid;

  MedicationFormState({
    this.status = FormzSubmissionStatus.initial,
    this.medication = const MedicationInput.pure(),
    this.interval = const IntervalInput.pure(),
    this.duration = const DurationInput.pure(),
    DateTime? startDate,
    TimeOfDay? startTime,
    this.medications = const [],
    this.scheduledTimes = const [],
    this.isValid = false,
    this.errorMessage,
  })  : startDate = startDate ?? DateTime.now(),
        startTime = startTime ?? TimeOfDay.now();

  MedicationFormState copyWith({
    FormzSubmissionStatus? status,
    MedicationInput? medication,
    IntervalInput? interval,
    DurationInput? duration,
    DateTime? startDate,
    TimeOfDay? startTime,
    List<Medication>? medications,
    List<DateTime>? scheduledTimes,
    String? errorMessage,
    bool? isValid,
  }) {
    return MedicationFormState(
        status: status ?? this.status,
        medication: medication ?? this.medication,
        interval: interval ?? this.interval,
        duration: duration ?? this.duration,
        startDate: startDate ?? this.startDate,
        startTime: startTime ?? this.startTime,
        medications: medications ?? this.medications,
        scheduledTimes: scheduledTimes ?? this.scheduledTimes,
        errorMessage: errorMessage,
        isValid: isValid ?? this.isValid);
  }
}
