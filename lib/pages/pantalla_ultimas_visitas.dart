// ignore_for_file: unused_local_variable, camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';
import 'package:app_leon_xiii/drawers/clase_drawer.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class drawer_ultimas_visitas extends StatefulWidget {
  const drawer_ultimas_visitas({super.key});

  @override
  _Statedrawer_ultimas_visitas createState() => _Statedrawer_ultimas_visitas();
}

class _Statedrawer_ultimas_visitas extends State<drawer_ultimas_visitas> {
  final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  List<app_morosovisitas> lista_moroso_visitas = [];
  String cadenaToken = Token_valor;
  _Statedrawer_ultimas_visitas();

  bool prueba = false;

  Future<dynamic> _listarGestiones(String valor) async {
    String fechaInicial = DateTime.now().toString().substring(0, 10);
    fechaInicial = "${fechaInicial}T00:00:00.000";
    print(fechaInicial);
    String fechafinal = DateTime.now().toString().substring(0, 10);
    fechafinal = "${fechafinal}T23:59:59.000";
    print(fechafinal);

    var url = Uri.parse(
        '${Url_serv}api/moroso/listar_visitas/${global_personal.iduser}/$fechaInicial/$fechafinal');

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
        app_morosovisitas gestion = app_morosovisitas.fromJson(body);
        lista_moroso_visitas.add(gestion);
      }
      return lista_moroso_visitas;
    }
  }

  @override
  void initState() {
    super.initState();
    _listarGestiones(Valor).then((value) {
      setState(() {
        prueba = true;
      });
    });
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
              'Mis ultimas visitas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Color.fromARGB(255, 234, 234, 234),
              ),
            ),
          ),
        ),
        drawer: claseDrawer(context),
        floatingActionButton: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: Colors.grey,
          color: const Color.fromARGB(137, 235, 208, 2),
          child: Text(
            'Visitas registradas: ${lista_moroso_visitas.length}',
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
                  itemCount: lista_moroso_visitas.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  itemBuilder: (_, index) {
                    String personaAtendio = '';
                    String moti = '';
                    String res = '';
                    String esta = '';

                    for (Persona_atendio p in personaAtendio3) {
                      if (p.codigo ==
                          lista_moroso_visitas[index].personaatendio!.idtabla) {
                        personaAtendio = p.descripcion;
                      }
                    }
                    for (Persona_atendio p in resultado1) {
                      if (p.codigo ==
                          lista_moroso_visitas[index].idresultadovisita) {
                        res = p.descripcion;
                      }
                    }
                    for (Persona_atendio p in motivoAtraso2) {
                      if (p.codigo == lista_moroso_visitas[index].idmotatra) {
                        moti = p.descripcion;
                      }
                    }
                    for (Persona_atendio p in estad3) {
                      if (p.codigo ==
                          lista_moroso_visitas[index].idmorovisiestado) {
                        esta = p.descripcion;
                      }
                    }
                    int hora = int.parse(lista_moroso_visitas[index].fechar.toString().substring(11,13)) ;
                    String fr = hora > 0 && hora <= 11? 'am' : 'pm';
                    return Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Row(
                            children: [
                               Text(
                                  'ID Socio: ${lista_moroso_visitas[index].idsocio!} ',style: const TextStyle(color: Colors.red),),
                                  const SizedBox(width: 15,),
                                  Text(
                                  '${lista_moroso_visitas[index].fechar.toString().substring(8,10)}/${lista_moroso_visitas[index].fechar.toString().substring(11,16)}$fr',style: const TextStyle(color: Color.fromARGB(255, 152, 151, 151),fontWeight: FontWeight.w800),)
                            ],
                          )),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Resultado: $res'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Motivo:$moti'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Quien atendio: $personaAtendio'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Estado: $esta'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Observaciones: ${lista_moroso_visitas[index].comentario}'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Fecha visita: ${lista_moroso_visitas[index].fecvisita.toString().substring(0, 10)}'),
                            lista_moroso_visitas[index].fechacompromiso == null
                                ? const Text('Fecha Compromiso: Sin fecha')
                                : Text(
                                    'Fecha Compromiso: ${lista_moroso_visitas[index].fechacompromiso.toString().substring(0, 10)}'),
                            lista_moroso_visitas[index].foto.toString() == '' ||
                                    lista_moroso_visitas[index].foto == null ||
                                    lista_moroso_visitas[index]
                                            .foto
                                            .toString() ==
                                        '0x'
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 70, 68, 68),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Center(
                                          child: Text(
                                        'Sin imagen',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Center(
                                      child: Image.memory(
                                        const Base64Decoder().convert(
                                            lista_moroso_visitas[index]
                                                .foto
                                                .toString()),
                                        width: 160,
                                        height: 250,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
