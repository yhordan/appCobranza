
// ignore: camel_case_types
class app_analista_gestorcob {
  final String idgestor;
  final String idanalista;
  final String activo;

  app_analista_gestorcob({
    required this.idgestor,
    required this.idanalista,
    required this.activo,
  });

  factory app_analista_gestorcob.fromJson(Map<String, dynamic> json) {
    return app_analista_gestorcob(
      idgestor: json["idgestor"],
      idanalista: json["idanalista"],
      activo: json["activo"],
    );
  }
}
