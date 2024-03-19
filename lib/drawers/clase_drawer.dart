// ignore_for_file: unused_element

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/pages/pantalla_mapa.dart';
import 'package:app_leon_xiii/pages/pantalla_ultimas_visitas.dart';
import 'package:app_leon_xiii/pages/pantalla_listar_persona_2.dart';
import 'package:app_leon_xiii/pages/pantalla_listar_personal.dart';
import 'package:app_leon_xiii/pages/pantalla_reporte_cobertura.dart';
import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pages/pantalla_visitas.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:app_leon_xiii/pages/pantalla_deudor.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Drawer claseDrawer(BuildContext context) {
  Personal personal = global_personal;
  String cadenaToken = Token_valor;
  // ignore: non_constant_identifier_names
  List<Cartera_Atrasada> lista_cartera = lista_global_cartera;
  double latitud = 0.0;
  // ignore: unused_local_variable
  double longitud = 0.0;

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

  Future<String> getCurrentLocation() async {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return drawer_mapa(lista_cartera, personal, cadenaToken, lista_cartera);
        //return PantallaRuteo(
        //longitud, latitud);
      },
    ));

    return latitud.toString();
  }

  return Drawer(
    child: Center(
      child: globalDrawer == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 2, 128, 6),
                  ),
                  accountName: Text(
                    personal.persona,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  accountEmail: Text(personal.cargo.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('images/logo02.png'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const drawer_deudor();
                      },
                    ));
                  },
                  child: const ListTile(
                    title: ListBody(
                      children: [
                        Text(
                          "Cartera de socios",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    leading: Icon(
                      Icons.person_search_sharp,
                      color: Color.fromARGB(255, 5, 173, 3),
                    ),
                  ),
                ),
                const Divider(
                  height: 0.1,
                ),
                global_personal.cargo == 'JEFE' ||
                        global_personal.cargo!.trim() == 'MASTER'
                    ? const Center()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const drawer_visitas();
                            },
                          ));
                        },
                        child: const ListTile(
                          title: Text(
                            "Historial de visitas",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.person_pin_circle,
                            color: Color.fromARGB(255, 5, 173, 3),
                          ),
                        ),
                      ),
                const Divider(
                  height: 0.1,
                ),
                global_personal.cargo == 'JEFE' ||
                        global_personal.cargo!.trim() == 'MASTER'
                    ? const Center()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const drawer_ultimas_visitas();
                            },
                          ));
                        },
                        child: const ListTile(
                          title: Text(
                            "Visitas del día",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.sentiment_very_satisfied_outlined,
                            color: Color.fromARGB(255, 5, 173, 3),
                          ),
                        ),
                      ),
                const Divider(
                  height: 0.1,
                ),
                global_personal.cargo == 'JEFE' ||
                        global_personal.cargo!.trim() == 'MASTER'
                    ? const Center()
                    : GestureDetector(
                        onTap: () {
                          /*Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return PantallaRuteo();
                },
              ));*/
                        },
                        child: const ListTile(
                          title: Text(
                            "Ruteo de direcciones",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.maps_home_work,
                            color: Color.fromARGB(255, 5, 173, 3),
                          ),
                        ),
                      ),
                const Divider(
                  height: 0.1,
                ),
                global_personal.cargo != 'JEFE' &&
                        global_personal.cargo != 'MASTER'
                    ? const Center()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const pantalla_listar_personal();
                            },
                          ));
                        },
                        child: const ListTile(
                          title: Text(
                            "Seguimiento",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.broadcast_on_personal_outlined,
                            color: Color.fromARGB(255, 5, 173, 3),
                          ),
                        ),
                      ),
                global_personal.cargo != 'JEFE' &&
                        global_personal.cargo!.trim() != 'MASTER'
                    ? const Center()
                    : const Divider(
                        height: 0.1,
                      ),
                global_personal.cargo != 'JEFE' &&
                        global_personal.cargo!.trim() != 'MASTER'
                    ? const Center()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const pantalla_listar_personal_2();
                            },
                          ));
                        },
                        child: const ListTile(
                          title: Text(
                            "Estadistica",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.stacked_bar_chart_sharp,
                            color: Color.fromARGB(255, 5, 173, 3),
                          ),
                        ),
                      ),
                global_personal.cargo != 'JEFE' &&
                        global_personal.cargo != 'MASTER'
                    ? const Center()
                    : const Divider(
                        height: 0.1,
                      ),
                global_personal.cargo != 'JEFE' &&
                        global_personal.cargo!.trim() != 'MASTER'
                    ? const Center()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const pantalla_reporte_cobertura();
                            },
                          ));
                        },
                        child: const ListTile(
                          title: Text(
                            "Reporte de Cobertura",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(
                            Icons.reduce_capacity_rounded,
                            color: Color.fromARGB(255, 5, 173, 3),
                          ),
                        ),
                      ),
                global_personal.cargo != 'JEFE' &&
                        global_personal.cargo != 'MASTER'
                    ? const Center()
                    : const Divider(
                        height: 0.1,
                      ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const login();
                      },
                    ));
                  },
                  child: const ListTile(
                    title: Text(
                      "Salir",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Color.fromARGB(255, 5, 173, 3),
                    ),
                  ),
                ),
              ],
            ),
    ),
  );
}
