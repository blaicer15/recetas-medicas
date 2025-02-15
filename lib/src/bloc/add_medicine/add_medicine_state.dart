part of 'add_medicine_bloc.dart';

final class AddMedicineInitial extends AddMedicineState {
  const AddMedicineInitial(
      {super.nombreGenerico = const NombreGenerico.pure(),
      super.isPediatric = false,
      super.nombre = const Nombre.pure(),
      super.status = FormzSubmissionStatus.initial,
      super.isValid = false});
}

sealed class AddMedicineState extends Equatable {
  final Nombre nombre;
  final NombreGenerico nombreGenerico;
  final bool isPediatric;
  final FormzSubmissionStatus status;
  final bool isValid;

  const AddMedicineState(
      {required this.nombre,
      required this.nombreGenerico,
      required this.isPediatric,
      required this.isValid,
      required this.status});

  @override
  List<Object> get props => [
        isPediatric,
        nombre,
        nombreGenerico,
      ];

  AddMedicineState copyWith(
      {FormzSubmissionStatus? status,
      Nombre? nombre,
      NombreGenerico? nombreGenerico,
      bool? isValid,
      bool? isPediatric}) {
    return AddMedicineInitial(
        isPediatric: isPediatric ?? this.isPediatric,
        nombre: nombre ?? this.nombre,
        nombreGenerico: nombreGenerico ?? this.nombreGenerico,
        isValid: isValid ?? this.isValid,
        status: status ?? this.status);
  }
}
