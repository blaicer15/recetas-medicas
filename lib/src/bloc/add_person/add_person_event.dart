part of 'add_person_bloc.dart';

final class AddPersonBirthdateChanged extends AddPersonEvent {
  final DateTime? birthdate;

  const AddPersonBirthdateChanged(this.birthdate);

  @override
  List<Object?> get props => [birthdate];
}

sealed class AddPersonEvent extends Equatable {
  const AddPersonEvent();

  @override
  List<Object?> get props => [];
}

final class AddPersonFirstSurnameChanged extends AddPersonEvent {
  final String firstSurname;

  const AddPersonFirstSurnameChanged(this.firstSurname);

  @override
  List<Object> get props => [firstSurname];
}

final class AddPersonHeightChanged extends AddPersonEvent {
  final double? height;

  const AddPersonHeightChanged(this.height);

  @override
  List<Object?> get props => [height];
}

final class AddPersonNameChanged extends AddPersonEvent {
  final String name;

  const AddPersonNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

final class AddPersonSecondSurnameChanged extends AddPersonEvent {
  final String secondSurname;

  const AddPersonSecondSurnameChanged(this.secondSurname);

  @override
  List<Object> get props => [secondSurname];
}

final class AddPersonSubmitted extends AddPersonEvent {
  const AddPersonSubmitted();
}

final class AddPersonWeightChanged extends AddPersonEvent {
  final double? weight;

  const AddPersonWeightChanged(this.weight);

  @override
  List<Object?> get props => [weight];
}
