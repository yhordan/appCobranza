// ignore: camel_case_types
class app_agencias {
  final String idagencia;
  final String agencia;
  final String abrev;
  final String direccion;

  app_agencias({
    required this.idagencia,
    required this.agencia,
    required this.abrev,
    required this.direccion,
  });

  factory app_agencias.fromJson(Map<String, dynamic> json) {
    return app_agencias(
      idagencia: json["idagencia"],
      agencia: json["agencia"],
      abrev: json["abrev"],
      direccion: json["direccion"],
    );
  }
}
