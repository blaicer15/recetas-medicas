import 'package:formz/formz.dart';

class Surname extends FormzInput<String, String> {
  const Surname.dirty([super.value = '']) : super.dirty();
  const Surname.pure() : super.pure('');

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }
}
