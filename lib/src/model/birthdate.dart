import 'package:formz/formz.dart';

class Birthday extends FormzInput<DateTime?, BirthdayError> {
  const Birthday.dirty([super.value]) : super.dirty();
  const Birthday.pure() : super.pure(null);

  @override
  BirthdayError? validator(DateTime? value) {
    if (value == null) {
      return BirthdayError.empty;
    }
    // Validar que la fecha no sea en el futuro
    if (value.isAfter(DateTime.now())) {
      return BirthdayError.invalid;
    }
    return null;
  }
}

// Definir el campo de entrada del cumpleaños
enum BirthdayError { empty, invalid }

extension BirthdayInputErrorExtension on BirthdayError {
  String get message {
    switch (this) {
      case BirthdayError.empty:
        return 'Debes ingresar tu fecha de cumpleaños';
      case BirthdayError.invalid:
        return 'La fecha de cumpleaños no puede ser en el futuro';
      default:
        return ''; // Manejar otros casos si es necesario
    }
  }
}
