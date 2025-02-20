part of 'medication_schedule_bloc.dart';

class CalculateSchedule extends MedicationFormEvent {}

class DurationChanged extends MedicationFormEvent {
  final String duration;
  DurationChanged(this.duration);
}

class FormSubmitted extends MedicationFormEvent {}

class IntervalChanged extends MedicationFormEvent {
  final String interval;
  IntervalChanged(this.interval);
}

class LoadMedicationList extends MedicationFormEvent {}

class MedicationChanged extends MedicationFormEvent {
  final String medication;
  MedicationChanged(this.medication);
}

abstract class MedicationFormEvent {}

class StartDateChanged extends MedicationFormEvent {
  final DateTime date;
  StartDateChanged(this.date);
}

class StartTimeChanged extends MedicationFormEvent {
  final TimeOfDay time;
  StartTimeChanged(this.time);
}
