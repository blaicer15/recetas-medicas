import 'package:formz/formz.dart';

class IntervalInput extends FormzInput<String, IntervalValidationError> {
  const IntervalInput.dirty([super.value = '']) : super.dirty();
  const IntervalInput.pure() : super.pure('');

  @override
  IntervalValidationError? validator(String value) {
    if (value.isEmpty) return IntervalValidationError.empty;
    final hours = int.tryParse(value);
    if (hours == null || hours <= 0 || hours > 24) {
      return IntervalValidationError.invalid;
    }
    return null;
  }
}

enum IntervalValidationError { empty, invalid }
