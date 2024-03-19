// ignore_for_file: unused_local_variable, avoid_print, avoid_unnecessary_containers, unnecessary_import, constant_identifier_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_morosos.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoieWhvcmRhbjE3IiwiYSI6ImNsbm5xdmlhMjA3cjEyc3FqZmZzN29rMXEifQ.8Y7VwtJkrqW2shDTR7PtrQ';
final MyPosition = LatLng(40.697488, -73.979681);

// ignore: camel_case_types, must_be_immutable
class formulario_visitas extends StatefulWidget {
  App_morosos idMoroso;
  formulario_visitas(this.idMoroso, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<formulario_visitas> createState() =>
      // ignore: no_logic_in_create_state
      _formularioState(idMoroso);
}

// ignore: camel_case_types
class _formularioState extends State<formulario_visitas> {
  Personal personal = global_personal;
  App_morosos idMoroso;
  List<app_morosovisitas> listaMorosos = [];
  List<app_morosovisitas> listaMorososNueva = [];
  _formularioState(this.idMoroso);
  TextEditingController dateInput = TextEditingController();

  int currentStep = 0;
  File? imagen;
  double aspectRatio = 0;

  continueStep() {
    if (currentStep < 0) {
      setState(() {
        currentStep = currentStep + 1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlsBuilder(context, details) {
    final size = MediaQuery.of(context).size;
    double num = size.height;
    return const Row(
      children: [],
    );
  }

  //Acces Token

  //Determinar Posición
  Future<Position> determinarPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<dynamic> _listarMorosos() async {
    var url = Uri.parse(
        '${Url_serv}api/moroso/listar_detalle_moroso/${idMoroso.idmoroso}');

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

      var re = response.body;
      for (var item in jsonData) {
        var body = item;
        app_morosovisitas cartera = app_morosovisitas.fromJson(body);
        print(cartera.direccion);
        listaMorosos.add(cartera);
      }

      return listaMorosos;
    }
    return listaMorosos;
  }

  void getCurrentLocation() async {
    Position position = await determinarPosition();
    //Imprimiendo coordenadas
    print(position.latitude);
    print(position.longitude);
  }

  bool prueba = false;
  @override
  void initState() {
    _listarMorosos().then((value) {
      setState(() {
        prueba = true;
        dateInput.text = DateTime.now().toString().substring(0, 10);
        print("tamaño: ${listaMorosos.length}");
        listaMorososNueva = listaMorosos;
        listaMorosos = listaMorososNueva
            .where((x) =>
                x.fecvisita.toString().substring(0, 10) == dateInput.text)
            .toList();
      });
    });
    super.initState();
  }

  Image devolverImagen(Image h) {
    Image imagen = h;

    return imagen;
  }

  Container contenido(String nombre) {
    int l = nombre.length;
    double f = 40;
    if (l >= 30) {
      f = 70;
    }
    return Container(
      child: Text(
        nombre,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 13, 13, 13),
        ),
      ),
    );
  }

  Text titulo(String titulo) {
    return Text(
      titulo,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Color.fromARGB(227, 147, 147, 147),
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(177, 190, 235, 195)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Datos del socio',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${idMoroso.socio}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'ID: ${idMoroso.idmoroso}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Monto total a la fecha: S/${idMoroso.montoalafecha}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 155, 155, 155)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tasa de intereses: %${idMoroso.tasainteres}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 155, 155, 155)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total de visitas: ${listaMorososNueva.length}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 155, 155, 155)),
                    ),
                    const SizedBox(height: 10),
                    listaMorososNueva.isNotEmpty? Text(
                      'Ultima visita: ${listaMorososNueva[listaMorososNueva.length-1].fecvisita.toString().substring(0,10)}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 155, 155, 155)),
                    ): const Center(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateInput,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month, color: Colors.green),
                  border: InputBorder.none),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(dateInput.text),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    dateInput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
            ),
            Center(
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                disabledColor: Colors.grey,
                color: const Color.fromARGB(255, 1, 198, 106),
                child: Container(
                  child: const Text(
                    'Aplicar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    print(dateInput.text);
                    listaMorosos = listaMorososNueva
                        .where((x) =>
                            x.fecvisita.toString().substring(0, 10) ==
                            dateInput.text)
                        .toList();
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Registro de visitas (${listaMorosos.length})',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 78, 137, 185)),
              ),
            ),
            const SizedBox(height: 10),
            prueba == false
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: listarElementos(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget listarElementos() {
    return ListView.builder(
      itemCount: listaMorosos.length,
      itemBuilder: (BuildContext context, int index) {
        String personaAtendio = '';
        String moti = '';
        String res = '';
        String esta = '';

        for (Persona_atendio p in personaAtendio3) {
          if (p.codigo == listaMorosos[index].personaatendio!.idtabla) {
            personaAtendio = p.descripcion;
          }
        }
        for (Persona_atendio p in resultado1) {
          if (p.codigo == listaMorosos[index].idresultadovisita) {
            res = p.descripcion;
          }
        }
        for (Persona_atendio p in motivoAtraso2) {
          if (p.codigo == listaMorosos[index].idmotatra) {
            moti = p.descripcion;
          }
        }
        for (Persona_atendio p in estad3) {
          if (p.codigo == listaMorosos[index].idmorovisiestado) {
            esta = p.descripcion;
          }
        }
        return Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 223, 222, 222)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
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
                  Text('Observaciones: ${listaMorosos[index].comentario}'),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      'Fecha visita: ${listaMorosos[index].fecvisita.toString().substring(0, 10)}'),
                  listaMorosos[index].fechacompromiso == null
                      ? const Text('Fecha Compromiso: Sin fecha')
                      : Text(
                          'Fecha Compromiso: ${listaMorosos[index].fechacompromiso.toString().substring(0, 10)}'),
                  listaMorosos[index].foto.toString() == '' ||
                          listaMorosos[index].foto == null ||
                          listaMorosos[index].foto.toString() == '0x'
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 70, 68, 68),
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
                              const Base64Decoder()
                                  .convert(listaMorosos[index].foto.toString()),
                              width: 160,
                              height: 250,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
