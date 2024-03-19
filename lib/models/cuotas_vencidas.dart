// ignore_for_file: camel_case_types, non_constant_identifier_names

class Cuotas_vencidas {
  int? id_cuotas_vencidas;String? dni_socio;String? num_pagare;int? num_cuota;String? fecha_vencimiento;int? dias_atraso;
  double? saldo_deudor;double? saldo_cuota;double? saldo_mora;
  double? amortizacion;
  double? intereses;
  double? interes_moratorio;
  double? interes_compensatorio_vencido;
  double? requerimiento_protesto;
  double? protesto_pagare;
  double? gasto_judiciales;
  double? notificaciones;
  double? aviso_vencimiento;
  double? desgravamen;

  Cuotas_vencidas({
    this.id_cuotas_vencidas,
    this.dni_socio,
    this.num_pagare,
    this.num_cuota,
    this.fecha_vencimiento,
    this.dias_atraso,
    this.saldo_deudor,
    this.saldo_cuota,
    this.saldo_mora,
    this.amortizacion,
    this.intereses,
    this.interes_moratorio,
    this.interes_compensatorio_vencido,
    this.requerimiento_protesto,
    this.protesto_pagare,
    this.gasto_judiciales,
    this.notificaciones,
    this.aviso_vencimiento,
    this.desgravamen,
  });

  factory Cuotas_vencidas.fromJson(Map<String, dynamic> json){
    //var obj = json['nombrelista']
      return Cuotas_vencidas(
        id_cuotas_vencidas: json["id_cuota_vencidas"],
        dni_socio: json["dnisocio"],
        num_pagare: json["numpagare"],
        num_cuota: json["num_cuota"],
        fecha_vencimiento: json["fecha_vencimiento"],
        dias_atraso: json["dias_atraso"],
        saldo_deudor: json["saldo_deudor"],
        saldo_cuota: json["saldo_cuota"],
        saldo_mora: json["saldo_mora"],
        amortizacion: json["amortizacion"],
        intereses: json["intereses"],
        interes_moratorio: json["interes_moratorio"],
        interes_compensatorio_vencido: json["interes_compensatorio_vencido"],
        requerimiento_protesto: json["requerimiento_protesto"],
        protesto_pagare: json["protesto_pagare"],
        gasto_judiciales: json["gasto_judiciales"],
        notificaciones: json["notificaciones"],
        aviso_vencimiento: json["aviso_vencimiento"],
        desgravamen: json["desgravamen"],
        //listas: new List<String>.from(obj);
      );
  }
}