// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pages/pantalla_trazado.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: camel_case_types
class pantalla_listar_personal extends StatefulWidget {
  const pantalla_listar_personal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Statepantalla_listar_personal createState() =>
      _Statepantalla_listar_personal();
}

// ignore: camel_case_types
class _Statepantalla_listar_personal extends State<pantalla_listar_personal> {
  List<Personal> listaPersonal = [];
  List<bool> listaEstados = [];
  bool prueba = false;
  TextEditingController dateInput =
      TextEditingController(text: DateTime.now().toString().substring(0, 10));

  Future<dynamic> _actualizarPersonal(String idPersona, bool habilitado) async {
    var url = Uri.parse(
        '${Url_serv}api/app_usuarios/actualizar_habilitado/$idPersona/$habilitado');

    final response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $Token_valor"
    });
    var body1 = response.body;
    Personal personal = Personal.fromJson(jsonDecode(body1));

    return personal;
  }

  Future<dynamic> _listarPersonal() async {
    var url = Uri.parse('${Url_serv}api/app_usuarios/listar');

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
        Personal cartera = Personal.fromJson(body);
        listaPersonal.add(cartera);
      }

      if (global_personal.cargo == 'MASTER') {
        listaPersonal =
            listaPersonal.where((e) => e.cargo.toString() != 'MASTER').toList();
      } else if (global_personal.cargo == 'JEFE') {
        listaPersonal = listaPersonal
            .where((e) =>
                e.cargo.toString() != 'JEFE' && e.cargo.toString() != 'MASTER')
            .toList();
      }

      llenarEstado();

      return listaPersonal;
    }
    return null;
  }

  Future<dynamic> _listarPersonalAnalista() async {
    var url = Uri.parse(
        '${Url_serv}api/app_usuarios/listar_analistas/${global_personal.idagencia}');

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
        Personal cartera = Personal.fromJson(body);
        listaPersonal.add(cartera);
      }

      if (global_personal.cargo == 'MASTER') {
        listaPersonal =
            listaPersonal.where((e) => e.cargo.toString() != 'MASTER').toList();
      } else if (global_personal.cargo == 'JEFE') {
        listaPersonal = listaPersonal
            .where((e) =>
                e.cargo.toString() != 'JEFE' && e.cargo.toString() != 'MASTER')
            .toList();
      }

      llenarEstado();

      return listaPersonal;
    }
    return null;
  }

  void llenarEstado() {
    for (Personal va in listaPersonal) {
      if (va.habilitado == '1') {
        listaEstados.add(true);
      } else {
        listaEstados.add(false);
      }
    }
  }

  @override
  void initState() {
    if (global_personal.idcargo!.trim() == '05' ||
        global_personal.idcargo!.trim() == '03' &&
            global_personal.idarea!.trim() != '07') {
      _listarPersonalAnalista().then((value) {
        setState(() {
          prueba = true;
        });
      });
    } else {
      _listarPersonal().then((value) {
        setState(() {
          prueba = true;
        });
      });
    }

    super.initState();
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de personal'),
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
              padding: const EdgeInsets.all(2),
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                itemCount: listaPersonal.length,
                itemBuilder: (_, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Card(
                        elevation: 3,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        surfaceTintColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            trailing: Transform.scale(
                              scale: 0.9,
                              child: Switch(
                                splashRadius: 10,
                                thumbIcon: thumbIcon,
                                value: listaEstados[index],
                                activeColor:
                                    const Color.fromARGB(255, 57, 140, 1),
                                onChanged: (bool value) {
                                  setState(() {
                                    listaEstados[index] = value;
                                    _actualizarPersonal(
                                        listaPersonal[index].idpersona, value);
                                  });
                                },
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listaPersonal[index].cargo.toString(),
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 0, 0, 0))),
                                Text(
                                  listaPersonal[index].persona.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 2, 147, 6)),
                                ),
                                Text(
                                  listaPersonal[index].iduser.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(145, 0, 81, 255)),
                                ),
                              ],
                            ),
                            onTap: () {
                              _mostrarDialogo(listaPersonal[index]);
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Trazado_pantalla(listaPersonal[index])),
                              );*/
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _mostrarDialogo(Personal personal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Seleccionar fecha a consultar',
            style: TextStyle(fontSize: 20),
          )),
          backgroundColor: const Color.fromARGB(255, 233, 233, 233),
          surfaceTintColor: Colors.white,
          actions: [
            TextField(
              controller: dateInput,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month, color: Colors.green),
                  border: InputBorder.none),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  //locale: const Locale("es","ES"),
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  // ignore: avoid_print
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  // ignore: avoid_print
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    dateInput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Trazado_pantalla(personal, dateInput.text)),
                );
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Prueba()),
                );*/
              },
              child: const Text(
                'Consultar',
                style:
                    TextStyle(color: Color.fromARGB(255, 54, 98, 244), fontWeight: FontWeight.w800),
              ),
            )
          ],
        );
      },
    );
  }
}
