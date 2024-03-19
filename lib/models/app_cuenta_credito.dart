import 'package:app_leon_xiii/models/app_detalle_cuenta_credito.dart';
import 'package:app_leon_xiii/models/app_estadodocumento.dart';
import 'package:app_leon_xiii/models/app_maesocios.dart';

// ignore: camel_case_types
class App_cuenta_credito {
  final String idcuentacredito;
  final String idpersona;
  final app_maesocios idmaesocios;
  final String idagenciacta;
  final String tipomonedacta;
  final String idtipocuenta;
  // ignore: non_constant_identifier_names
  final String? num_cuenta;
  final String? iddocpagare;
  final String? nrodocpagare;
  final String? tipomoneda;
  final String? idagenciapagare;
  final String? denominacion;
  final String? idanalista;
  // ignore: non_constant_identifier_names
  final int? plazo_apro;
  // ignore: non_constant_identifier_names
  final double? monto_aprobado;
  final double? saldo;
  final int? cpendientes;
  final app_estadodocumento idestadodoc;
  final String? calificacionsbs;
  final String? tasainteres;
  // ignore: non_constant_identifier_names
  final app_detalle_cuenta_credito? detalle_cuenta_credito;
  final String? idevalsbs;
  final String? fecdesembolso;
  final String? convjud;
  final String? convextra;

  App_cuenta_credito({
    required this.idcuentacredito,
    required this.idpersona,
    required this.idmaesocios,
    required this.idagenciacta,
    required this.tipomonedacta,
    required this.idtipocuenta,
    // ignore: non_constant_identifier_names
    required this.num_cuenta,
    required this.iddocpagare,
    required this.nrodocpagare,
    required this.tipomoneda,
    required this.idagenciapagare,
    required this.denominacion,
    required this.idanalista,
    // ignore: non_constant_identifier_names
    required this.plazo_apro,
    // ignore: non_constant_identifier_names
    required this.monto_aprobado,
    required this.saldo,
    required this.cpendientes,
    required this.idestadodoc,
    required this.calificacionsbs,
    required this.tasainteres,
    // ignore: non_constant_identifier_names
    this.detalle_cuenta_credito,
    required this.fecdesembolso,
    required this.idevalsbs,
    required this.convjud,
    required this.convextra,
  });

  factory App_cuenta_credito.fromJson(Map<String, dynamic> json) {
    return App_cuenta_credito(
      idcuentacredito: json["idcuentacredito"],
      idpersona: json["idpersona"],
      idmaesocios:
          app_maesocios.fromJson(json["idmaesocios"] as Map<String, dynamic>),
      idagenciacta: json["idagenciacta"],
      tipomonedacta: json["tipomonedacta"],
      idtipocuenta: json["idtipocuenta"],
      num_cuenta: json["num_cuenta"],
      iddocpagare: json["iddocpagare"],
      nrodocpagare: json["nrodocpagare"],
      tipomoneda: json["tipomoneda"],
      idagenciapagare: json["idagenciapagare"],
      denominacion: json["denominacion"],
      idanalista: json["idanalista"],
      plazo_apro: json["plazo_apro"],
      monto_aprobado: json["monto_aprobado"],
      saldo: json["saldo"],
      cpendientes: json["cpendientes"],
      calificacionsbs: json["calificacionsbs"],
      tasainteres: json["tasainteres"],
      idestadodoc: app_estadodocumento
          .fromJson(json["idestadodoc"] as Map<String, dynamic>),
      detalle_cuenta_credito: app_detalle_cuenta_credito
          .fromJson(json["detalle_cuenta_credito"] as Map<String, dynamic>),
      fecdesembolso: json["fecdesembolso"],
      idevalsbs: json["idevalsbs"],
      convjud: json["convjud"],
      convextra: json["convextra"],
    );
  }
}
