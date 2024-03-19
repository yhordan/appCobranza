// ignore: camel_case_types
class app_ubigeo   {
  final String idubigeo;
  final String descripcion;
  final String nivel;
  final String ubigeo;
  final String nacionalidad;

  app_ubigeo({
    required this.idubigeo,
    required this.descripcion,
    required this.nivel,
    required this.ubigeo,
    required this.nacionalidad,
  });

  factory app_ubigeo.fromJson(Map<String, dynamic> json) {
    return app_ubigeo(
      idubigeo: json["idubigeo"],
      descripcion: json["descripcion"],
      nivel: json["nivel"],
      ubigeo: json["ubigeo"],
      nacionalidad: json["nacionalidad"],
    );
  }
}
