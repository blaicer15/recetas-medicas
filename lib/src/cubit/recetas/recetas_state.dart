part of 'recetas_cubit.dart';

final class RecetasState {
  final List<Map<String, String>> recetas;

  const RecetasState({required this.recetas});

  RecetasState copyWith({List<Map<String, String>>? recetas}) {
    return RecetasState(recetas: recetas ?? this.recetas);
  }
}
