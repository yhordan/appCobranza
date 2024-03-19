// ignore_for_file: non_constant_identifier_names, deprecated_member_use, prefer_conditional_assignment, camel_case_types, must_be_immutable, avoid_print, duplicate_ignore, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/controladores/buscar_usuario.dart';
import 'package:app_leon_xiii/models/app_cuenta_credito.dart';
import 'package:app_leon_xiii/models/app_ubigeo.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/drawers/clase_drawer.dart';
import 'package:app_leon_xiii/pantallaFormulario/formulario_deudor.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

// ignore: must_be_immutable, camel_case_types
class drawer_deudor extends StatefulWidget {
  const drawer_deudor({super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _StateDrawer_deudor createState() => _StateDrawer_deudor();
}

// ignore: camel_case_types
class _StateDrawer_deudor extends State<drawer_deudor> {
  final moonLanding = DateTime.now();
  Personal personal = global_personal;
  //List<Cartera_Atrasada> cartera_atrasada = [];
  List<App_cuenta_credito> listaCuentaCreditoBan = [];
  List<App_cuenta_credito> listaCuentaCredito = [];
  String cadenaToken = Token_valor;
  _StateDrawer_deudor();

  var va = Url_serv;

  String nombre = 'carloshuiman@gmail.com';
  String correo = 'carloshuiman@gmail.com';
  bool indAlfabetico = true;

  String departamento = 'Hola';

  List<String> listaDistritos = [
    'Distritos',
    'Listart',
  ];
  String varDis = '';
  String distrito = 'hola';
  String ubi = '';

  bool normal = true;
  bool cpp = true;
  bool deficiente = true;
  bool perdida = true;
  bool dudoso = true;

  bool prueba = false;
  bool abriFiltro = false;

  Location location = Location();

  Future<void> _requestLocationPermission() async {
    var status = await location.requestPermission();
    if (status == PermissionStatus.denied) {
      _requestLocationPermission();
      print('Denego permisos');
      // El usuario ha denegado el acceso al GPS.
      // Puedes mostrar un diálogo o realizar acciones apropiadas.
    } else if (status == PermissionStatus.granted) {
      print('Acepto permisos');
      // El usuario ha otorgado permisos.
      // Puedes comenzar a utilizar la ubicación.
    }
  }

  Future<void> _checkLocationPermission() async {
    var hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.granted) {
      print('La aplicación tiene permisos de ubicación.');
    } else {
      var status = await location.requestPermission();
      if (status == PermissionStatus.denied) {
        _requestLocationPermission();
        print('Denego permisos');
      } else if (status == PermissionStatus.granted) {
        print('Acepto permisos');
      }
      print('La aplicación no tiene permisos de ubicación.');
    }
  }

  void funcionLlenarCombos() {
    for (app_ubigeo d in listaGlobalUbigeo) {
      if (d.nivel.trim() == '3') {
        setState(() {
          listaDepartamentos.add(d.descripcion.trim());
        });
      }
    }
  }

  void funcionLlenarDistrito(String val) {
    listaDistritos.clear();
    for (app_ubigeo d in listaGlobalUbigeo) {
      if (d.nivel.trim() == '4' && d.idubigeo.substring(0, 6) == val) {
        listaDistritos.add(d.descripcion);
        distrito = listaDistritos.first;
      }
    }
  }

  Future<List<App_cuenta_credito>?> _listarCarteraJu(String valor) async {
    var url = Uri.parse('${va}api/app_gestor_judicial/buscar/$valor');

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
        App_cuenta_credito cartera = App_cuenta_credito.fromJson(body);
        setState(() {
          listaCuentaCredito.add(cartera);

          prueba = true;
        });
      }

      //listaCuentaCredito = listaCuentaCredito.where((x) => x.detalle_cuenta_credito!.cvencidas != 0).toList();
      return listaCuentaCredito;
    }
    return null;
  }

  Future<List<App_cuenta_credito>?> _listarCartera(String valor) async {
    var url = Uri.parse(
        '${va}api/app_analista_gestorcob/buscar/$valor/${global_personal.cargo}');

        print('valor: ' + valor);

    final response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

    if (response.statusCode == 403) {
      // ignore: use_build_context_synchronously
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
        App_cuenta_credito cartera = App_cuenta_credito.fromJson(body);
        setState(() {
          listaCuentaCredito.add(cartera);
          prueba = true;
        });
      }
      //listaCuentaCredito = listaCuentaCredito.where((x) => x.detalle_cuenta_credito!.cvencidas != 0).toList();
      return listaCuentaCredito;
    }
    return null;
  }

  Future<List<App_cuenta_credito>?> _listarCarteraAnalista() async {
    var url = Uri.parse(
        '${va}api/app_analista_gestorcob/buscar_analista/${global_personal.idpersona}/${global_personal.idcargo}/${global_personal.idarea}/${global_personal.idagencia}');

    final response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $cadenaToken"
    });

    if (response.statusCode == 403) {
      // ignore: use_build_context_synchronously
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
        App_cuenta_credito cartera = App_cuenta_credito.fromJson(body);
        setState(() {
          listaCuentaCredito.add(cartera);
          prueba = true;
        });
      }
      //listaCuentaCredito = listaCuentaCredito.where((x) => x.detalle_cuenta_credito!.cvencidas != 0).toList();
      print('Tamaño: '+ listaCuentaCredito.length.toString());
      return listaCuentaCredito;
    }
    return null;
  }

  @override
  void dispose() {
    setState(() {
      prueba = false;
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _checkLocationPermission();
    distrito = listaDistritos.first;

    if (global_personal.idcargo!.trim() == '05' || global_personal.idcargo!.trim() == '03' && global_personal.idarea!.trim() != '07') {
      print('Analista');
      _listarCarteraAnalista().then((value) {
        funcionLlenarCombos();
        setState(() {
          prueba = true;
          globalDrawer = true;
          listaCuentaCreditoBan = listaCuentaCredito;
          listaGlobalCuentaCredito = listaCuentaCredito;
          departamento = listaDepartamentos.first;
          for (app_ubigeo d in listaGlobalUbigeo) {
            if (d.descripcion.trim() == departamento && d.nivel.trim() == '3') {
              varDis = d.idubigeo.substring(0, 6);
              funcionLlenarDistrito(varDis);
            }
          }
        });
      });
    } else {
      if (global_personal.cargo!.trim() == 'GESTOR JUDICIAL') {
        if (listaGlobalCuentaCredito.isEmpty) {
          _listarCarteraJu(global_personal.idpersona).then((value) {
            funcionLlenarCombos();
            setState(() {
              prueba = true;
              globalDrawer = true;
              listaCuentaCreditoBan = listaCuentaCredito;
              listaGlobalCuentaCredito = listaCuentaCredito;
              departamento = listaDepartamentos.first;
              for (app_ubigeo d in listaGlobalUbigeo) {
                if (d.descripcion.trim() == departamento &&
                    d.nivel.trim() == '3') {
                  varDis = d.idubigeo.substring(0, 6);
                  funcionLlenarDistrito(varDis);
                }
              }
            });
          });
        } else {
          setState(() {
            prueba = true;
            globalDrawer = true;
            listaCuentaCredito = listaGlobalCuentaCredito;
            listaCuentaCreditoBan = listaGlobalCuentaCredito;
            departamento = listaDepartamentos.first;
            for (app_ubigeo d in listaGlobalUbigeo) {
              if (d.descripcion.trim() == departamento &&
                  d.nivel.trim() == '3') {
                varDis = d.idubigeo.substring(0, 6);
                funcionLlenarDistrito(varDis);
              }
            }
          });
        }
      } else {
        if (listaGlobalCuentaCredito.isEmpty) {
          _listarCartera(global_personal.idpersona).then((value) {
            funcionLlenarCombos();
            setState(() {
              prueba = true;
              globalDrawer = true;
              listaCuentaCreditoBan = listaCuentaCredito;
              listaGlobalCuentaCredito = listaCuentaCredito;
              print(listaGlobalCuentaCredito.length);
              departamento = listaDepartamentos.first;
              for (app_ubigeo d in listaGlobalUbigeo) {
                if (d.descripcion.trim() == departamento &&
                    d.nivel.trim() == '3') {
                  varDis = d.idubigeo.substring(0, 6);
                  funcionLlenarDistrito(varDis);
                }
              }
            });
          });
        } else {
          print('Objetoooo');
          setState(() {
            prueba = true;
            globalDrawer = true;
            listaCuentaCredito = listaGlobalCuentaCredito;
            listaCuentaCreditoBan = listaGlobalCuentaCredito;
            departamento = listaDepartamentos.first;
            for (app_ubigeo d in listaGlobalUbigeo) {
              if (d.descripcion.trim() == departamento &&
                  d.nivel.trim() == '3') {
                varDis = d.idubigeo.substring(0, 6);
                funcionLlenarDistrito(varDis);
              }
            }
          });
        }
      }
    }
  }

  void rollBack() {
    Future.delayed(
      const Duration(milliseconds: 0000),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const drawer_deudor(),
        ),
      ),
    );
  }

  final TextEditingController filter = TextEditingController();
  String opcion = 'no hay nada';

  Widget funcionBoton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FilledButton(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color.fromARGB(255, 0, 157, 255),
        ),
        onPressed: () {
          setState(() {
            for (app_ubigeo d in listaGlobalUbigeo) {
              if (d.descripcion.trim() == distrito.trim()) {
                ubi = d.idubigeo.trim();
                listaCuentaCredito = listaCuentaCreditoBan;
                print(listaCuentaCredito.length);
                listaCuentaCredito = listaCuentaCredito
                    .where((element) =>
                        element.idmaesocios.idubigeodir.trim() == ubi)
                    .toList();
              }
            }
          });
        },
        child: const Padding(
          padding: EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aplicar Filtro',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void actualizarLista(
      bool normal1, bool cpp, bool deficiente, bool perdida, bool dudoso) {
    print('Lista global: ${listaCuentaCreditoBan.length}');
    List<App_cuenta_credito> nueva = listaGlobalCuentaCredito;
    List<App_cuenta_credito> listaNormal = [];
    List<App_cuenta_credito> listaCpp = [];
    List<App_cuenta_credito> listaDeficiente = [];
    List<App_cuenta_credito> listaPerdida = [];
    List<App_cuenta_credito> listaDudoso = [];
    List<App_cuenta_credito> listaTotal = [];
    if (normal1 == true) {
      listaNormal = nueva
          .where((x) => x.idmaesocios.calificacion?.trim() == 'NORMAL')
          .toList();
      listaTotal.addAll(listaNormal);
    }
    if (cpp == true) {
      listaCpp = nueva
          .where((x) => x.idmaesocios.calificacion?.trim() == 'CPP')
          .toList();
      listaTotal.addAll(listaCpp);
    }
    if (deficiente == true) {
      listaDeficiente = nueva
          .where((x) => x.idmaesocios.calificacion?.trim() == 'DEFICIENTE')
          .toList();
      listaTotal.addAll(listaDeficiente);
    }
    if (perdida == true) {
      listaPerdida = nueva
          .where((x) => x.idmaesocios.calificacion?.trim() == 'PERDIDA')
          .toList();
      print('Valor nueva: ${listaCpp.length}');
      listaTotal.addAll(listaPerdida);
    }
    if (dudoso == true) {
      listaDudoso = nueva
          .where((x) => x.idmaesocios.calificacion?.trim() == 'DUDOSO')
          .toList();
      listaTotal.addAll(listaDudoso);
    }
    setState(() {
      prueba = false;
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        listaCuentaCredito = listaTotal;
        listaCuentaCreditoBan = listaCuentaCredito;
        prueba = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        listaCuentaCredito.clear();
                      });
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
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          //automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 2, 128, 6),
          elevation: 25,
          shadowColor: const Color.fromARGB(255, 255, 255, 255),
          title: const FittedBox(
            child: Text(
              'Mi cartera de socios',
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
                  delegate: buscarUsuario(listaGlobalCuentaCredito),
                );
              },
            ),
            PopupMenuButton<String>(
              iconColor: Colors.white,
              elevation: 1,
              color: const Color.fromARGB(255, 255, 255, 255),
              onSelected: selectMenuItem,
              itemBuilder: (context) => [
                menuItem(value: 'Cuotas', icon: Icons.calendar_month_outlined),
                menuItem(value: 'Alfabetico', icon: Icons.abc_sharp),
                menuItem(value: 'Saldo actual', icon: Icons.attach_money),
                menuItem(value: 'Listar todo', icon: Icons.list_alt_sharp),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: claseDrawer(context),
        ),
        //claseDrawer(personal,lista_gestion, context),
        bottomNavigationBar: prueba == true
            ? abriFiltro == false
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    height: 60,
                    width: double.infinity,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 40,
                                ),
                                const Text(
                                  'Filtrar por Departamentos',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        abriFiltro = true;
                                      });
                                    },
                                    icon: const Icon(Icons.touch_app_rounded)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    height: 320,
                    width: double.infinity,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 40,
                                ),
                                const Text(
                                  'Filtrar por Departamentos',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        abriFiltro = false;
                                      });
                                    },
                                    icon: const Icon(Icons.touch_app_outlined)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField(
                            iconEnabledColor:
                                const Color.fromARGB(255, 0, 0, 0),
                            isExpanded: false,
                            value: departamento,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 18),
                              border: OutlineInputBorder(),
                              labelText: 'Departamentos',
                            ),
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                departamento = value!;
                                for (app_ubigeo d in listaGlobalUbigeo) {
                                  if (d.descripcion.trim() == value &&
                                      d.nivel.trim() == '3') {
                                    varDis = d.idubigeo.substring(0, 6);
                                  }
                                }
                                funcionLlenarDistrito(varDis);
                              });
                            },
                            items: listaDepartamentos.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField(
                            isExpanded: false,
                            value: distrito,
                            autofocus: true,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 18),
                              border: OutlineInputBorder(),
                              labelText: 'Distritos',
                            ),
                            onChanged: (value) {
                              setState(() {
                                distrito = value!;
                              });
                            },
                            items: listaDistritos.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        funcionBoton(),
                      ],
                    ),
                  )
            : Container(
                color: Colors.amber,
                child: const LinearProgressIndicator(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  color: Colors.black,
                ),
              ),
        body: Column(
          children: [
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
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 0, 119, 4),
                        onChanged: prueba == false
                            ? null
                            : (bool? value) {
                                setState(() {
                                  normal = value!;
                                  print(listaGlobalCuentaCredito.length);
                                  actualizarLista(
                                      value, cpp, deficiente, perdida, dudoso);
                                });
                              },
                        value: normal,
                      ),
                      const Text('Normal'),
                      // --------------------------------- //
                      const SizedBox(
                        width: 10,
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 0, 119, 4),
                        onChanged: prueba == false
                            ? null
                            : (bool? value) {
                                setState(() {
                                  cpp = value!;
                                  actualizarLista(normal, value, deficiente,
                                      perdida, dudoso);
                                });
                              },
                        value: cpp,
                      ),
                      const Text('Cpp'),
                      // --------------------------------- //
                      const SizedBox(
                        width: 10,
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 0, 119, 4),
                        onChanged: prueba == false
                            ? null
                            : (bool? value) {
                                setState(() {
                                  deficiente = value!;
                                  actualizarLista(
                                      normal, cpp, value, perdida, dudoso);
                                });
                              },
                        value: deficiente,
                      ),
                      const Text('Deficiente'),
                      // --------------------------------- //
                      const SizedBox(
                        width: 10,
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 0, 119, 4),
                        onChanged: prueba == false
                            ? null
                            : (bool? value) {
                                setState(() {
                                  perdida = value!;
                                  actualizarLista(
                                      normal, cpp, deficiente, value, dudoso);
                                });
                              },
                        value: perdida,
                      ),
                      const Text('Perdida'),
                      // --------------------------------- //
                      const SizedBox(
                        width: 10,
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 0, 119, 4),
                        onChanged: prueba == false
                            ? null
                            : (bool? value) {
                                setState(() {
                                  dudoso = value!;
                                  actualizarLista(
                                      normal, cpp, deficiente, perdida, value);
                                });
                              },
                        value: dudoso,
                      ),
                      const Text('Dudoso'),
                      // --------------------------------- //
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            prueba == true
                ? Expanded(
                    child: ListView.builder(
                        itemCount: listaCuentaCredito.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: listaCuentaCredito.isEmpty
                                  ? const Center()
                                  : listaContenido(listaCuentaCredito[index]),
                            ),
                          );
                        }))
                : const Center(
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
                  )),
          ],
        ),
        floatingActionButton: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: Colors.grey,
          color: const Color.fromARGB(153, 235, 208, 2),
          child: Text(
            'Cantidad de socios: ${listaCuentaCredito.length}',
            style: const TextStyle(
                color: Color.fromARGB(203, 6, 6, 6),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  PopupMenuItem<String> menuItem({required String value, IconData? icon}) {
    return PopupMenuItem(
      height: 30,
      textStyle: const TextStyle(color: Colors.blue),
      value: value,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
            const SizedBox(
              width: 10,
            ),
            Text(value,
                style: const TextStyle(
                    color: Color.fromARGB(255, 114, 114, 114), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void selectMenuItem(String value) {
    switch (value) {
      case 'Cuotas':
        opcion = value;
        if (Condicion_global == true) {
          setState(() {
            prueba = false;
            print('Entro aqui');
            Future.delayed(const Duration(milliseconds: 250), () {
              listaCuentaCredito.sort((b, a) {
                return a.detalle_cuenta_credito!.cvencidas
                    .compareTo(b.detalle_cuenta_credito!.cvencidas);
              });
              setState(() {
                prueba = true;
              });
            });
            print(listaCuentaCredito.length);
            Condicion_global = false;
          });
        } else {
          setState(() {
            prueba = false;
            Future.delayed(const Duration(milliseconds: 250), () {
              listaCuentaCredito.sort((a, b) {
                return a.detalle_cuenta_credito!.cvencidas
                    .compareTo(b.detalle_cuenta_credito!.cvencidas);
              });
              setState(() {
                prueba = true;
              });
            });

            Condicion_global = true;
          });
        }
        break;
      case 'Alfabetico':
        opcion = value;
        if (Condicion_global == true) {
          setState(() {
            prueba = false;
            print('Entro aqui');
            Future.delayed(const Duration(milliseconds: 250), () {
              listaCuentaCredito.sort((a, b) {
                return a.idmaesocios.socio
                    .toLowerCase()
                    .compareTo(b.idmaesocios.socio.toLowerCase());
              });
              setState(() {
                prueba = true;
              });
            });

            Condicion_global = false;
          });
        } else {
          setState(() {
            prueba = false;
            print('Entro aqui');
            Future.delayed(const Duration(milliseconds: 250), () {
              listaCuentaCredito.sort((b, a) {
                return a.idmaesocios.socio
                    .toLowerCase()
                    .compareTo(b.idmaesocios.socio.toLowerCase());
              });
              setState(() {
                prueba = true;
              });
            });

            Condicion_global = true;
          });
        }

        break;
      case 'Saldo actual':
        opcion = value;
        if (Condicion_global == true) {
          setState(() {
            prueba = false;
            print('Entro aqui');
            Future.delayed(const Duration(milliseconds: 250), () {
              listaCuentaCredito.sort((b, a) {
                return a.saldo!.compareTo(b.saldo!);
              });
              setState(() {
                prueba = true;
              });
            });

            Condicion_global = false;
          });
        } else {
          setState(() {
            prueba = false;
            print('Entro aqui');
            Future.delayed(const Duration(milliseconds: 250), () {
              listaCuentaCredito.sort((a, b) {
                return a.saldo!.compareTo(b.saldo!);
              });
              setState(() {
                prueba = true;
              });
            });

            Condicion_global = true;
          });
        }

        break;
      case 'Normal':
        setState(() {
          listaCuentaCredito = listaCuentaCreditoBan;
          listaCuentaCredito = listaCuentaCredito
              .where((element) =>
                  element.idmaesocios.calificacion.toString().trim() ==
                  'NORMAL')
              .toList();
        });
        break;
      case 'Cpp':
        setState(() {
          listaCuentaCredito = listaCuentaCreditoBan;
          listaCuentaCredito = listaCuentaCredito
              .where((element) =>
                  element.idmaesocios.calificacion.toString().trim() == 'CPP')
              .toList();
        });
        break;
      case 'Deficiente':
        setState(() {
          listaCuentaCredito = listaCuentaCreditoBan;
          listaCuentaCredito = listaCuentaCredito
              .where((element) =>
                  element.idmaesocios.calificacion.toString().trim() ==
                  'DEFICIENTE')
              .toList();
        });
        break;
      case 'Dudoso':
        setState(() {
          listaCuentaCredito = listaCuentaCreditoBan;
          listaCuentaCredito = listaCuentaCredito
              .where((element) =>
                  element.idmaesocios.calificacion.toString().trim() ==
                  'DUDOSO')
              .toList();
        });
        break;
      case 'Perdida':
        setState(() {
          listaCuentaCredito = listaCuentaCreditoBan;
          listaCuentaCredito = listaCuentaCredito
              .where((element) =>
                  element.idmaesocios.calificacion.toString().trim() ==
                  'PERDIDA')
              .toList();
        });
        break;
      case 'Listar todo':
        setState(() {
          listaCuentaCredito = listaGlobalCuentaCredito;
        });
        break;
    }
  }
}

class listaContenido extends StatefulWidget {
  App_cuenta_credito app_cuenta;
  listaContenido(this.app_cuenta, {super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _StafelistaContenido createState() => _StafelistaContenido(app_cuenta);
}

class _StafelistaContenido extends State<listaContenido> {
  App_cuenta_credito app_cuenta;
  _StafelistaContenido(this.app_cuenta);

  bool pres = false;
  @override
  Widget build(BuildContext context) {
    int m = listaMoroVisitas
        .where((x) =>
            x.nrodocp == app_cuenta.nrodocpagare &&
            x.idagenciap!.idagencia == app_cuenta.idagenciacta)
        .toList()
        .length;
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 199, 198, 198).withOpacity(0.5),
              spreadRadius: 0.3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: const Color.fromARGB(255, 231, 231, 231))),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: SingleChildScrollView(
          child: ClipRect(
            child: ExpansionPanelList(
              expandIconColor: const Color.fromARGB(255, 0, 111, 4),
              elevation: 1,
              expandedHeaderPadding: const EdgeInsets.all(0),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  pres = isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListBody(
                            children: [
                              Text(
                                '${app_cuenta.idmaesocios.socio.toString()} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              Text(
                                'CAL.SBS: ${app_cuenta.idmaesocios.calificacion!.trim()} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(154, 161, 39, 39)),
                              ),
                              Text(
                                'IDSocio: ${app_cuenta.idmaesocios.idsocio} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(112, 0, 19, 229)),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'N° pagaré: ${app_cuenta.nrodocpagare} ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromARGB(112, 0, 19, 229)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'V: $m ',   
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    formulario_deudor(app_cuenta)),
                          );
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CameraApp()),
                          );*/
                        },
                      );
                    },
                    body: ListTile(
                        title: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListBody(
                        children: [
                          Text(
                            'DNI: ${app_cuenta.idmaesocios.nrodocumento} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromARGB(255, 137, 137, 137)),
                          ),
                          Text(
                            '${app_cuenta.denominacion} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromARGB(255, 137, 137, 137)),
                          ),
                          Text(
                            'Estado: ${app_cuenta.idestadodoc.estado} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromARGB(255, 137, 137, 137)),
                          ),
                          Text(
                            'Monto desenbolsado: ${app_cuenta.monto_aprobado} ',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'Plazo: ${app_cuenta.plazo_apro} ',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'Saldo actual: ${app_cuenta.saldo} ',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          Text(
                            'N° Cuotas vencidas: ${app_cuenta.detalle_cuenta_credito!.cvencidas} ',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ],
                      ),
                    )),
                    isExpanded: pres),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
