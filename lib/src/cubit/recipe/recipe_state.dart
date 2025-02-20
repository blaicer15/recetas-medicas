part of 'recipe_cubit.dart';

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

class RecipeInitial extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Map<String, dynamic>> patients;
  final List<Map<String, dynamic>> medicines;
  final String? selectedPatientId;
  final List<Map<String, dynamic>> prescriptionMedicines;
  final String? notes;
  final bool savedSuccessfully;

  RecipeLoaded({
    required this.patients,
    required this.medicines,
    this.selectedPatientId,
    required this.prescriptionMedicines,
    this.notes,
    this.savedSuccessfully = false,
  });

  RecipeLoaded copyWith({
    List<Map<String, dynamic>>? patients,
    List<Map<String, dynamic>>? medicines,
    String? selectedPatientId,
    List<Map<String, dynamic>>? prescriptionMedicines,
    String? notes,
    bool? savedSuccessfully,
  }) {
    return RecipeLoaded(
      patients: patients ?? this.patients,
      medicines: medicines ?? this.medicines,
      selectedPatientId: selectedPatientId ?? this.selectedPatientId,
      prescriptionMedicines:
          prescriptionMedicines ?? this.prescriptionMedicines,
      notes: notes ?? this.notes,
      savedSuccessfully: savedSuccessfully ?? this.savedSuccessfully,
    );
  }
}

class RecipeLoading extends RecipeState {}

abstract class RecipeState {}
