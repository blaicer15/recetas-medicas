part of 'recipe_cubit.dart';

class DoseIntervalChanged extends RecipeEvent {
  final int doseInterval;
  DoseIntervalChanged(this.doseInterval);
}

class LoadMedicines extends RecipeEvent {}

class LoadUsers extends RecipeEvent {}

class MedicineSelected extends RecipeEvent {
  final int medicineId;
  MedicineSelected(this.medicineId);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

abstract class RecipeEvent {}

class RecipeInitial extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> medicines;
  final String? selectedUserId;
  final String? selectedMedicineId;
  final DateTime? startDate;
  final int? treatmentDays;
  final int? doseInterval;
  final DateTime? endDate;
  final List<DateTime> doses;

  RecipeLoaded({
    required this.users,
    required this.medicines,
    this.selectedUserId,
    this.selectedMedicineId,
    this.startDate,
    this.treatmentDays,
    this.doseInterval,
    this.endDate,
    required this.doses,
  });

  RecipeLoaded copyWith({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? medicines,
    String? selectedUserId,
    String? selectedMedicineId,
    DateTime? startDate,
    int? treatmentDays,
    int? doseInterval,
    DateTime? endDate,
    List<DateTime>? doses,
  }) {
    return RecipeLoaded(
      users: users ?? this.users,
      medicines: medicines ?? this.medicines,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      selectedMedicineId: selectedMedicineId ?? this.selectedMedicineId,
      startDate: startDate ?? this.startDate,
      treatmentDays: treatmentDays ?? this.treatmentDays,
      doseInterval: doseInterval ?? this.doseInterval,
      endDate: endDate ?? this.endDate,
      doses: doses ?? this.doses,
    );
  }
}

class RecipeLoading extends RecipeState {}

// Definición de estados
abstract class RecipeState {}

class StartDateChanged extends RecipeEvent {
  final DateTime startDate;
  StartDateChanged(this.startDate);
}

class TreatmentDaysChanged extends RecipeEvent {
  final int treatmentDays;
  TreatmentDaysChanged(this.treatmentDays);
}

class UserSelected extends RecipeEvent {
  final int userId;
  UserSelected(this.userId);
}
