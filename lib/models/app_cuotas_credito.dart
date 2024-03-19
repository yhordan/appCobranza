// ignore: camel_case_types
class app_cuotas_credito {
  final String idcuotascredito;
  final String idpersona;
  final String iddocp;
  final String nrodocp;
  final String tipomonedap;
  final String idagenciap;
  final String nrocuota;
  final String fecven;
  final String estcuota;
  final int diasatraso;
  final double amortiza;
  final double interes;
  final double desgravamen;
  final double interesmora;
  final double interesvenc;

  app_cuotas_credito({
    required this.idcuotascredito,
    required this.idpersona,
    required this.iddocp,
    required this.nrodocp,
    required this.tipomonedap,
    required this.idagenciap,
    required this.nrocuota,
    required this.fecven,
    required this.estcuota,
    required this.diasatraso,
    required this.amortiza,
    required this.interes,
    required this.desgravamen,
    required this.interesmora,
    required this.interesvenc,
  });

  factory app_cuotas_credito.fromJson(Map<String, dynamic> json) {
    return app_cuotas_credito(
      idcuotascredito: json["idcuotascredito"],
      idpersona: json["idpersona"],
      iddocp: json["iddocp"],
      nrodocp: json["nrodocp"],
      tipomonedap: json["tipomonedap"],
      idagenciap: json["idagenciap"],
      nrocuota: json["nrocuota"],
      fecven: json["fecven"],
      estcuota: json["estcuota"],
      diasatraso: json["diasatraso"],
      amortiza: json["amortiza"],
      interes: json["interes"],
      desgravamen: json["desgravamen"],
      interesmora: json["interesmora"],
      interesvenc: json["interesvenc"],
    );
  }
}
