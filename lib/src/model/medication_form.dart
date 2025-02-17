import 'package:formz/formz.dart';

class Description extends FormzInput<String, DescriptionError> {
  const Description.dirty([super.value = '']) : super.dirty();
  const Description.pure() : super.pure('');

  @override
  DescriptionError? validator(String value) {
    if (value.length > 500) return DescriptionError.invalid;
    return null;
  }
}

enum DescriptionError { invalid }

class Dosage extends FormzInput<double?, DosageError> {
  const Dosage.dirty([super.value]) : super.dirty();
  const Dosage.pure() : super.pure(null);

  @override
  DosageError? validator(double? value) {
    if (value != null && value <= 0) return DosageError.invalid;
    return null;
  }
}

enum DosageError { invalid }

class GenericName extends FormzInput<String, GenericNameError> {
  const GenericName.dirty([super.value = '']) : super.dirty();
  const GenericName.pure() : super.pure('');

  @override
  GenericNameError? validator(String value) {
    if (value.isNotEmpty && value.length < 2) return GenericNameError.invalid;
    return null;
  }
}

enum GenericNameError { invalid }

class MedicationName extends FormzInput<String, MedicationNameError> {
  const MedicationName.dirty([super.value = '']) : super.dirty();
  const MedicationName.pure() : super.pure('');

  @override
  MedicationNameError? validator(String value) {
    if (value.isEmpty) return MedicationNameError.empty;
    if (value.length < 2) return MedicationNameError.invalid;
    return null;
  }
}

enum MedicationNameError { empty, invalid }
