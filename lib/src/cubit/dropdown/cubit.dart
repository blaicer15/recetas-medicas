import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

// Definir el Cubit
class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(const DropdownState());

  void updateDropdown(int? id, String? name) {
    if (id != null && name != null) {
      emit(state.copyWith(
        selectedId: id,
        selectedName: name,
        status: DropdownStatus.valid,
      ));
    } else {
      emit(state.copyWith(
        status: DropdownStatus.invalid,
      ));
    }
  }
}
