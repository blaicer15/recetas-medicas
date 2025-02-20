import 'package:formz/formz.dart';

class DurationInput extends FormzInput<String, DurationValidationError> {
  const DurationInput.dirty([super.value = '']) : super.dirty();
  const DurationInput.pure() : super.pure('');

  @override
  DurationValidationError? validator(String value) {
    if (value.isEmpty) return DurationValidationError.empty;
    final days = int.tryParse(value);
    if (days == null || days <= 0) {
      return DurationValidationError.invalid;
    }
    return null;
  }
}

enum DurationValidationError { empty, invalid }
