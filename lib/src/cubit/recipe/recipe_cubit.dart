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

  void changeDoseInterval(int doseInterval) {
    if (state is! RecipeLoaded) return;
    emit((state as RecipeLoaded).copyWith(doseInterval: doseInterval));
    _calculateEndDateAndDoses();
  }

  void changeStartDate(DateTime startDate) {
    if (state is! RecipeLoaded) return;
    emit((state as RecipeLoaded).copyWith(startDate: startDate));
    _calculateEndDateAndDoses();
  }

  void changeTreatmentDays(int treatmentDays) {
    if (state is! RecipeLoaded) return;
    emit((state as RecipeLoaded).copyWith(treatmentDays: treatmentDays));
    _calculateEndDateAndDoses();
  }

  Future<void> loadData() async {
    emit(RecipeLoading());
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final users = await supabase
            .from('personas')
            .select('id, nombre')
            .eq("response_of", user.id);

        final medicines =
            await supabase.from('medicines').select('id, nombre, generic_name');

        emit(RecipeLoaded(
          users: users,
          medicines: medicines,
          doses: [],
        ));
      }
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
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

      final recipe = {
        'user_id': currentState.selectedUserId,
        'medicine_id': currentState.selectedMedicineId,
        'start_date': currentState.startDate!.toIso8601String(),
        'end_date': currentState.endDate!.toIso8601String(),
        'treatment_days': currentState.treatmentDays,
        'dose_interval': currentState.doseInterval,
      };

      await supabase.from('recipes').insert(recipe);

      // Insert doses
      final doses = currentState.doses
          .map((date) => {
                'recipe_id': recipe['id'],
                'scheduled_date': date.toIso8601String(),
                'status': 'pending'
              })
          .toList();

      await supabase.from('doses').insert(doses);

      emit(currentState.copyWith(savedSuccessfully: true));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  void selectMedicine(String medicineId) {
    if (state is! RecipeLoaded) return;
    emit((state as RecipeLoaded).copyWith(selectedMedicineId: medicineId));
  }

  void selectUser(String userId) {
    if (state is! RecipeLoaded) return;
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

  bool _validateRecipe(RecipeLoaded state) {
    return state.selectedUserId != null &&
        state.selectedMedicineId != null &&
        state.startDate != null &&
        state.treatmentDays != null &&
        state.doseInterval != null &&
        state.endDate != null &&
        state.doses.isNotEmpty;
  }
}
