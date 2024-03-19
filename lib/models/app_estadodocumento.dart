// ignore: camel_case_types
class app_estadodocumento    {
  final String idestadodoc;
  final String estado;
  final String abreviatura;

  app_estadodocumento ({
    required this.idestadodoc,
    required this.estado,
    required this.abreviatura,
  });

  factory app_estadodocumento.fromJson(Map<String, dynamic> json) {
    return app_estadodocumento(
      idestadodoc: json["idestadodoc"],
      estado: json["estado"],
      abreviatura: json["abreviatura"],
    );
  }
}
