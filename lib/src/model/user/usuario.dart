import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  static const empty = Usuario(
      id: '',
      nombre: '',
      apePaterno: '',
      apeMaterno: '',
      edad: '',
      peso: '',
      estatura: '');

  final String id;
  final String nombre;
  final String apePaterno;
  final String apeMaterno;
  final String edad;
  final String peso;
  final String estatura;

  const Usuario(
      {required this.id,
      required this.nombre,
      required this.apePaterno,
      required this.apeMaterno,
      required this.edad,
      required this.peso,
      required this.estatura});

  @override
  List<Object> get props =>
      [id, nombre, apePaterno, apeMaterno, edad, peso, estatura];
}
