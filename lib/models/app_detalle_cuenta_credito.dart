
// ignore: camel_case_types
class app_detalle_cuenta_credito  {
  final String? idcuentacredito;
  final int diasmorosidad;
  final String fecultpagointeres;
  final double montoalafecha;
  final int cpagadas;
  final int cpendientes;
  final int cvencidas;
  final String? primeracuotamorosa;
  final String? feccuotamorosa;

  app_detalle_cuenta_credito({
     this.idcuentacredito,
    required this.diasmorosidad,
    required this.fecultpagointeres,
    required this.montoalafecha,
    required this.cpagadas,
    required this.cpendientes,
    required this.cvencidas,
    required this.primeracuotamorosa,
    required this.feccuotamorosa,
  });

  factory app_detalle_cuenta_credito.fromJson(Map<String, dynamic> json) {
    return app_detalle_cuenta_credito(
      idcuentacredito: json["idcuentacredito"],
      diasmorosidad: json["diasmorosidad"],
      fecultpagointeres: json["fecultpagointeres"],
      montoalafecha: json["montoalafecha"],
      cpagadas: json["cpagadas"],
      cpendientes: json["cpendientes"],
      cvencidas: json["cvencidas"],
      primeracuotamorosa: json["primeracuotamorosa"],
      feccuotamorosa: json["feccuotamorosa"],
    );
  }
}
