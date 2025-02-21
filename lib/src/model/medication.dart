class Medication {
  final String id;
  final String nombre;
  final String nombreGenerico;
  final bool esPediatrico;
  final double miligramos;
  final int unidades;

  Medication({
    required this.id,
    required this.nombre,
    required this.nombreGenerico,
    required this.esPediatrico,
    required this.miligramos,
    required this.unidades,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'].toString(),
      nombre: json['nombre'],
      nombreGenerico: json['nombre_generico'] ?? '',
      esPediatrico: json['es_pediatrico'] ?? false,
      miligramos: json['miligramos']?.toDouble() ?? 0.0,
      unidades: json['unidades'] ?? 0,
    );
  }
}
