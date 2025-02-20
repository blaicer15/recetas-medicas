import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recetas/src/model/medication_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'medication_event.dart';
part 'medication_state.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final SupabaseClient supabase = Supabase.instance.client;

  MedicationBloc() : super(const MedicationState()) {
    on<MedicationNameChanged>(_onMedicationNameChanged);
    on<GenericNameChanged>(_onGenericNameChanged);
    on<IsPediatricChanged>(_onIsPediatricChanged);
    on<DosageChanged>(_onDosageChanged);
    on<MedicationSubmitted>(_onSubmitted);
    on<DescriptionChanged>(_onDescripcionChanged);
  }

// void _onSubmitted (event, emit) async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       // Tu lógica de guardado actual
//       emit(state.copyWith(
//         status: FormzSubmissionStatus.success,
//         isLoading: false,
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         status: FormzSubmissionStatus.failure,
//         errorMessage: e.toString(),
//         isLoading: false,
//       ));
//     }
//   }

  void _onDescripcionChanged(event, emit) {
    final description = Description.dirty(event.description);
    emit(state.copyWith(
      description: description,
      isValid: Formz.validate([
        state.medicationName,
        state.genericName,
        state.dosage,
        description,
      ]),
    ));
  }

  void _onDosageChanged(
    DosageChanged event,
    Emitter<MedicationState> emit,
  ) {
    final dosage = Dosage.dirty(event.dosage);
    emit(state.copyWith(
      dosage: dosage,
      isValid: Formz.validate([
        state.medicationName,
        state.genericName,
        dosage,
      ]),
    ));
  }

  void _onGenericNameChanged(
    GenericNameChanged event,
    Emitter<MedicationState> emit,
  ) {
    final genericName = GenericName.dirty(event.name);
    emit(state.copyWith(
      genericName: genericName,
      isValid: Formz.validate([
        state.medicationName,
        genericName,
        state.dosage,
      ]),
    ));
  }

  void _onIsPediatricChanged(
    IsPediatricChanged event,
    Emitter<MedicationState> emit,
  ) {
    emit(state.copyWith(isPediatric: event.isPediatric));
  }

  void _onMedicationNameChanged(
    MedicationNameChanged event,
    Emitter<MedicationState> emit,
  ) {
    final medicationName = MedicationName.dirty(event.name);
    emit(state.copyWith(
      medicationName: medicationName,
      isValid: Formz.validate([
        medicationName,
        state.genericName,
        state.dosage,
      ]),
    ));
  }

  Future<void> _onSubmitted(
    MedicationSubmitted event,
    Emitter<MedicationState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await supabase.from("medicine").insert({
        "nombre": state.medicationName.value,
        "generic_name": state.genericName.value,
        "pediatrico": state.isPediatric
      });
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
