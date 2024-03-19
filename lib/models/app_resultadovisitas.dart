// ignore: camel_case_types
class app_resultadovisitas  {
  final String idresultadovisita;
  final String resultadovisita;
  final String abreviatura;

  app_resultadovisitas({
    required this.idresultadovisita,
    required this.resultadovisita,
    required this.abreviatura,
  });

  factory app_resultadovisitas.fromJson(Map<String, dynamic> json) {
    return app_resultadovisitas(
      idresultadovisita: json["idresultadovisita"],
      resultadovisita: json["resultadovisita"],
      abreviatura: json["abreviatura"],
    );
  }
}
