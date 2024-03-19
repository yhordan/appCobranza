// ignore_for_file: camel_case_types, non_constant_identifier_names

class Gestion_Aval {
  final int? id_gestion_aval;
  final String? num_pagare;
  final String? socio;
  final String? dni_socio;
  final String? nombre_socio_aval;
  final String? motivo_atraso;
  final String? resultado;
  final String? persona_atendio;
  final String? estado;
  final String? compromiso_pago;
  final String? direccion;
  final String? observaciones;
  final String? fecha_registro;
  final String? usuario_registro;
  final String? geo_longitud;
  final String? geo_latitud;
  final String? celular;
  final String? correo;
  final String? estado_civil;
  final String? idsocio;
  final String? abreviatura;
  final String? foto;

  Gestion_Aval(
      {
        this.id_gestion_aval,
      this.num_pagare,
      this.socio,
      this.dni_socio,
     this.nombre_socio_aval,
      this.motivo_atraso,
      this.resultado,
      this.persona_atendio,
      this.estado,
      this.compromiso_pago,
      this.direccion,
      this.observaciones,
      this.fecha_registro,
      this.usuario_registro,
      this.geo_latitud,
      this.geo_longitud,
     this.celular,
     this.correo,
     this.estado_civil,
     this.abreviatura,
     this.idsocio,
     this.foto});
     

  factory Gestion_Aval.fromJson(Map<String, dynamic> json) {
    //var obj = json['nombrelista']
    return Gestion_Aval(
      id_gestion_aval: json["id_gestion"],
      num_pagare: json["num_pagare"],
      socio: json["socio_aval"],
      dni_socio: json["dni_socio_aval"],
      nombre_socio_aval: json["nombre_socio_aval"],
      motivo_atraso: json["motivo_atrazo"],
      resultado: json["resultado"],
      persona_atendio: json["persona_atendio"],
      estado: json["estado"],
      compromiso_pago: json["compromiso_pago"],
      direccion: json["direccion"],
      observaciones: json["observaciones"],
      fecha_registro: json["fecha_registro"],
      usuario_registro: json["usuarioregistro"],
      geo_latitud: json["geolocalizacion_latitud"],
      geo_longitud: json["geolocalizacion_longitud"],
      celular: json["celular"],
      correo: json["correo"],
      estado_civil: json["estado_civil"],
      idsocio: json["idsocio"],
      abreviatura: json["abreviatura"],
      foto: json["foto"],
    );
  }
}
