import 'package:app_leon_xiii/models/app_agencias.dart';
import 'package:app_leon_xiii/models/app_tablas.dart';

// ignore: camel_case_types
class app_morosovisitas {
  final String? idmorosovisita;
  final String? nrovisita;
  final String? nromoroso;
  final String? iddocp;
  final String? nrodocp;
  final String? idanalista;
  final String? idestcuomor;
  final String? idpersona;
  final String? nrocuota;
  final app_agencias? idagenciap;
  final String? tipomonedap;
  final String? idresultadovisita;
  final String? idmorovisiestado;
  final String? idmotatra;
  final app_tablas? personaatendio;
  final String? idgestor;
  final String? fecvisita;
  final String? direccion;
  final String? comentario;
  final String? compromisopago;
  final double? montocompromiso;
  final String? fechacompromiso;
  final String? horaini;
  final String? horafin;
  final String? fechar;
  final String? iduserr;
  final String? idevalsbsalineado;
  // ignore: non_constant_identifier_names
  final String? geolocalizacion_latitud;
  // ignore: non_constant_identifier_names
  final String? geolocalizacion_longitud;
  final String? foto;
  final String? idsocio;

  app_morosovisitas({
     this.idmorosovisita,
     this.nrovisita,
     this.nromoroso,
     this.iddocp,
     this.nrodocp,
     this.idanalista,
     this.idagenciap,
     this.idestcuomor,
     this.idpersona,
     this.nrocuota,
     this.tipomonedap,
     this.idresultadovisita,
     this.idmorovisiestado,
     this.idmotatra,
     this.personaatendio,
     this.idgestor,
     this.fecvisita,
     this.direccion,
     this.comentario,
     this.compromisopago,
     this.montocompromiso,
     this.fechacompromiso,
     this.horaini,
     this.horafin,
     this.fechar,
     this.iduserr,
     this.idevalsbsalineado,
     // ignore: non_constant_identifier_names
     this.geolocalizacion_latitud,
     // ignore: non_constant_identifier_names
     this.geolocalizacion_longitud,
     this.foto,
     this.idsocio,
  });

  factory app_morosovisitas.fromJson(Map<String, dynamic> json) {
    return app_morosovisitas(
      idmorosovisita: json["idmorosovisita"],
      nrovisita: json["nrovisita"],
      iddocp: json["iddocp"],
      nrodocp: json["nrodocp"],
      idagenciap:app_agencias.fromJson(json["idagenciap"] as Map<String, dynamic>),
      personaatendio:app_tablas.fromJson(json["personaatendio"] as Map<String, dynamic>),
      nromoroso: json["nromoroso"],
      idestcuomor: json["idestcuomor"],
      idanalista: json["idanalista"],
      idpersona: json["idpersona"],
      nrocuota: json["nrocuota"], 
      tipomonedap: json["tipomonedap"], 
      idresultadovisita: json["idresultadovisita"],
      idmorovisiestado: json["idmorovisiestado"],
      idmotatra: json["idmotatra"],
      idgestor: json["idgestor"],
      fecvisita: json["fecvisita"],
      direccion: json["direccion"],
      comentario: json["comentario"],
      compromisopago: json["compromisopago"],
      montocompromiso: json["montocompromiso"],
      fechacompromiso: json["fechacompromiso"],
      horaini: json["horaini"],
      horafin:json["horafin"],
      fechar: json["fechar"],
      iduserr: json["iduserr"],
      idevalsbsalineado: json["idevalsbsalineado"],
      geolocalizacion_latitud: json["geolocalizacion_latitud"],
      geolocalizacion_longitud:json["geolocalizacion_longitud"],
      foto: json["foto"],
      idsocio: json["idsocio"],
    );
  }
}
