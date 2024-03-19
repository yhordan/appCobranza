import 'package:app_leon_xiii/models/app_agencias.dart';

// ignore: camel_case_types
class App_morosos {
  final String idmoroso;
  final String nromoroso;
  final String iddocp;
  final String nrodocp;
  final app_agencias idagenciap;
  final String tipomonedap;
  final String? idanalista;
  final String? idestcuomor;
  final String? idpersona;
  final String? nrocuota;
  final double? montoaprobado;
  final double? saldo;
  final double? amortizacion;
  final String? tasainteres;
  final int? totalcuotas;
  final int? cpagadas;
  final int ? cpendientes;
  final int? cvencidas;
  final int? capagar;
  final String fechapagar;
  final int? diasatrazo;
  final int? diasmorosidad;
  final String? fechadesembolso;
  final String? fechaultpagointeres;
  final double? montoalafecha;
  final String? estadoprestamo;
  final String? fechar;
  final String? iduserr;
  final String? socio;
  final String? idsocio;
  final String? userasignado;
  final String? gestorasignado;

  App_morosos({
    required this.idmoroso,
  required this.nromoroso,
  required this.iddocp,
  required this.nrodocp,
  required this.idagenciap,
  required this.tipomonedap,
  required this.idanalista,
  required this.idestcuomor,
  required this.idpersona,
  required this.nrocuota,
  required this.montoaprobado,
  required this.saldo,
  required this.amortizacion,
  required this.tasainteres,
  required this.totalcuotas,
  required this.cpagadas,
  required this.cpendientes,
  required this.cvencidas,
  required this.capagar,
  required this.fechapagar,
  required this.diasatrazo,
  required this.diasmorosidad,
  required this.fechadesembolso,
  required this.fechaultpagointeres,
  required this.montoalafecha,
  required this.estadoprestamo,
  required this.fechar,
  required this.iduserr,
  required this.socio,
  required this.idsocio,
  required this.userasignado,
  required this.gestorasignado,
  });

  factory App_morosos.fromJson(Map<String, dynamic> json) {
    return App_morosos(
      idmoroso: json["idmoroso"],
      nromoroso: json["nromoroso"],
      iddocp: json["iddocp"],
      nrodocp: json["nrodocp"],
      idagenciap: app_agencias.fromJson(json["idagenciap"] as Map<String, dynamic>),
      tipomonedap: json["tipomonedap"],
      idanalista: json["idanalista"],
      idestcuomor: json["idestcuomor"],
      idpersona: json["idpersona"],
      nrocuota: json["nrocuota"],
      montoaprobado: json["montoaprobado"],
      saldo: json["saldo"],
      amortizacion: json["amortizacion"],
      tasainteres: json["tasainteres"],
      totalcuotas: json["totalcuotas"],
      cpagadas: json["cpagadas"],
      cpendientes: json["cpendientes"],
      cvencidas: json["cvencidas"],
      capagar: json["capagar"],
      fechapagar: json["fechapagar"],
      diasatrazo: json["diasatrazo"],
      diasmorosidad: json["diasmorosidad"],
      fechadesembolso: json["fechadesembolso"],
      fechaultpagointeres: json["fechaultpagointeres"],
      montoalafecha: json["montoalafecha"],
      estadoprestamo: json["estadoprestamo"],
      fechar: json["fechar"],
      iduserr: json["iduserr"],
      socio: json["socio"],
      idsocio: json["idsocio"],
      userasignado: json["userasignado"],
      gestorasignado: json["gestorasignado"],
    );
  }
}
