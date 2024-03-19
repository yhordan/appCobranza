import 'package:app_leon_xiii/models/app_agencias.dart';

// ignore: camel_case_types
class app_cuotas_convenio  {
  final String idcuotasconvenio;
  final String idpersona;
  final String iddocp;
  final String nrodocp;
  final String tipmonedap; 
  final app_agencias idagenciap;
  final String iddocconv;
  final String nrodocconv;
  final String tipmonedaconv;
  final app_agencias idagenciaconv;
  final String nrocuota;
  final String fecven;
  final String estcuota;
  final int diasatraso;
  final double amortiza;
  final double interes;
  final double desgravamen;
  final double intmoratorio;
  final double intvencido;
  final double interesmoraconv;
  final double interesvencconv;
  final double gastos;

  app_cuotas_convenio({
    required this.idcuotasconvenio,
    required this.idpersona,
    required this.iddocp,
    required this.nrodocp,
    required this.tipmonedap,
    required this.idagenciap,
    required this.nrocuota,
    required this.fecven,
    required this.estcuota,
    required this.diasatraso,
    required this.amortiza,
    required this.interes,
    required this.desgravamen,
    required this.gastos,
    required this.idagenciaconv,
    required this.iddocconv,
    required this.interesmoraconv,
    required this.interesvencconv,
    required this.intmoratorio,
    required this.intvencido,
    required this.nrodocconv,
    required this.tipmonedaconv,
  });

  factory app_cuotas_convenio.fromJson(Map<String, dynamic> json) {
    return app_cuotas_convenio(
      idcuotasconvenio: json["idcuotasconvenio"],
      idpersona: json["idpersona"],
      iddocp: json["iddocp"],
      nrodocp: json["nrodocp"],
      tipmonedap: json["tipmonedap"],
      idagenciap: app_agencias.fromJson(json["idagenciap"] as Map<String, dynamic>),
      nrocuota: json["nrocuota"],
      fecven: json["fecven"],
      estcuota: json["estcuota"],
      diasatraso: json["diasatraso"],
      amortiza: json["amortiza"],
      interes: json["interes"],
      desgravamen: json["desgravamen"],
      gastos: json["gastos"],
      idagenciaconv: app_agencias.fromJson(json["idagenciap"] as Map<String, dynamic>),
      iddocconv: json["iddocconv"],
      interesmoraconv: json["interesmoraconv"],
      interesvencconv: json["interesvencconv"],
      intmoratorio: json["intmoratorio"],
      intvencido: json["intvencido"],
      nrodocconv: json["nrodocconv"],
      tipmonedaconv: json["tipmonedaconv"],
    );
  }
}
