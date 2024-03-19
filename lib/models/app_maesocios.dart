import 'package:app_leon_xiii/models/app_agencias.dart';

// ignore: camel_case_types
class app_maesocios {
  final String idmaesocios;
  final String idsocio;
  final String socio;
  final app_agencias idagencia;
  final String idpersona;
  final String nrodocumento;
  final String tipodocumento;
  final String idubigeodir;
  final String? direccion;
  final String? referencia;
  final String? celular1;
  final String? celular2;
  final String? calificacion;

  app_maesocios({
    required this.idmaesocios,
    required this.idsocio,
    required this.socio,
    required this.idagencia,
    required this.idpersona,
    required this.nrodocumento,
    required this.tipodocumento,
    required this.idubigeodir,
     this.direccion,
     this.referencia,
     this.celular1,
     this.celular2,
     this.calificacion,
  });

  factory app_maesocios.fromJson(Map<String, dynamic> json) {
    return app_maesocios(
      idmaesocios: json["idmaesocios"],
      idsocio: json["idsocio"],
      socio: json["socio"],
      idagencia: app_agencias.fromJson(json["idagencia"] as Map<String, dynamic>),
      idpersona: json["idpersona"],
      nrodocumento: json["nrodocumento"],
      tipodocumento: json["tipodocumento"],
      idubigeodir: json["idubigeodir"],
      direccion: json["direccion"],
      referencia: json["referencia"],
      celular1: json["celular1"],
      celular2: json["celular2"],
      calificacion: json["calificacion"],
    );
  }
}
