import 'package:formz/formz.dart';

class Nombre extends FormzInput<String, String> {
  const Nombre.dirty([super.value = '']) : super.dirty();
  const Nombre.pure() : super.pure('');

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }
}
