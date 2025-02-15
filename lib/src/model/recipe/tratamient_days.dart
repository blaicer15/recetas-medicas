import 'package:formz/formz.dart';

class TratamientoDias extends FormzInput<int, String> {
  const TratamientoDias.dirty([super.value = 0]) : super.dirty();
  const TratamientoDias.pure() : super.pure(0);

  @override
  String? validator(int value) {
    if (value <= 0) {
      return 'Debe ser mayor que 0';
    }
    return null;
  }
}
