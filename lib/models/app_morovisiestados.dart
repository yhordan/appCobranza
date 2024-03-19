
// ignore: camel_case_types
class app_morovisiestados {
  final String idmorovisiestados;
  final String morovisiestados;
  final String abreviatura;

  app_morovisiestados({
    required this.idmorovisiestados,
    required this.morovisiestados,
    required this.abreviatura,
  });

  factory app_morovisiestados.fromJson(Map<String, dynamic> json) {
    return app_morovisiestados(
      idmorovisiestados: json["idmorovisiestados"],
      morovisiestados: json["morovisiestados"],
      abreviatura: json["abreviatura"],
    );
  }
}
