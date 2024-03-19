// ignore_for_file: camel_case_types

class app_fiador {
  final String idfiador;
  final String idsocio;
  final String idpersonatitular;
  final String iddocp;
  final String nrodocp;
  final String tipmonedap;
  final String idagenciap;
  final String idpersonafiador;
  final String? fiador;
  final String? tipodocumento;
  final String? nrodocumento;
  final String? idubigeodir;
  final String? direccion;
  final String? referencia;
  final String? celular1;
  final String? celular2;

  app_fiador({
    required this.idfiador,
    required this.idsocio,
    required this.idpersonatitular,
    required this.iddocp,
    required this.nrodocp,
    required this.tipmonedap,
    required this.idagenciap,
    required this.idpersonafiador,
    required this.celular2,
    required this.celular1,
    required this.referencia,
    required this.idubigeodir,
    required this.direccion,
    required this.nrodocumento,
    required this.tipodocumento,
    required this.fiador,
  });

  factory app_fiador.fromJson(Map<String, dynamic> json) {
    return app_fiador(
      fiador: json["fiador"],
      idagenciap: json["idagenciap"],
      celular1: json["celular1"],
      celular2: json["celular2"],
      direccion: json["direccion"],
      iddocp: json["iddocp"],
      idfiador: json["idfiador"],
      idpersonafiador: json["idpersonafiador"],
      idpersonatitular: json["idpersonatitular"],
      idsocio: json["idsocio"],
      idubigeodir: json["idubigeodir"],
      nrodocp: json["nrodocp"],
      nrodocumento: json["nrodocumento"],
      referencia: json["referencia"],
      tipmonedap: json["tipmonedap"],
      tipodocumento: json["tipodocumento"],
    );
  }
}
