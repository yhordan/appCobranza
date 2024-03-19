// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, unused_element, body_might_complete_normally_nullable, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';
import 'package:app_leon_xiii/models/app_morovisiestados.dart';
import 'package:app_leon_xiii/models/app_motivoatraso.dart';
import 'package:app_leon_xiii/models/app_resultadovisitas.dart';
import 'package:app_leon_xiii/models/app_tablas.dart';
import 'package:app_leon_xiii/models/app_ubigeo.dart';
import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/models/gestion_aval.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pages/pantalla_deudor.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class splashPantalla extends StatefulWidget {
  Personal personal;
  String cadenaToken = ''; 
  splashPantalla(this.personal, this.cadenaToken, {super.key});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _splashPantalla createState() => _splashPantalla(personal, cadenaToken);
}

class _splashPantalla extends State<splashPantalla> {
  var va = Url_serv;
  List<Cartera_Atrasada> cartera_atrasada = [];
  List<Gestion_Aval> lista_gestion = [];
  String cadenaToken = '';
  List<app_ubigeo> listaUbigeo = [];
  List<app_resultadovisitas> listaResultado = [];
  List<app_motivoatraso> listaMotivoAtraso = [];
  List<app_morovisiestados> listaEstados = [];
  List<app_tablas> listaPersonAtendio = [];

  Future<List<Cartera_Atrasada>?> _listarCartera(String valor) async {
    var url = Uri.parse('${va}api/cartera_atrasada/buscar/$valor');

    final response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

    if (response.statusCode == 403) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Se acabo su tiempo '),
            content: const Text("Inicie sesion nuevamente!"),
            actions: [
              TextButton(
                child: const Text(
                  "Aceptar",
                  style: TextStyle(color: Color.fromARGB(255, 198, 6, 6)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const login()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        var body = item;
        Cartera_Atrasada cartera = Cartera_Atrasada.fromJson(body);
        cartera_atrasada.add(cartera);
      }
      return cartera_atrasada;
    }
  }

  Future<dynamic> _listarUbigeos() async {
    var url = Uri.parse('${va}api/app_ubigeo/listar');

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

    if (response.statusCode == 403) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Se acabo su tiempo '),
            content: const Text("Inicie sesion nuevamente!"),
            actions: [
              TextButton(
                child: const Text(
                  "Aceptar",
                  style: TextStyle(color: Color.fromARGB(255, 198, 6, 6)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const login()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      //List<Cartera_Atrasada> carteras = [];

      //print(response.body);
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      //print(response.body[1]);
      for (var item in jsonData) {
        var body = item;
        app_ubigeo gestion = app_ubigeo.fromJson(body);
        listaUbigeo.add(gestion);
      }
      return lista_gestion;
    }
  }

  Future<dynamic> _listarGestiones(String valor) async {
    var url = Uri.parse('${va}api/gestion_socio_aval/buscar/$valor');

    final response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

    if (response.statusCode == 403) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Se acabo su tiempo '),
            content: const Text("Inicie sesion nuevamente!"),
            actions: [
              TextButton(
                child: const Text(
                  "Aceptar",
                  style: TextStyle(color: Color.fromARGB(255, 198, 6, 6)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const login()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      //List<Cartera_Atrasada> carteras = [];

      //print(response.body);
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      //print(response.body[1]);
      for (var item in jsonData) {
        var body = item;
        Gestion_Aval gestion = Gestion_Aval.fromJson(body);
        lista_gestion.add(gestion);
      }
      return lista_gestion;
    }
  }
  
  Future<dynamic> _listarResultado() async {
    var url = Uri.parse('${va}api/app_combos_visita/listar_resultado_visita');

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        var body = item;
        app_resultadovisitas gestion = app_resultadovisitas.fromJson(body);
        listaResultado.add(gestion);
      }
      return listaResultado;
    
  }

  List<app_morosovisitas> listaMoro =[];

  Future<dynamic> _listarMoroVisitas() async {
    var url = Uri.parse('${va}api/moroso/listar_viistas_mesactual');

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        var body = item;
        app_morosovisitas gestion = app_morosovisitas.fromJson(body);
        listaMoro.add(gestion);
      }
      return listaMoro;
    
  }

  Future<dynamic> _listarMotivoAtraso() async {
    var url = Uri.parse('${va}api/app_combos_visita/listar_motivo_atraso');

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        var body = item;
        app_motivoatraso gestion = app_motivoatraso.fromJson(body);
        listaMotivoAtraso.add(gestion);
      }
      return listaMotivoAtraso;
    
  }

  Future<dynamic> _listarEstado() async {
    var url = Uri.parse('${va}api/app_combos_visita/listar_morovisiestados');

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        var body = item;
        app_morovisiestados gestion = app_morovisiestados.fromJson(body);
        listaEstados.add(gestion);
      }
      return listaEstados;
    
  }

  Future<dynamic> _listarPersonaAtendio() async {
    var url = Uri.parse('${va}api/app_combos_visita/listar_persona_atendio');

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        var body = item;
        app_tablas gestion = app_tablas.fromJson(body);
        listaPersonAtendio.add(gestion);
      }
      return listaPersonAtendio;
    
  }

  Personal personal;
  _splashPantalla(this.personal, this.cadenaToken);
  @override
  void initState() {
    //_listarCartera(personal.login);
    //_listarGestiones(personal.yyy);
    _listarMoroVisitas().then((value) {
        print('Tamaño de lista de moro: ' + listaMoro.length.toString());
        setState(() {
          listaMoroVisitas = listaMoro;
        });
      });
    _listarUbigeos().then((value) {
        setState(() {
          listaGlobalUbigeo = listaUbigeo;
        });
      });
    _listarResultado().then((value) {
        setState(() {
          for(app_resultadovisitas ap in listaResultado){
            Persona_atendio pe = Persona_atendio(codigo: ap.idresultadovisita.trim(), descripcion: ap.resultadovisita);
            resultado1.add(pe);
          }
        });
      });
    
    _listarMotivoAtraso().then((value) {
        setState(() {
          for(app_motivoatraso ap in listaMotivoAtraso){
            Persona_atendio pe = Persona_atendio(codigo: ap.idmotivoatraso.trim(), descripcion: ap.motivoatraso);
            motivoAtraso2.add(pe);
          }
        });
      });

    _listarEstado().then((value) {
        setState(() {
          for(app_morovisiestados ap in listaEstados){
            Persona_atendio pe = Persona_atendio(codigo: ap.idmorovisiestados.trim(), descripcion: ap.morovisiestados);
            estad3.add(pe);
          }
        });
      });
     _listarPersonaAtendio().then((value) {
        setState(() {
          for(app_tablas ap in listaPersonAtendio){
            Persona_atendio pe = Persona_atendio(codigo: ap.idtabla.trim(), descripcion: ap.descripcion);
            personaAtendio3.add(pe);
          }
        });
      });
    
    Valor = personal.login;
    Token_valor = cadenaToken;
    global_personal = personal;

    Future.delayed(
      const Duration(milliseconds: 0),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const drawer_deudor(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Spacer(),
          Spacer(),
          Spacer(),
          Center(
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: CircularProgressIndicator(
                semanticsLabel: 'Circular progress indicator',
                color: Color.fromARGB(255, 30, 103, 33),
              ),
            ),
          ),
          SizedBox(width: 50, height: 50),
          Text(
            'Cargando Datos',
            style: TextStyle(
              color: Color.fromARGB(255, 8, 8, 8),
              fontSize: 25,
            ),
          )
        ],
      ),
    );
  }
}
