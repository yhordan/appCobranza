// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, no_logic_in_create_state, body_might_complete_normally_nullable, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_cuotas_convenio.dart';
import 'package:app_leon_xiii/models/app_cuotas_credito.dart';
import 'package:app_leon_xiii/models/cuotas_vencidas.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pantalla_cuotas extends StatefulWidget {
  String tipoMoneda = '';
  String numDocumento = '';
  String idAgencia = '';
  String idPagare = '';
  String? convextra;
  String? convjud;

  Pantalla_cuotas(this.tipoMoneda, this.numDocumento, this.idAgencia,
      this.idPagare, this.convextra, this.convjud,
      {super.key});
  final List<Cuotas_vencidas> cuotas_vencidas = [];

  @override
  State<Pantalla_cuotas> createState() => _formularioState(
      tipoMoneda, numDocumento, idAgencia, idPagare, convextra, convjud);
}

class _formularioState extends State<Pantalla_cuotas> {
  String tipoMoneda = '';
  String numDocumento = '';
  String idAgencia = '';
  String idPagare = '';
  String? convextra;
  String? convjud;
  int? numPantalla = 0;
  List<app_cuotas_credito> cuotas = [];
  List<app_cuotas_convenio> cuotasCon = [];
  _formularioState(this.tipoMoneda, this.numDocumento, this.idAgencia,
      this.idPagare, this.convextra, this.convjud);
  String pagare = '';
  List<bool> listaBool = [];
  double saldo = 0.0;
  double pAmortiza = 0.0;
  double pIntereses = 0.0;
  double pIntMora = 0.0;
  double pGastos = 0.0;
  double pDesgravamen = 0.0;
  int sel = 0;

  http.Client? client;
  bool accesoInternet = true;

  Future<List<Cuotas_vencidas>?> _listarCartera() async {
    int intentos = 0;
    int maxIntentos = 1;
    while (intentos < maxIntentos) {
      try {
        client = http.Client();

        var url = Uri.parse(
            '${Url_serv}api/app_cuotas_credito/buscar_cuotas/$tipoMoneda/$numDocumento/$idAgencia/$idPagare');

        final response = await client!.post(url, headers: {
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
          //cuotas_vencidas.clear();
          //List<Cartera_Atrasada> carteras = [];

          //print(response.body);
          String body = utf8.decode(response.bodyBytes);

          final jsonData = jsonDecode(body);

          //print(response.body[1]);
          //print(jsonData.length);
          for (var item in jsonData) {
            var body = item;
            app_cuotas_credito cartera = app_cuotas_credito.fromJson(body);
            cuotas.add(cartera);
          }
          print('cuotas:' + cuotas.length.toString());
          //return cuotas_vencidas;
        }
      } catch (e) {
        print('Error de conexión: $e');
      } finally {
        client?.close();
      }
      print('Número de intento: $intentos');
      intentos++;
      await Future.delayed(const Duration(seconds: 2));
    }
    accesoInternet = false;
    print('Se superó el límite de intentos normal');
    return null;
  }

  Future<dynamic> _listarCarteraConvenio() async {
    int intentos = 0;
    int maxIntentos = 1;
    while (intentos < maxIntentos) {
      try {
        client = http.Client();

        var url = Uri.parse(
            '${Url_serv}api/app_cuotas_convenio/buscar_cuotas_convenio/$tipoMoneda/$numDocumento/$idAgencia/$idPagare');

        final response = await client!.post(url, headers: {
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
            app_cuotas_convenio cartera = app_cuotas_convenio.fromJson(body);
            cuotasCon.add(cartera);
          }
          print('cuotas:' + cuotas.length.toString());
          //return cuotas_vencidas;
        }
      } catch (e) {
        print('Error de conexión: $e');
      } finally {
        client?.close();
      }
      print('Número de intento: $intentos');
      intentos++;
      await Future.delayed(const Duration(seconds: 2));
    }
    accesoInternet = false;
    print('Se superó el límite de intentos convenio');
    return null;
  }

  List<String> lista = [
    ' N° ',
    'Fecha de vencimiento',
    'Dias de atraso',
    'Saldo deudor',
    'Saldo cuota',
    'Saldo Mora'
  ];

  bool prueba = false;
  @override
  void dispose() {
    client?.close();
    super.dispose();
  }

  @override
  void initState() {
    //client = http.Client();
    super.initState();
    int i = 0;
    if (convjud == '0' && convextra == '0') {
      print('Normal uotas');
      _listarCartera().then((value) {
        print(Valor);
        if (mounted) {
          setState(() {
            while (i <= listaGlobalCuentaCredito.length) {
              listaBool.add(false);
              i++;
            }
            prueba = true;
            numPantalla = 0;
          });
        }
      });
    } else {
      print('Normal convenio');
      _listarCarteraConvenio().then((value) {
        print(Valor);
        if (mounted) {
          setState(() {
            while (i <= listaGlobalCuentaCredito.length) {
              listaBool.add(false);
              i++;
            }
            prueba = true;
            numPantalla = 1;
          });
        }
      });
    }
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Total ($sel items)',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 251, 0, 0),
            ),
          ),
          content: ListBody(children: [
            const Divider(
              color: Color.fromARGB(255, 0, 0, 0),
              thickness: 1,
            ),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amortización',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Intereses',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Int. Moratorio',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Gastos',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Desgravamen',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Total',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 57, 149, 0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 60,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pAmortiza.abs().toStringAsFixed(2),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      pIntereses.abs().toStringAsFixed(2),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      pIntMora.abs().toStringAsFixed(2),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      pGastos.abs().toStringAsFixed(2),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      pDesgravamen.abs().toStringAsFixed(2),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 51, 94),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      saldo.abs().toStringAsFixed(2),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 57, 149, 0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ]),
          actions: [
            TextButton(
              child: const Text(
                "Aceptar",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    cuotas.sort((a, b) {
      return a.nrocuota.compareTo(b.nrocuota);
    });

    return numPantalla == 0 ? pantallaNormal() : pantallaConvenio();
  }

  Widget pantallaNormal() {
    return Scaffold(
      bottomSheet: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 142, 53, 53),
        ),
        onPressed: () {
          showPopup(context);
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 142, 53, 53),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Saldo: S/.${saldo.toStringAsFixed(2)} ($sel items)',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Cuotas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 25,
          ),
          tooltip: 'Close',
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 140, 35),
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
          : ListView.separated(
              itemCount: cuotas.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color.fromARGB(255, 215, 213, 213),
              ),
              itemBuilder: (_, index) {
                DateTime hoy = DateTime.now();
                DateTime fec = DateTime.parse(cuotas[index].fecven.toString());
                Color colorFecha = Colors.black;
                if (fec.isBefore(hoy)) {
                  //print('Mi fecha:' + fec.toString());
                  colorFecha = const Color.fromARGB(255, 146, 10, 0);
                }
                double gastos = cuotas[index].interesvenc;

                double montoCuota = cuotas[index].amortiza +
                    cuotas[index].desgravamen +
                    cuotas[index].interes;
                double total = cuotas[index].amortiza +
                    cuotas[index].interes +
                    cuotas[index].desgravamen +
                    cuotas[index].interesmora +
                    cuotas[index].interesvenc;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text(
                              'Cuota número ${cuotas[index].nrocuota}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 251, 0, 0),
                              ),
                            ),
                            content: ListBody(children: [
                              const Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 1,
                              ),
                              Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Amortización',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Intereses',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Int. Moratorio',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Gastos',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Desgravamen',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Total',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 57, 149, 0),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 60,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        cuotas[index]
                                            .amortiza
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotas[index]
                                            .interes
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotas[index]
                                            .interesmora
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        gastos.abs().toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotas[index]
                                            .desgravamen
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        total.abs().toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 57, 149, 0),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                            actions: [
                              TextButton(
                                child: const Text(
                                  "Aceptar",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: ListTile(
                        trailing: Checkbox(
                          value: listaBool[index],
                          onChanged: (bool? value) {
                            setState(() {
                              listaBool[index] = value!;
                              if (value == true) {
                                saldo = saldo + total;
                                pGastos = pGastos + gastos;
                                pAmortiza = pAmortiza + cuotas[index].amortiza;
                                pIntereses = pIntereses + cuotas[index].interes;
                                pIntMora = pIntMora + cuotas[index].interesmora;
                                pDesgravamen =
                                    pDesgravamen + cuotas[index].desgravamen;
                                sel = sel + 1;
                              } else {
                                saldo = saldo - total;
                                pGastos = pGastos - gastos;
                                pAmortiza = pAmortiza - cuotas[index].amortiza;
                                pIntereses = pIntereses - cuotas[index].interes;
                                pIntMora = pIntMora - cuotas[index].interesmora;
                                pDesgravamen =
                                    pDesgravamen - cuotas[index].desgravamen;
                                sel = sel - 1;
                              }
                            });
                          },
                        ),
                        title: ListBody(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Pagaré: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  numDocumento,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 222, 44, 0),
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Monto cuota: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  montoCuota.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 27, 0, 96)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'F. vencimiento:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  cuotas[index].fecven.substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 27, 0, 96)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Total: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  total.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 27, 0, 96)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: Text(
                          cuotas[index].nrocuota,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: colorFecha,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget pantallaConvenio() {
    return Scaffold(
      bottomSheet: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 142, 53, 53),
        ),
        onPressed: () {
          showPopup(context);
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 142, 53, 53),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Saldo: S/.${saldo.toStringAsFixed(2)} ($sel items)',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Cuotas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 25,
          ),
          tooltip: 'Close',
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 140, 35),
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
          : ListView.separated(
              itemCount: cuotasCon.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color.fromARGB(255, 215, 213, 213),
              ),
              itemBuilder: (_, index) {
                DateTime hoy = DateTime.now();
                DateTime fec =
                    DateTime.parse(cuotasCon[index].fecven.toString());
                Color colorFecha = Colors.black;
                if (fec.isBefore(hoy)) {
                  //print('Mi fecha:' + fec.toString());
                  colorFecha = const Color.fromARGB(255, 146, 10, 0);
                }
                double gastos = cuotasCon[index].interesvencconv;

                double montoCuota = cuotasCon[index].amortiza +
                    cuotasCon[index].desgravamen +
                    cuotasCon[index].interes;
                double total = cuotasCon[index].amortiza +
                    cuotasCon[index].interes +
                    cuotasCon[index].desgravamen +
                    cuotasCon[index].interesmoraconv +
                    cuotasCon[index].interesvencconv;

                double amortizacion = cuotasCon[index].amortiza +
                    cuotasCon[index].interes +
                    cuotasCon[index].desgravamen +
                    cuotasCon[index].intmoratorio +
                    cuotasCon[index].intvencido +
                    0.0;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text(
                              'Cuota número ${cuotasCon[index].nrocuota}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 251, 0, 0),
                              ),
                            ),
                            content: ListBody(children: [
                              const Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 1,
                              ),
                              Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Amortización',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Intereses',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Int. Moratorio',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Int. Vencido',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Gastos',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Desgravamen',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Total',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 57, 149, 0),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 60,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        amortizacion.toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotasCon[index]
                                            .interes
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotasCon[index]
                                            .interesmoraconv
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotasCon[index]
                                            .interesvencconv
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotasCon[index]
                                            .gastos // verificar con luperty
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        cuotasCon[index]
                                            .desgravamen
                                            .abs()
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 51, 94),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        total.abs().toStringAsFixed(2),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 57, 149, 0),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                            actions: [
                              TextButton(
                                child: const Text(
                                  "Aceptar",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: ListTile(
                        trailing: Checkbox(
                          value: listaBool[index],
                          onChanged: (bool? value) {
                            setState(() {
                              listaBool[index] = value!;
                              if (value == true) {
                                saldo = saldo + total;
                                pGastos = pGastos + gastos;
                                pAmortiza = pAmortiza + amortizacion;
                                pIntereses =
                                    pIntereses + cuotasCon[index].interes;
                                pIntMora =
                                    pIntMora + cuotasCon[index].interesmoraconv;
                                pDesgravamen =
                                    pDesgravamen + cuotasCon[index].desgravamen;
                                sel = sel + 1;
                              } else {
                                saldo = saldo - total;
                                pGastos = pGastos - gastos;
                                pAmortiza = pAmortiza - amortizacion;
                                pIntereses =
                                    pIntereses - cuotasCon[index].interes;
                                pIntMora =
                                    pIntMora - cuotasCon[index].interesmoraconv;
                                pDesgravamen =
                                    pDesgravamen - cuotasCon[index].desgravamen;
                                sel = sel - 1;
                              }
                            });
                          },
                        ),
                        title: ListBody(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'N° convenio: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  cuotasCon[index].nrodocconv,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 222, 44, 0),
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Monto cuota: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  montoCuota.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 27, 0, 96)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'F. vencimiento:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  cuotasCon[index].fecven.substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 27, 0, 96)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Total: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  total.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 27, 0, 96)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: Text(
                          cuotasCon[index].nrocuota,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: colorFecha,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
