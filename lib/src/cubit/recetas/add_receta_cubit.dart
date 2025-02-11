import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_receta_state.dart';

class AddRecetaCubit extends Cubit<AddRecetaState> {
  final SupabaseClient supabase = Supabase.instance.client;

  AddRecetaCubit()
      : super(AddRecetaState(
            nombre: "",
            nombreGenerico: "",
            ml: 0,
            tratamientoDias: 1,
            startDate: DateTime.now().subtract(const Duration(days: 10)),
            endDate: DateTime.now(),
            interval: 24));

  changeApeMaterno(String value) => emit(state.copyWith(apeMaterno: value));

  changeApePaterno(String value) => emit(state.copyWith(apePaterno: value));

  changeInterval(int value) => emit(state.copyWith(interval: value));

  changeMl(double value) => emit(state.copyWith(ml: value));

  changeNombre(String value) => emit(state.copyWith(nombre: value));

  changeNombreGenerico(String value) =>
      emit(state.copyWith(nombreGenerico: value));

  changeStartDate(DateTime value) => emit(state.copyWith(
      startDate: value,
      endDate: _calculateEndDate(value, state.tratamientoDias)));

  changeTratamientoDias(int value) =>
      emit(state.copyWith(tratamientoDias: value));

  Future<bool> onSubmitted() async {
    try {
      await supabase.from("recetas").insert({
        "nombre": state.nombre,
        "nombreGenerico": state.nombreGenerico,
        "ml": state.ml,
        "startDate": state.startDate,
        "endDate": state.endDate,
        "interval": state.interval
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  DateTime _calculateEndDate(DateTime startDate, int days) {
    return startDate.add(Duration(days: days));
  }
}
