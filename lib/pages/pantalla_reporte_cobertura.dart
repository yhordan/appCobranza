// ignore_for_file: unused_element, use_build_context_synchronously, avoid_print
import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/dto_estadistica.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class pantalla_reporte_cobertura extends StatefulWidget {
  const pantalla_reporte_cobertura({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Statepantalla_listar_personal createState() =>
      _Statepantalla_listar_personal();
}

// ignore: camel_case_types
class _Statepantalla_listar_personal extends State<pantalla_reporte_cobertura> {
  TextEditingController dateInput =
      TextEditingController(text: DateTime.now().toString().substring(0, 10));

  List<Dto_estadistica> listaEstadistica = [];
  bool prueba = false;

  Future<dynamic> _listarPersonal() async {
    var url = Uri.parse('${Url_serv}api/app_usuarios/listar_estadistica');

    final response = await http.get(url, headers: {
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
    } else {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        var body = item;
        Dto_estadistica cartera = Dto_estadistica.fromJson(body);
        listaEstadistica.add(cartera);
      }
      return listaEstadistica;
    }
    return null;
  }

  Future<dynamic> _listarPersonalAnalista() async {
    var url = Uri.parse('${Url_serv}api/app_usuarios/listar_estadistica_analistas/${global_personal.idagencia}');

    final response = await http.get(url, headers: {
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
    } else {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      print(jsonData);
      for (var item in jsonData) {
        var body = item;
        Dto_estadistica cartera = Dto_estadistica.fromJson(body);
        listaEstadistica.add(cartera);
      }
      return listaEstadistica;
    }
    return null;
  }

  bool p = false;

  @override
  void initState() {
    super.initState();
    if (global_personal.idcargo!.trim() == '05' ||
        global_personal.idcargo!.trim() == '03' &&
            global_personal.idarea!.trim() != '07') {
      _listarPersonalAnalista().then((value) {
        if (mounted) {
          setState(() {
            prueba = true;
            p=true;
          });
        }
      });
    } else {
      _listarPersonal().then((value) {
        if (mounted) {
          setState(() {
            prueba = true;
            p=false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Reporte de Cobertura',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w700,
                fontSize: 25),
          ),
          backgroundColor: const Color.fromARGB(255, 5, 149, 0),
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
        ),
        body: prueba == false
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Espera por favor ...')
                  ],
                ),
              )
            : ListView.builder(
                itemCount: listaEstadistica.length,
                itemBuilder: (context, index) {
                  int total = listaEstadistica[index].total_cartera;
                  int visitas = listaEstadistica[index].total_visitados;
                  double res = (visitas / total) * 100;
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 199, 198, 198)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: p== true? Text(
                                    'Analista: ${listaEstadistica[index].abreviatura.toString()}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 29, 133, 95),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ): Text(
                                    'Gestor: ${listaEstadistica[index].abreviatura.toString()}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 29, 133, 95),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Color.fromARGB(255, 232, 232, 232),
                                )
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Socios',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    255, 94, 93, 93),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            listaEstadistica[index]
                                                .total_cartera
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Visitados',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    255, 94, 93, 93),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(listaEstadistica[index]
                                              .total_visitados
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Porcentaje',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    255, 94, 93, 93),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text('${res.toStringAsFixed(0)}%'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              ));
  }
}
