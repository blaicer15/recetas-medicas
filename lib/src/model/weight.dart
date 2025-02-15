import 'package:formz/formz.dart';

class Weight extends FormzInput<double?, WeightError> {
  const Weight.dirty([super.value]) : super.dirty();
  const Weight.pure() : super.pure(null);

  @override
  WeightError? validator(double? value) {
    if (value == null) {
      return null; // Permitir valores nulos
    }
    if (value == 0) {
      return WeightError.zero;
    }
    return null;
  }
}

enum WeightError { empty, zero }
