import 'package:formz/formz.dart';

class CantidadMl extends FormzInput<double, String> {
  const CantidadMl.dirty([super.value = 0.0]) : super.dirty();
  const CantidadMl.pure() : super.pure(0.0);

  @override
  String? validator(double value) {
    if (value <= 0) {
      return 'Debe ser mayor que 0';
    }
    return null;
  }
}
