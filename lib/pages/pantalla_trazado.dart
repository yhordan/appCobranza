// ignore_for_file: camel_case_types, must_be_immutable, no_logic_in_create_state, prefer_final_fields, unused_local_variable, avoid_print, prefer_is_empty, prefer_interpolation_to_compose_strings, prefer_collection_literals, unused_element, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class Trazado_pantalla extends StatefulWidget {
  Personal persona;
  String fecha;

  Trazado_pantalla(this.persona, this.fecha, {super.key});
  @override
  State<Trazado_pantalla> createState() =>
      Trazado_pantallaState(persona, fecha);
}

class Trazado_pantallaState extends State<Trazado_pantalla> {
  Personal persona;
  String fecha;
  Trazado_pantallaState(this.persona, this.fecha);

  List<app_morosovisitas> listaMorosa = [];
  List<app_morosovisitas> listaMorosaBan = [];
  List<String> listaIds = [];
  int appi = 0;
  int siafi = 0;

  Future<dynamic> _listarCoordenadas(String valor) async {
    var url = Uri.parse(
        '${Url_serv}api/moroso/listar_visitas/${persona.iduser}/${fecha}T00:00:00.000/${fecha}T23:59:59.000');

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
        app_morosovisitas cartera = app_morosovisitas.fromJson(body);
        listaMorosa.add(cartera);
      }
      return listaMorosa;
    }
    return listaMorosa;
  }

  GoogleMapController? mapController;
  bool prueba = false;
  bool prueba2 = false;
  LatLng _center = const LatLng(-8.10814, -79.02790);
  List<LatLng> _points = [];
  double _arrowLength = 0.0001;
  Color _arrowColor = const Color.fromARGB(255, 145, 145, 145);
  int _polylineWidth = 5;

  void llenarCoordenadas() {
    int ban = 0;
    String vars;
    String vars1;
    print('Entro Aqui!');
    print(listaMorosa.length);
    for (app_morosovisitas i in listaMorosa) {
      vars = i.geolocalizacion_latitud.toString();
      vars1 = i.geolocalizacion_longitud.toString();
      //print('f${vars}f');
      //print('ff${vars1}ff');
      if (vars != '' && vars != 'null') {
        print(
            'Porque entro: ${i.geolocalizacion_latitud} ggg ${i.geolocalizacion_longitud}');
        LatLng ln = LatLng(double.parse(i.geolocalizacion_latitud!),
            double.parse(i.geolocalizacion_longitud!));
        if (i.idsocio != null) {
          listaIds.add(i.idsocio!);
        } else {
          listaIds.add('Sin Id');
        }

        _points.add(ln);
        setState(() {
          _center = ln;
        });
      }
      ban++;
      if (listaIds.length > 0) {
        setState(() {
          print('Entro a listas');
          prueba = true;
        });
      }
    }
  }

  @override
  void initState() {
    _listarCoordenadas(persona.iduser.toString().trim()).then((value) {
      setState(() {
        listaMorosaBan = listaMorosa;
        appi = listaMorosa
          .where((x) => x.foto.toString().trim() != 'null')
          .toList().length;
        siafi =  listaMorosa
          .where((x) => x.foto.toString().trim() == 'null')
          .toList().length;
      });
      print('lista: ${listaMorosa.length}');
      if (listaMorosa.length == 0) {
        print('HIstorial');
        setState(() {
          
          prueba2 = true;
        });
      }
      setState(() {
        llenarCoordenadas();
      });
    });
    print('Fecha: $fecha');
    super.initState();
  }

  void showPopup(BuildContext context, app_morosovisitas moro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String personaAtendio = '';
        String moti = '';
        String res = '';
        String esta = '';

        for (Persona_atendio p in personaAtendio3) {
          if (p.codigo == moro.personaatendio!.idtabla) {
            personaAtendio = p.descripcion;
          }
        }
        for (Persona_atendio p in resultado1) {
          if (p.codigo == moro.idresultadovisita) {
            res = p.descripcion;
          }
        }
        for (Persona_atendio p in motivoAtraso2) {
          if (p.codigo == moro.idmotatra) {
            moti = p.descripcion;
          }
        }
        for (Persona_atendio p in estad3) {
          if (p.codigo == moro.idmorovisiestado) {
            esta = p.descripcion;
          }
        }
        return CupertinoAlertDialog(
            title: Text(
              'Pagaré: ${moro.nrodocp}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                color: Color.fromARGB(255, 251, 0, 0),
              ),
            ),
            content: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  const Text(
                    'Resultado',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(' ${res.trim()}'),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Motivo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(' ${moti.trim()}'),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Quien atendio',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(' $personaAtendio'),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Estado',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(' ${esta.trim()}'),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Fecha visita',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(moro.fecvisita.toString().substring(0, 10)),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Fecha Compromiso',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  moro.fechacompromiso == null
                      ? const Text('Sin fecha')
                      : Text(moro.fechacompromiso.toString().substring(0, 10)),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Observaciones',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text('${moro.comentario?.trim()}'),
                  const SizedBox(
                    height: 6,
                  ),
                  moro.foto.toString() == '' ||
                          moro.foto == null ||
                          moro.foto.toString() == '0x'
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
                                  .convert(moro.foto.toString()),
                              width: 160,
                              height: 250,
                            ),
                          ),
                        ),
                ],
              ),
            ));
      },
    );
  }

  bool app = true;
  bool siaf = true;

  void modificarLista (bool app, bool siaf) {
    print(listaMorosaBan.length);
    List<app_morosovisitas> app_moroso = listaMorosaBan;
    List<app_morosovisitas> app_app = [];
    List<app_morosovisitas> app_siaf = [];
    List<app_morosovisitas> app_total = [];

    if(app == true){
      app_app = app_moroso
          .where((x) => x.foto.toString().trim() != 'null')
          .toList();
      app_total.addAll(app_app);
    }
     if(siaf == true){
      app_siaf = app_moroso
          .where((x) => x.foto.toString().trim() == 'null')
          .toList();
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
            child: Text(
          '${persona.iduser} -- N° de visitas: ${listaMorosaBan.length.toString()}',
          style: const TextStyle(color: Colors.blue),
        )),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: Visibility(
        visible: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Checkbox(
                      activeColor: const Color.fromARGB(255, 0, 119, 4),
                      onChanged: (bool? value) {
                        setState(() {
                          app = value!;
                          setState(() {
                            modificarLista(value,siaf);
                          });
                        });
                      },
                      value: app,
                    ),
                     Text('APP ($appi)'),
                    const SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                      activeColor: const Color.fromARGB(255, 0, 119, 4),
                      onChanged: (bool? value) {
                        setState(() {
                          siaf = value!;
                          setState(() {
                            modificarLista(app,value);
                          });
                        });
                      },
                      value: siaf,
                    ),
                    Text('SIAF ($siafi)'),
                  ],
                ),
                Container(
                  width: 400,
                  height: 200,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 234, 234, 234),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 234, 234, 234),
                          width: 3),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 185, 185, 185),
                            blurRadius: 50,
                            offset: Offset(50, 30))
                      ]),
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      return Container(
                        margin: const EdgeInsets.all(1),
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Card(
                          color: const Color.fromARGB(255, 253, 253, 253),
                          child: ListTile(
                            onTap: () {
                              showPopup(context, listaMorosa[index]);
                            },
                            title: //Center(
                                Padding(
                              padding: const EdgeInsets.all(5),
                              child: ListBody(children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'ID Socio: ${listaMorosa[index].idsocio}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(161, 240, 0, 0)),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    listaMorosa[index].foto.toString() == 'null'
                                        ? const Text(
                                            'SIAF',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : const Text(
                                            'APP',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          )
                                  ],
                                ),
                                listaMorosa[index].nrodocp.toString() == 'null'
                                    ? const Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            // ignore: unnecessary_string_interpolations
                                            'N° Pagaré: Sin registro',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0)),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            // ignore: unnecessary_string_interpolations
                                            'N° Pagaré: ${listaMorosa[index].nrodocp}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0)),
                                          ),
                                        ],
                                      ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      // ignore: unnecessary_string_interpolations
                                      'Fecha: ${listaMorosa[index].fechar.toString().substring(0, 10)}  Hora: ${listaMorosa[index].fechar.toString().substring(11, 16)}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            contentPadding: const EdgeInsets.all(2),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 234, 234, 234),
                    ),
                    itemCount: listaMorosa.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: prueba == false
          ? prueba2 == true
              ? Center(
                  child: SizedBox(
                    child: Column(
                      children: [
                        const Spacer(),
                        Image.asset(
                          "images/mundo.gif",
                          height: 125.0,
                          width: 125.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'No tiene visitas registradas',
                          style: TextStyle(fontSize: 25),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                    child: Column(
                      children: [
                        const Spacer(),
                        Image.asset(
                          "images/mundo.gif",
                          height: 125.0,
                          width: 125.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Cargando ..',
                          style: TextStyle(fontSize: 25),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
          : prueba2 == true
              ? Center(
                  child: SizedBox(
                    child: Column(
                      children: [
                        const Spacer(),
                        Image.asset(
                          "images/mundo.gif",
                          height: 125.0,
                          width: 125.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'No tiene visitas registradas',
                          style: TextStyle(fontSize: 25),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                      CameraPosition(target: _center, zoom: 12.0),
                  markers: _createMarkers(),
                  polylines: _createPolylines()),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = Set();

    for (int i = 0; i < _points.length; i++) {
      LatLng point = _points[i];
      markers.add(
        Marker(
          markerId: MarkerId('marker$i'),
          position: point,
          infoWindow: InfoWindow(
            title: listaIds[i].toString(),
          ),
          icon: i== 0? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen): i== _points.length-1?BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed) :BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _createPolylines() {
    Set<Polyline> polylines = Set();

    if (_points.length > 1) {
      List<LatLng> polylinePoints = _points;

      Polyline polyline = Polyline(
        polylineId: const PolylineId('ruta'),
        color: Colors.transparent,
        points: polylinePoints,
      );

      Polyline arrowPolyline = _createArrowPolyline(polylinePoints);

      polylines.add(polyline);
      polylines.add(arrowPolyline);
    }

    return polylines;
  }

  Polyline _createArrowPolyline(List<LatLng> points) {
    List<LatLng> arrowPoints = [];
    for (int i = 0; i < points.length - 1; i++) {
      arrowPoints.add(points[i]);

      double heading = _calculateHeading(points[i], points[i + 1]);
      LatLng arrowHead = _getArrowHeadPoint(points[i + 1], heading);
      arrowPoints.add(arrowHead);
    }

    return Polyline(
      polylineId: const PolylineId('arrowPolyline'),
      color: _arrowColor,
      points: arrowPoints,
      width: _polylineWidth,
    );
  }

  double _calculateHeading(LatLng p1, LatLng p2) {
    double heading =
        atan2(p2.longitude - p1.longitude, p2.latitude - p1.latitude);
    return heading;
  }

  LatLng _getArrowHeadPoint(LatLng point, double heading) {
    double arrowHeadLatitude = point.latitude - _arrowLength * cos(heading);
    double arrowHeadLongitude = point.longitude - _arrowLength * sin(heading);

    return LatLng(arrowHeadLatitude, arrowHeadLongitude);
  }

  void _showPopup(BuildContext context, LatLng point, int index) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(point.latitude, point.longitude);

    String address = placemarks.isNotEmpty
        ? placemarks[0].street!
        : 'Dirección no disponible';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Punto $index'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Latitud: ${point.latitude}'),
              Text('Longitud: ${point.longitude}'),
              const SizedBox(height: 10),
              Text('Dirección: $address'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
