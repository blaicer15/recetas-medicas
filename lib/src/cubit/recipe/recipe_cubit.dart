import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final SupabaseClient supabase = Supabase.instance.client;

  RecipeCubit() : super(RecipeInitial()) {
    loadData();
  }

  void changeDoseInterval(int doseInterval) {
    emit((state as RecipeLoaded).copyWith(doseInterval: doseInterval));
    _calculateEndDateAndDoses();
  }

  void changeStartDate(DateTime startDate) {
    emit((state as RecipeLoaded).copyWith(startDate: startDate));
    _calculateEndDateAndDoses();
  }

  void changeTreatmentDays(int treatmentDays) {
    emit((state as RecipeLoaded).copyWith(treatmentDays: treatmentDays));
    _calculateEndDateAndDoses();
  }

  Future<void> loadData() async {
    emit(RecipeLoading());
    try {
      final users = await supabase.from('usuarios').select('id, nombre');
      final medicines =
          await supabase.from('medicines').select('id, nombre, generic_name');

      emit(RecipeLoaded(
        users: users,
        medicines: medicines,
        doses: [],
      ));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  void selectMedicine(String medicineId) {
    emit((state as RecipeLoaded).copyWith(selectedMedicineId: medicineId));
  }

  void selectUser(String userId) {
    emit((state as RecipeLoaded).copyWith(selectedUserId: userId));
  }

  void _calculateEndDateAndDoses() {
    if (state is! RecipeLoaded) return;
    final currentState = state as RecipeLoaded;
    if (currentState.startDate == null ||
        currentState.treatmentDays == null ||
        currentState.doseInterval == null) return;

    final endDate = currentState.startDate!
        .add(Duration(days: currentState.treatmentDays!));
    final doses = <DateTime>[];
    var currentDate = currentState.startDate!;

    while (currentDate.isBefore(endDate)) {
      doses.add(currentDate);
      currentDate =
          currentDate.add(Duration(hours: currentState.doseInterval!));
    }

    emit(currentState.copyWith(endDate: endDate, doses: doses));
  }
}
