import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:recetas/src/model/birthdate.dart';
import 'package:recetas/src/model/height.dart';
import 'package:recetas/src/model/name.dart';
import 'package:recetas/src/model/surname.dart';
import 'package:recetas/src/model/weight.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_person_event.dart';
part 'add_person_state.dart';

class AddPersonBloc extends Bloc<AddPersonEvent, AddPersonState> {
  final Logger _log = Logger();
  final SupabaseClient _supabase = Supabase.instance.client;

  AddPersonBloc() : super(const AddPersonState.initial()) {
    on<AddPersonNameChanged>(_onNameChanged);
    on<AddPersonFirstSurnameChanged>(_onFirstSurnameChanged);
    on<AddPersonSecondSurnameChanged>(_onSecondSurnameChanged);
    on<AddPersonBirthdateChanged>(_onBirthdateChanged);
    on<AddPersonHeightChanged>(_onHeightChanged);
    on<AddPersonWeightChanged>(_onWeightChanged);
    on<AddPersonSubmitted>(_onSubmitted);
  }

  Future<void> _guardarPersona() async {
    await _supabase.from("personas").insert({
      "nombre": state.nombre.value,
      "apellido_paterno": state.firstSurname.value,
      "apellido_materno": state.secondSurname.value,
      "fecha_nacimiento": state.birthdate.value?.toIso8601String(),
      "estatura": state.height.value,
      "peso": state.weight.value,
    });
  }

  void _onBirthdateChanged(
      AddPersonBirthdateChanged event, Emitter<AddPersonState> emit) {
    _log.d('Birthdate changed: ${event.birthdate}');
    final birthdate = Birthday.dirty(event.birthdate);
    emit(state.copyWith(
      birthdate: birthdate,
      isValid: _validateForm(birthdate: birthdate),
    ));
  }

  void _onFirstSurnameChanged(
      AddPersonFirstSurnameChanged event, Emitter<AddPersonState> emit) {
    final firstSurname = Surname.dirty(event.firstSurname);
    emit(state.copyWith(
      firstSurname: firstSurname,
      isValid: _validateForm(firstSurname: firstSurname),
    ));
  }

  void _onHeightChanged(
      AddPersonHeightChanged event, Emitter<AddPersonState> emit) {
    final height = Height.dirty(event.height);
    emit(state.copyWith(
      height: height,
      isValid: _validateForm(height: height),
    ));
  }

  void _onNameChanged(
      AddPersonNameChanged event, Emitter<AddPersonState> emit) {
    final name = Nombre.dirty(event.name);
    emit(state.copyWith(
      nombre: name,
      isValid: _validateForm(nombre: name),
    ));
  }

  void _onSecondSurnameChanged(
      AddPersonSecondSurnameChanged event, Emitter<AddPersonState> emit) {
    final secondSurname = Surname.dirty(event.secondSurname);
    emit(state.copyWith(
      secondSurname: secondSurname,
      isValid: _validateForm(secondSurname: secondSurname),
    ));
  }

  Future<void> _onSubmitted(
      AddPersonSubmitted event, Emitter<AddPersonState> emit) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _guardarPersona();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      _log.e('Error saving person: $e');
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onWeightChanged(
      AddPersonWeightChanged event, Emitter<AddPersonState> emit) {
    final weight = Weight.dirty(event.weight);
    emit(state.copyWith(
      weight: weight,
      isValid: _validateForm(weight: weight),
    ));
  }

  bool _validateForm({
    Nombre? nombre,
    Surname? firstSurname,
    Surname? secondSurname,
    Birthday? birthdate,
    Height? height,
    Weight? weight,
  }) {
    return Formz.validate([
      nombre ?? state.nombre,
      firstSurname ?? state.firstSurname,
      secondSurname ?? state.secondSurname,
      birthdate ?? state.birthdate,
      height ?? state.height,
      weight ?? state.weight,
    ]);
  }
}
