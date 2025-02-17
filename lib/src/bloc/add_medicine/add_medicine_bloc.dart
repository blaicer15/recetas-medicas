import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:recetas/src/model/name.dart';
import 'package:recetas/src/model/recipe/generic_name.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_medicine_event.dart';
part 'add_medicine_state.dart';

class AddMedicineBloc extends Bloc<AddMedicineEvent, AddMedicineState> {
  final Logger log = Logger();

  final SupabaseClient supabase = Supabase.instance.client;

  AddMedicineBloc() : super(const AddMedicineInitial()) {
    on<SetNombreChanged>(_onNombreChanged);
    on<SetIsPediatric>(_onIsPediatric);
    on<SetGenericNameChanged>(_onNombreGeneric);
    on<SetSubmitted>(_onSubmitted);
  }

  void _onIsPediatric(SetIsPediatric event, Emitter<AddMedicineState> emit) {
    emit(state.copyWith(isPediatric: event.isPediatric));
  }

  void _onNombreChanged(
      SetNombreChanged event, Emitter<AddMedicineState> emit) {
    final nombre = Nombre.dirty(event.nombre);
    emit(state.copyWith(
        nombre: nombre,
        isValid: Formz.validate(state.nombreGenerico.value.isEmpty
            ? [nombre]
            : [nombre, state.nombreGenerico])));
  }

  void _onNombreGeneric(
      SetGenericNameChanged event, Emitter<AddMedicineState> emit) {
    final nombreGenerico = NombreGenerico.dirty(event.nombreGenerico);
    emit(state.copyWith(
        nombreGenerico: nombreGenerico,
        isValid: Formz.validate([nombreGenerico, state.nombre])));
  }

  Future<void> _onSubmitted(
      SetSubmitted event, Emitter<AddMedicineState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await supabase.from("medicines").insert({
          "nombre": state.nombre.value,
          "generic_name": state.nombreGenerico.value,
          "pediatrico": state.isPediatric
        });
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        log.d(e);
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
