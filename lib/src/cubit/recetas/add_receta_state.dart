part of 'add_receta_cubit.dart';

final class AddRecetaState {
  //Nombre del medicamento
  final String nombre;
  //Nombre del medicamento generico, en caso de tenerlo
  final String nombreGenerico;
  final double ml;
  // Fecha y hora de inicio
  final DateTime startDate;
  //Fecha y hora de finalizacion calculada en base a fecha y hora de inicio
  final DateTime endDate;
  //Tiempo estimado en horas
  final int interval;
  final int tratamientoDias;

  const AddRecetaState({
    required this.nombre,
    required this.nombreGenerico,
    required this.ml,
    required this.startDate,
    required this.endDate,
    required this.interval,
    required this.tratamientoDias,
  });

  AddRecetaState copyWith(
      {String? nombre,
      String? nombreGenerico,
      String? apeMaterno,
      String? apePaterno,
      double? ml,
      DateTime? startDate,
      DateTime? endDate,
      int? interval,
      int? tratamientoDias}) {
    return AddRecetaState(
        nombre: nombre ?? this.nombre,
        nombreGenerico: nombreGenerico ?? this.nombreGenerico,
        ml: ml ?? this.ml,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        interval: interval ?? this.interval,
        tratamientoDias: tratamientoDias ?? this.tratamientoDias);
  }
}
