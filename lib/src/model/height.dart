import 'package:formz/formz.dart';

class Height extends FormzInput<double?, HeightError> {
  const Height.dirty([super.value]) : super.dirty();
  const Height.pure() : super.pure(null);

  @override
  HeightError? validator(double? value) {
    if (value == null) {
      return null; // Permitir valores nulos
    }
    if (value == 0) {
      return HeightError.zero;
    }
    return null;
  }
}

enum HeightError { empty, zero }
