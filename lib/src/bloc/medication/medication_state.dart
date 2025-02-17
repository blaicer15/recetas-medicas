part of 'medication_bloc.dart';

class MedicationState extends Equatable {
  final FormzSubmissionStatus status;

  final MedicationName medicationName;
  final GenericName genericName;
  final bool isPediatric;
  final Dosage dosage;
  final bool isValid;
  final String? errorMessage;
  final Description description;
  final bool isLoading;

  const MedicationState({
    this.status = FormzSubmissionStatus.initial,
    this.medicationName = const MedicationName.pure(),
    this.genericName = const GenericName.pure(),
    this.isPediatric = false,
    this.dosage = const Dosage.pure(),
    this.isValid = false,
    this.errorMessage,
    this.description = const Description.pure(),
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
        status,
        medicationName,
        genericName,
        isPediatric,
        dosage,
        isValid,
        errorMessage,
      ];

  MedicationState copyWith({
    FormzSubmissionStatus? status,
    MedicationName? medicationName,
    GenericName? genericName,
    bool? isPediatric,
    Dosage? dosage,
    bool? isValid,
    String? errorMessage,
    Description? description,
    bool? isLoading,
  }) {
    return MedicationState(
      status: status ?? this.status,
      medicationName: medicationName ?? this.medicationName,
      genericName: genericName ?? this.genericName,
      isPediatric: isPediatric ?? this.isPediatric,
      dosage: dosage ?? this.dosage,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
