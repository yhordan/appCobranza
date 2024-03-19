// ignore_for_file: prefer_initializing_formals, non_constant_identifier_names, camel_case_types

class Cartera_Atrasada {
  final int id_cartera;
  final String codigo;
  final String dni_socio;
  final String nombre_socio;
  final String direccion_socio;
  final String num_pagare;
  final int total_cuotas;
  final double sdo_cap_total;
  final int ra_cta_vencida;
  final int dias_atraso; 
  final double sdo_ra_cta_vencida ;
  final String codigo_producto;
  final String? ultima_gestion;
  final String dni_aval;
  final String nombre_aval;
  final String direccion_aval;
  final String ide_socio;
  final String oficina;
  final String? geolocalizacion_latitud;
  final String? geolocalizacion_longitud;
  final String? abreviatura;
  final String? celular_actual1;
  final String? celular_actual2;
  final String? referencia_domiciliaria;
  final String? direccion_alternativa1;
  final String? direccion_alternativa2;
  final String? calificacion_deudor;

  bool isSelected=false;
  bool ban = false;
  
  Cartera_Atrasada({
    required this.id_cartera,
    required this.celular_actual1,
    required this.celular_actual2,
    required this.referencia_domiciliaria,
    required this.direccion_alternativa1,
    required this.direccion_alternativa2,
    required this.calificacion_deudor,
    required this.codigo,
    required this.dni_socio,
    required this.nombre_socio,
    required this.direccion_socio,
    required this.num_pagare,
    required this.total_cuotas,
    required this.sdo_cap_total,
    required this.ra_cta_vencida,
    required this.codigo_producto,
    this.ultima_gestion,
    required this.dni_aval,
    required this.nombre_aval,
    required this.direccion_aval,
    required this.dias_atraso,
    required this.sdo_ra_cta_vencida,
    required this.ide_socio,
    required this.oficina,
    this.geolocalizacion_latitud,
    this.geolocalizacion_longitud,
    required this.abreviatura,
  });

  // ignore: empty_constructor_bodies
  factory Cartera_Atrasada.fromJson(Map<String, dynamic> json){
    //var obj = json['nombrelista']
      return Cartera_Atrasada(
        id_cartera:json["id_cartera"],
        codigo:json["codigo"],
        dni_socio:json["dni_socio"],
        nombre_socio:json["nombre_socio"],
        direccion_socio:json["direccion_socio"],
        num_pagare:json["num_pagare"],
        total_cuotas:json["total_cuotas"],
        sdo_cap_total:json["sdo_cap_total"],
        ra_cta_vencida:json["primera_cta_vencida"],
        codigo_producto:json["codigo_producto"],
        ultima_gestion:json["ultima_gestion"],
        dni_aval:json["dni_aval"],
        nombre_aval:json["nombre_aval"],
        direccion_aval:json["direccion_aval"],
        dias_atraso:json["dias_atraso"],
        sdo_ra_cta_vencida:json["sdo_primera_cta_vencida"],
        ide_socio:json["ide_socio"],
        oficina:json["oficina"],
        geolocalizacion_latitud:json["geolocalizacion_latitud"],
        geolocalizacion_longitud:json["geolocalizacion_longitud"],
        abreviatura:json["abreviatura"],
        celular_actual1:json["celular_actual1"],
        celular_actual2:json["celular_actual2"],
        referencia_domiciliaria:json["referencia_domiciliaria"],
        direccion_alternativa1:json["direccion_alternativa1"],
        direccion_alternativa2:json["direccion_alternativa2"],
        calificacion_deudor:json["calificacion_deudor"],
        //listas: new List<String>.from(obj);
      );
  }
  
}
