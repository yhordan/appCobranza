// ignore_for_file: non_constant_identifier_names

import 'package:app_leon_xiii/models/app_cuenta_credito.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';
import 'package:app_leon_xiii/models/app_ubigeo.dart';
import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/models/personal.dart';

//String Url_serv = 'http://reportes-visitas-cobranza.cacleonxiii.com.pe:8084/backend_leon_XIII/';
//String Url_serv =
//    'http://reportes-visitas-cobranza.cacleonxiii.com.pe:8084/backend_leon_cobranza_ver1/';
String Url_serv ='http://reportes-visitas-cobranza.cacleonxiii.com.pe:8084/backend_leon_cobranza_ver1_prueba_analista/';
//String Url_serv = 'http://10.0.2.2:8080/';
String Valor = '';
String Token_valor = '';
Personal global_personal = Personal(
    login: 'login',
    persona: 'persona',
    password: 'password',
    correo: 'correo',
    idpersona: 'idpersona');
List<Cartera_Atrasada> lista_global_cartera = [];
bool globalDrawer = false;
bool Condicion_global = true;

List<Persona_atendio> resultado1 = [
];

List<Persona_atendio> motivoAtraso2 = [
];
List<Persona_atendio> personaAtendio3 = [
];

List<Persona_atendio> estad3 = [
];

List<Personal> listaPersonal = [];
List<String> listaDepartamentos = [];
List<app_morosovisitas> listaMoroVisitas = [];

List<app_ubigeo> listaGlobalUbigeo = [];
List<App_cuenta_credito> listaGlobalCuentaCredito = [];
