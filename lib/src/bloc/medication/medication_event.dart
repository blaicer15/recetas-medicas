part of 'medication_bloc.dart';

class DescriptionChanged extends MedicationEvent {
  final String description;
  const DescriptionChanged(this.description);
}

class DosageChanged extends MedicationEvent {
  final double? dosage;

  const DosageChanged(this.dosage);

  @override
  List<Object?> get props => [dosage];
}

class GenericNameChanged extends MedicationEvent {
  final String name;

  const GenericNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class IsPediatricChanged extends MedicationEvent {
  final bool isPediatric;

  const IsPediatricChanged(this.isPediatric);

  @override
  List<Object> get props => [isPediatric];
}

abstract class MedicationEvent extends Equatable {
  const MedicationEvent();

  @override
  List<Object?> get props => [];
}

class MedicationNameChanged extends MedicationEvent {
  final String name;

  const MedicationNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class MedicationSubmitted extends MedicationEvent {
  const MedicationSubmitted();
}
