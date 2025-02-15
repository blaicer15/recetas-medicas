part of 'cubit.dart';

class DropdownState extends Equatable {
  final int? selectedId;
  final String? selectedName;
  final DropdownStatus status;

  const DropdownState({
    this.selectedId,
    this.selectedName,
    this.status = DropdownStatus.initial,
  });

  @override
  List<Object?> get props => [selectedId, selectedName, status];

  DropdownState copyWith({
    int? selectedId,
    String? selectedName,
    DropdownStatus? status,
  }) {
    return DropdownState(
      selectedId: selectedId ?? this.selectedId,
      selectedName: selectedName ?? this.selectedName,
      status: status ?? this.status,
    );
  }
}

// Definir el estado del Cubit
enum DropdownStatus { initial, valid, invalid }
