// ignore_for_file: camel_case_types, must_be_immutable, no_logic_in_create_state, prefer_final_fields, unused_local_variable, avoid_print, prefer_is_empty, prefer_interpolation_to_compose_strings, prefer_collection_literals, unused_element, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Trazado_pantalla_2 extends StatefulWidget {
  String fecha;

  Trazado_pantalla_2(this.fecha, {super.key});
  @override
  State<Trazado_pantalla_2> createState() => Trazado_pantallaState(fecha);
}

class Trazado_pantallaState extends State<Trazado_pantalla_2> {
  String fecha;
  Trazado_pantallaState(this.fecha);

  List<app_morosovisitas> listaMorosa = [];
  List<app_morosovisitas> listaMorosaBan = [];
  List<String> listaIds = [];
  int appi = 0;
  int siafi = 0;
  bool prueba = false;
  bool accesoInternet = true;
  http.Client? client;

  Future<dynamic> _listarCoordenadas() async {
    int intentos = 0;
    int maxIntentos = 10;

    while (intentos < maxIntentos) {
      try {
        client = http.Client();

        var url = Uri.parse(
            '${Url_serv}api/moroso/listar_detalle_visitas/${fecha}T00:00:00.000/${fecha}T23:59:59.000');

        final response = await client!.get(url, headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $Token_valor"
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
          return null;
        } else {
          print('Entro aqui');
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);

          for (var item in jsonData) {
            var body = item;
            app_morosovisitas cartera = app_morosovisitas.fromJson(body);
            listaMorosa.add(cartera);
          }
          return listaMorosa;
        }
      } catch (e) {
        print('Error de conexión: $e');
      } finally {
        print('Client Closeeee');
        client?.close();
      }

      print('Número de intento: $intentos');
      intentos++;
      await Future.delayed(const Duration(seconds: 2));
    }

    accesoInternet = false;
    print('Se superó el límite de intentos');
    return null;
  }

  Future<dynamic> _listarCoordenadasAnalista() async {
    int intentos = 0;
    int maxIntentos = 10;

    while (intentos < maxIntentos) {
      try {
        client = http.Client();

        var url = Uri.parse(
            '${Url_serv}api/moroso/listar_detalle_visitas_analistas/${fecha}T00:00:00.000/${fecha}T23:59:59.000/${global_personal.idagencia}');

        final response = await client!.get(url, headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $Token_valor"
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
          return null;
        } else {
          print('Entro aqui');
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);

          for (var item in jsonData) {
            var body = item;
            app_morosovisitas cartera = app_morosovisitas.fromJson(body);
            listaMorosa.add(cartera);
          }
          return listaMorosa;
        }
      } catch (e) {
        print('Error de conexión: $e');
      } finally {
        print('Client Closeeee');
        client?.close();
      }

      print('Número de intento: $intentos');
      intentos++;
      await Future.delayed(const Duration(seconds: 2));
    }

    accesoInternet = false;
    print('Se superó el límite de intentos');
    return null;
  }

  List<String> listaNombres = [];

  Future<void> traerLista() async {
    Set<String> elementosVistos = Set();
    List<String> elementosRepetidos = [];

    for (app_morosovisitas elemento in listaMorosa) {
      if (elementosVistos.contains(elemento.iduserr)) {
        elementosRepetidos.add(elemento.iduserr!);
      } else {
        setState(() {
          listaNombres.add(elemento.iduserr.toString());
          elementosVistos.add(elemento.iduserr.toString());
        });
      }
    }
  }

  @override
  void initState() {
    client = http.Client();
    if (global_personal.idcargo!.trim() == '05' ||
        global_personal.idcargo!.trim() == '03' &&
            global_personal.idarea!.trim() != '07') {
              print('analista!!!');
      _listarCoordenadasAnalista().then((value) {
        traerLista().then((value) {
          setState(() {
            prueba = true;
          });
        });
      });
    } else {
      _listarCoordenadas().then((value) {
        traerLista().then((value) {
          setState(() {
            prueba = true;
          });
        });
      });
    }

    print('Fecha: $fecha');
    super.initState();
  }

  @override
  void dispose() {
    client?.close();
    super.dispose();
  }

  bool app = true;
  bool siaf = true;

  void modificarLista(bool app, bool siaf) {
    print(listaMorosaBan.length);
    List<app_morosovisitas> app_moroso = listaMorosaBan;
    List<app_morosovisitas> app_app = [];
    List<app_morosovisitas> app_siaf = [];
    List<app_morosovisitas> app_total = [];

    if (app == true) {
      app_app = app_moroso.where((x) => x.fechacompromiso != null).toList();
      app_total.addAll(app_app);
    }
    if (siaf == true) {
      app_siaf = app_moroso.where((x) => x.fechacompromiso == null).toList();
      app_total.addAll(app_siaf);
    }

    setState(() {
      listaMorosa = app_total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                'Visitas ingresadas: ${listaMorosa.length.toString()}',
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              Text(
                'Fecha: $fecha',
                style:
                    const TextStyle(color: Color.fromARGB(255, 187, 187, 187)),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: const Color.fromARGB(255, 222, 222, 222))),
                child: Row(
                  children: [
                    Container(
                        height: 50,
                        color: const Color.fromRGBO(218, 248, 217, 0.516),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Gestores',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                  fontSize: 15),
                            ),
                          ),
                        )),
                    Container(
                        height: 50,
                        color: const Color.fromRGBO(218, 248, 217, 0.516),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Gestiones ingresadas',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                  fontSize: 15),
                            ),
                          ),
                        )),
                    Container(
                        height: 50,
                        color: const Color.fromRGBO(218, 248, 217, 0.516),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Compromisos de pago',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                  fontSize: 15),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          accesoInternet != true
              ? const AccesoAInternet()
              : prueba == false
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(70.0),
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 222, 221, 221),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: ListView.builder(
                                itemCount: listaNombres.length,
                                itemBuilder: (_, index) {
                                  return Container(
                                    color: index % 2 == 0
                                        ? const Color.fromARGB(38, 255, 191, 0)
                                        : Colors.white,
                                    child: ListTile(
                                        title: Text(
                                      listaNombres[index],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: ListView.builder(
                                itemCount: listaNombres.length,
                                itemBuilder: (_, index) {
                                  List<app_morosovisitas> num = listaMorosa
                                      .where((x) =>
                                          x.iduserr!.trim() ==
                                          listaNombres[index].trim())
                                      .toList();
                                  int nume = num.length;
                                  return Container(
                                      color: index % 2 == 0
                                          ? const Color.fromARGB(
                                              38, 255, 191, 0)
                                          : Colors.white,
                                      child: ListTile(
                                          title: Text(nume.toString())));
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: ListView.builder(
                                itemCount: listaNombres.length,
                                itemBuilder: (_, index) {
                                  List<app_morosovisitas> num = listaMorosa
                                      .where((x) =>
                                          x.iduserr!.trim() ==
                                              listaNombres[index].trim() &&
                                          x.fechacompromiso != null)
                                      .toList();
                                  int nume = num.length;
                                  return Container(
                                      color: index % 2 == 0
                                          ? const Color.fromARGB(
                                              38, 255, 191, 0)
                                          : Colors.white,
                                      child: ListTile(
                                          title: Text(nume.toString())));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}

class AccesoAInternet extends StatelessWidget {
  const AccesoAInternet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: [
            Icon(
              Icons.network_check_rounded,
              color: Color.fromARGB(255, 152, 152, 152),
            ),
            Text('Se perdio la conexión!')
          ],
        ),
      ),
    );
  }
}
