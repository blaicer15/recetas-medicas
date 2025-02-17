part of 'recipe_cubit.dart';

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

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
  final bool savedSuccessfully;

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
    this.savedSuccessfully = false,
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
    bool? savedSuccessfully,
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
      savedSuccessfully: savedSuccessfully ?? this.savedSuccessfully,
    );
  }
}

class RecipeLoading extends RecipeState {}

abstract class RecipeState {}
