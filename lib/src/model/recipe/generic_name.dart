import 'package:formz/formz.dart';

class NombreGenerico extends FormzInput<String, String> {
  const NombreGenerico.dirty([super.value = '']) : super.dirty();
  const NombreGenerico.pure() : super.pure('');

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }
}
