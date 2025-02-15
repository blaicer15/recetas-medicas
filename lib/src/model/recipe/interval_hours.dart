import 'package:formz/formz.dart';

class IntervaloHoras extends FormzInput<int, String> {
  const IntervaloHoras.dirty([super.value = 0]) : super.dirty();
  const IntervaloHoras.pure() : super.pure(0);

  @override
  String? validator(int value) {
    if (value <= 0) {
      return 'Debe ser mayor que 0';
    }
    return null;
  }
}
