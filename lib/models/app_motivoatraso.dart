
// ignore: camel_case_types
class app_motivoatraso {
  final String idmotivoatraso;
  final String motivoatraso;
  final String abreviatura;

  app_motivoatraso({
    required this.idmotivoatraso,
    required this.motivoatraso,
    required this.abreviatura,
  });

  factory app_motivoatraso.fromJson(Map<String, dynamic> json) {
    return app_motivoatraso(
      idmotivoatraso: json["idmotivoatraso"],
      motivoatraso: json["motivoatraso"],
      abreviatura: json["abreviatura"],
    );
  }
}
