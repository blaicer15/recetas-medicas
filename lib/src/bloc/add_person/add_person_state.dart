part of 'add_person_bloc.dart';

class AddPersonState extends Equatable {
  final FormzSubmissionStatus status;
  final bool isValid;
  final Nombre nombre;
  final Surname firstSurname;
  final Surname secondSurname;
  final Birthday birthdate;
  final Height height;
  final Weight weight;
  final String? errorMessage;

  const AddPersonState({
    required this.status,
    required this.isValid,
    required this.nombre,
    required this.firstSurname,
    required this.secondSurname,
    required this.birthdate,
    required this.height,
    required this.weight,
    this.errorMessage,
  });

  const AddPersonState.initial()
      : this(
          status: FormzSubmissionStatus.initial,
          isValid: false,
          nombre: const Nombre.pure(),
          firstSurname: const Surname.pure(),
          secondSurname: const Surname.pure(),
          birthdate: const Birthday.pure(),
          height: const Height.pure(),
          weight: const Weight.pure(),
        );

  @override
  List<Object?> get props => [
        status,
        isValid,
        nombre,
        firstSurname,
        secondSurname,
        birthdate,
        height,
        weight,
        errorMessage,
      ];

  AddPersonState copyWith({
    FormzSubmissionStatus? status,
    bool? isValid,
    Nombre? nombre,
    Surname? firstSurname,
    Surname? secondSurname,
    Birthday? birthdate,
    Height? height,
    Weight? weight,
    String? errorMessage,
  }) {
    return AddPersonState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      nombre: nombre ?? this.nombre,
      firstSurname: firstSurname ?? this.firstSurname,
      secondSurname: secondSurname ?? this.secondSurname,
      birthdate: birthdate ?? this.birthdate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
