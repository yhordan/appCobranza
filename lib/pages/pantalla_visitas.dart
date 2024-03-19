// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/controladores/buscar_gestion.dart';
import 'package:app_leon_xiii/models/app_morosos.dart';
import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/drawers/clase_drawer.dart';
import 'package:app_leon_xiii/pantallaFormulario/formulario_visitas.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: camel_case_types
class drawer_visitas extends StatefulWidget {
  const drawer_visitas({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StateDrawer_visitas createState() => _StateDrawer_visitas();
}

// ignore: must_be_immutable, camel_case_types
class _StateDrawer_visitas extends State<drawer_visitas> {
  final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  Personal personal = global_personal;
  // ignore: non_constant_identifier_names
  List<App_morosos> lista_gestion = [];
  // ignore: non_constant_identifier_names
  List<Cartera_Atrasada> lista_cartera = [];
  String cadenaToken = Token_valor;
  _StateDrawer_visitas();

  bool prueba = false;

  Future<dynamic> _listarGestiones(String valor) async {
    var url = Uri.parse(
        '${Url_serv}api/moroso/listar_visitas/${global_personal.idpersona}');

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
        App_morosos gestion = App_morosos.fromJson(body);
        lista_gestion.add(gestion);
      }
      return lista_gestion;
    }
  }

  Future<dynamic> _listarGestionesAnalista(String valor) async {
    print('Usuario${global_personal.iduser}');
    var url = Uri.parse(
        '${Url_serv}api/moroso/listar_visitas_analistas/${global_personal.iduser!.trim()}');

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
        App_morosos gestion = App_morosos.fromJson(body);
        lista_gestion.add(gestion);
      }
      return lista_gestion;
    }
  }

  @override
  void initState() {
    super.initState();
    if (global_personal.idcargo!.trim() == '05' ||
        global_personal.idcargo!.trim() == '03' &&
            global_personal.idarea!.trim() != '07') {
      _listarGestionesAnalista(Valor).then((value) {
        setState(() {
          prueba = true;
        });
      });
    } else {
      _listarGestiones(Valor).then((value) {
        setState(() {
          prueba = true;
        });
      });
    }
  }

  // ignore: unused_element
  void _iconSearch() {}

  // ignore: unused_element
  void _iconAdd() {}

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Deseas salir?',
                  style: TextStyle(color: Color.fromARGB(255, 22, 22, 22)),
                ),
                //content: Text('Exit?'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const login()),
                      );
                    },
                    child: const Text(
                      'Si',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 2, 128, 6),
          elevation: 5,
          shadowColor: const Color.fromARGB(255, 2, 128, 6),
          title: const FittedBox(
            child: Text(
              'Mi registro de visitas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Color.fromARGB(255, 234, 234, 234),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Buscar',
              color: const Color.fromARGB(255, 255, 255, 255),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: buscarGestion(
                      personal, lista_gestion, 'yhordan', cadenaToken),
                );
              },
            ),
          ],
        ),
        drawer: claseDrawer(context),
        floatingActionButton: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: Colors.grey,
          color: const Color.fromARGB(137, 235, 208, 2),
          child: Text(
            'Visitas registradas: ${lista_gestion.length}',
            style: const TextStyle(
                color: Color.fromARGB(203, 6, 6, 6),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
        body: prueba == false
            ? const Center(
                child: Column(
                children: [
                  SizedBox(
                    height: 350,
                  ),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Espere por favor.'),
                ],
              ))
            : Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: ListView.separated(
                  itemCount: lista_gestion.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  itemBuilder: (_, index) {
                    String res = '';
                    for (Persona_atendio p in resultado1) {
                      if (p.codigo == lista_gestion[index].idmoroso) {
                        res = p.descripcion;
                      }
                    }
                    DateTime fechaNuveas =
                        DateTime.parse(lista_gestion[index].fechar.toString());
                    String fecha =
                        DateFormat('yyyy-MM-dd / h:m a').format(fechaNuveas);
                    /*String fechaNueva = '';
                    if (lista_gestion[index].compromisopago != null) {
                      fechaNueva = lista_gestion[index]
                          .compromisopago!
                          .substring(0, 10);
                    }*/
                    return Container(
                      margin: const EdgeInsets.all(2),
                      child: Card(
                        elevation: 7,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      formulario_visitas(lista_gestion[index])),
                            );
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(4),
                            child: ListBody(children: [
                              Text(
                                lista_gestion[index].socio.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              Text(
                                'ID socio: ${lista_gestion[index].idsocio.toString()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              Text(
                                'Pagaré: ${lista_gestion[index].nrodocp}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 38, 12, 241)),
                              ),
                              Text(
                                'Saldo: S/${lista_gestion[index].saldo}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              Text(
                                'C. Vencida: ${lista_gestion[index].cvencidas}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 163, 163, 163)),
                              ),
                              Text(
                                'C. Pendiente: ${lista_gestion[index].cpendientes}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 163, 163, 163)),
                              ),
                              Text(
                                'Estado prestamo: ${lista_gestion[index].estadoprestamo}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 163, 163, 163)),
                              ),
                            ]),
                          ),
                          leading: const Icon(
                            Icons.location_on_outlined,
                            color: Color.fromARGB(255, 2, 128, 6),
                            size: 50,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Color.fromARGB(255, 2, 205, 15),
                          ),
                          contentPadding: const EdgeInsets.all(2),
                        ),
                      ),
                    );
                    /*ListTile(
                title: Text(
                  '${usuarios[index].id_usuario} ${usuarios[index].nombre} ${usuarios[index].direccion} ${usuarios[index].dni}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
              );*/
                  },
                ),
              ),
      ),
    );
  }
}
