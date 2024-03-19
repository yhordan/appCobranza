// ignore: camel_case_types
class app_pagare_gestorjud {
  // ignore: non_constant_identifier_names
  final String id_pgestorjud;
  final String idgestor;
  final String idsocio;
  final String idsdocp;
  final String nrodocp;
  final String tipomonedap;
  final String idagenciap;
  final String extrajudicial;

  app_pagare_gestorjud({
    // ignore: non_constant_identifier_names
    required this.id_pgestorjud,
    required this.idgestor,
    required this.idsocio,
    required this.idsdocp,
    required this.nrodocp,
    required this.tipomonedap,
    required this.idagenciap,
    required this.extrajudicial,
  });

  factory app_pagare_gestorjud.fromJson(Map<String, dynamic> json) {
    return app_pagare_gestorjud(
      id_pgestorjud: json["id_pgestorjud"],
      idgestor: json["idgestor"],
      idsocio: json["idsocio"],
      idsdocp: json["idsdocp"],
      nrodocp: json["nrodocp"],
      tipomonedap: json["tipomonedap"],
      idagenciap: json["idagenciap"],
      extrajudicial: json["extrajudicial"],
    );
  }
}
