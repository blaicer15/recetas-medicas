import 'package:formz/formz.dart';

class DropdownInput extends FormzInput<int?, DropdownInputError> {
  const DropdownInput.dirty([super.value]) : super.dirty();
  const DropdownInput.pure() : super.pure(null);

  @override
  DropdownInputError? validator(int? value) {
    return value == null ? DropdownInputError.empty : null;
  }
}

// Definir el campo de entrada del dropdown
enum DropdownInputError { empty }
