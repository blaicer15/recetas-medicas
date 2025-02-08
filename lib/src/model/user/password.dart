import 'package:formz/formz.dart';

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.dirty([super.value = '']) : super.dirty();
  const Password.pure() : super.pure('');

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    return null;
  }
}

enum PasswordValidationError { empty }
