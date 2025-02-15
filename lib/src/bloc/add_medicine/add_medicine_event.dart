part of 'add_medicine_bloc.dart';

sealed class AddMedicineEvent extends Equatable {
  const AddMedicineEvent();

  @override
  List<Object> get props => [];
}

final class SetGenericNameChanged extends AddMedicineEvent {
  final String nombreGenerico;

  const SetGenericNameChanged({required this.nombreGenerico});

  @override
  List<Object> get props => [nombreGenerico];
}

final class SetIsPediatric extends AddMedicineEvent {
  final bool isPediatric;

  const SetIsPediatric({required this.isPediatric});

  @override
  List<Object> get props => [isPediatric];
}

final class SetNombreChanged extends AddMedicineEvent {
  final String nombre;

  const SetNombreChanged({required this.nombre});

  @override
  List<Object> get props => [nombre];
}

final class SetSubmitted extends AddMedicineEvent {
  const SetSubmitted();
}
