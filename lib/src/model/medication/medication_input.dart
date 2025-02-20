import 'package:formz/formz.dart';

class MedicationInput extends FormzInput<String, MedicationValidationError> {
  const MedicationInput.dirty([super.value = '']) : super.dirty();
  const MedicationInput.pure() : super.pure('');

  @override
  MedicationValidationError? validator(String value) {
    return value.isEmpty ? MedicationValidationError.empty : null;
  }
}

enum MedicationValidationError { empty }
