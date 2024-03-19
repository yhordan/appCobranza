// ignore_for_file: unused_field, avoid_print, use_build_context_synchronously, unused_element, constant_identifier_names, non_constant_identifier_names, camel_case_types, must_be_immutable, no_logic_in_create_state, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:typed_data';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/pages/pantalla_visitas.dart';
import 'package:app_leon_xiii/models/app_cuenta_credito.dart';
import 'package:app_leon_xiii/models/app_fiador.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';
import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/models/cuotas_vencidas.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pages/pantalla_cuotas.dart';
import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:connectivity/connectivity.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:quiver/async.dart';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart' as stt;

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoieWhvcmRhbjE3IiwiYSI6ImNsbm5xdmlhMjA3cjEyc3FqZmZzN29rMXEifQ.8Y7VwtJkrqW2shDTR7PtrQ';
final MyPosition = LatLng(40.697488, -73.979681);

class formulario_deudor extends StatefulWidget {
  late Map<dynamic, dynamic> json;

  App_cuenta_credito usuario;

  formulario_deudor(this.usuario, {super.key});

  @override
  State<formulario_deudor> createState() => _formularioState(usuario);
}

class _formularioState extends State<formulario_deudor> {
  TextEditingController dateInput = TextEditingController();

  Personal personal = global_personal;
  App_cuenta_credito usuario;
  String codigoSocio = '';
  List<Cartera_Atrasada> lista_Cartera = [];
  int ban = 0;
  String initial = '';
  _formularioState(
    this.usuario,
  );

  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text = '';
  TextEditingController obser = TextEditingController();

  String resultText = '';
  DateTime horaInicio = DateTime.now();

  late final CountdownTimer _countdownTimer;
  int _elapsedSeconds = 0;
  int minutos = 0;

  @override
  void initState() {
    client = http.Client();
    dateInput.text = ""; //set the initial value of text field
    _speech = stt.SpeechToText();
    setState(() {
      horaInicio = DateTime.now();
    });
    _countdownTimer = CountdownTimer(
      const Duration(
          minutes: 9999999), // Ajusta el lÃ­mite segÃºn tus necesidades
      const Duration(seconds: 1),
    )..listen((timer) {
        setState(() {
          minutos = timer.elapsed.inMinutes;
          _elapsedSeconds = timer.elapsed.inSeconds % 60;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    client?.close();
    _countdownTimer.cancel();
    super.dispose();
  }

  int currentStep = 0;

  continueStep() {
    if (currentStep < 1) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        currentStep == 1
            ? const Center()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 92, 41),
                ),
                onPressed: details.onStepContinue,
                child: Text(
                  'Siguiente',
                  style: TextStyle(
                      fontSize: num / 45,
                      color: const Color.fromARGB(255, 254, 254, 254)),
                ),
              ),
        currentStep == 0
            ? const Center()
            : OutlinedButton(
                onPressed: details.onStepCancel,
                child: Text(
                  'Atrás',
                  style: TextStyle(
                    fontSize: num / 45,
                    color: const Color.fromARGB(255, 40, 92, 41),
                  ),
                ),
              )
      ],
    );
  }

  String latitud = '';
  String longitud = '';
  bool isGpsEnabled = true;

  Future<void> checkLocationService() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      setState(() {
        isGpsEnabled = true;
      });
    } else {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          isGpsEnabled = false;
        });
        showLocationDialog();
      }
    }
  }

  Future<void> showLocationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Activar GPS'),
          content: const Text('Por favor, activa tu GPS para continuar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Activar GPS'),
            ),
          ],
        );
      },
    );
  }

  Future<void> mensajeDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ocurrio un Problema, intente de nuevo!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

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

  // ignore: prefer_typing_uninitialized_variables
  var pickedFile;
  File? imagen;
  String base6445 = '';
  final picker = ImagePicker();
  Future selImagen() async {
    pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imagen = File(pickedFile.path);
      });

      List<int> fileBytes = await imagen!.readAsBytes();

      img.Image? imagen2 = img.decodeImage(Uint8List.fromList(fileBytes));

      img.Image imagenComprimida = img.copyResize(imagen2!,
          width: imagen2.width,
          height: imagen2.height,
          interpolation: img.Interpolation.linear);
      Uint8List imagenBytes =
          Uint8List.fromList(img.encodeJpg(imagenComprimida, quality: 40));

      setState(() {
        base6445 = base64Encode(imagenBytes);
      });
    }
  }

  Future<Position> getCurrentLocation() async {
    Position position = await determinarPosition();
    //Imprimiendo coordenadas
    latitud = position.latitude.toString();
    longitud = position.longitude.toString();
    return position;
  }

  final moonLanding = DateTime.now();
  final List<Cuotas_vencidas> cuotas_vencidas = [];
  var va = Url_serv;

  TextEditingController socioGestion = TextEditingController();
  TextEditingController motivoAtrasoGestion = TextEditingController();
  TextEditingController resultadoGestion = TextEditingController();
  TextEditingController estadoCivilGestion = TextEditingController();
  TextEditingController personaAtendioGestion = TextEditingController();
  TextEditingController correoGestion = TextEditingController();
  TextEditingController celarGestion = TextEditingController();
  TextEditingController estadoGestion = TextEditingController();
  TextEditingController compromisoPagoGestion = TextEditingController();
  TextEditingController direccionGestion = TextEditingController();
  TextEditingController observacionesGestion = TextEditingController();
  String fecha = DateFormat('yyyy-MM-ddTHH:mm:00.000').format(DateTime.now());
  bool accesoInternet = true;

  Widget cargarImagen() {
    Future.delayed(
        const Duration(milliseconds: 10000),
        () => const Column(
              children: [
                SizedBox(
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    semanticsLabel: 'Circular progress indicator',
                    color: Color.fromARGB(255, 30, 103, 33),
                  ),
                ),
                Center(
                  child: Text('Cargando imagen ..'),
                ),
              ],
            ));
    return Column(
      children: [
        Image.file(imagen!),
      ],
    );
  }

  String obtenerFecha() {
    DateTime fechaNuveas = DateTime.parse(DateTime.now().toString());
    String fecha = DateFormat('yyyy-MM-dd / h:m a').format(fechaNuveas);
    return fecha;
  }

  void confimarAccion() {
    _checkInternetConnection(context).then((value) {
      if (conexionInternet == true) {
        _crearGestion();
      } else {
        _showNoInternetDialog(context);
      }
    });
  }

  http.Client? client;
  Future<dynamic> _crearGestion() async {
    int intentos = 0;
    int maxIntentos = 3;
    while (intentos < maxIntentos) {
      try {
        // ignore: avoid_init_to_null
        String? fechaNueva = null;
        if (dateInput.text != '') {
          fechaNueva = '${dateInput.text}T00:00:00.000';
        }

        String? fechaRegistro =
            DateFormat('yyyy-MM-ddTHH:mm:ss.00').format(DateTime.now());
        String? fechaVisita =
            DateFormat('yyyy-MM-ddT00:00:00.00').format(DateTime.now());
        String? horaFin =
            '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
        String? horaIni =
            '${horaInicio.hour}:${horaInicio.minute}:${horaInicio.second}';

        String resultado = '';
        String motivo = '';
        String personA = '';
        String estad = '';
        for (Persona_atendio p in personaAtendio3) {
          if (p.descripcion.trim() == personaAtendioGestion.text.trim()) {
            personA = p.codigo;
          }
        }
        for (Persona_atendio p in resultado1) {
          if (p.descripcion.trim() == resultadoGestion.text.trim()) {
            resultado = p.codigo;
          }
        }
        for (Persona_atendio p in motivoAtraso2) {
          if (p.descripcion.trim() == motivoAtrasoGestion.text.trim()) {
            motivo = p.codigo;
          } else if (motivoAtrasoGestion.text == '') {
            motivo = motivoAtraso2.first.codigo;
          }
        }
        for (Persona_atendio p in estad3) {
          if (p.descripcion.trim() == estadoGestion.text.trim()) {
            estad = p.codigo;
          }
        }
        print("Valors -- >" + estad);
        print("Valors -- >" + motivo);
        print("Valors -- >" + resultado);
        print("Valors -- >" + personA);

        var url = Uri.parse('${va}api/moroso/crear_visita');
        var body = jsonEncode({
          "morosos": {
            "idmoroso":
                '${usuario.idagenciapagare}${usuario.iddocpagare}${usuario.tipomoneda}${usuario.nrodocpagare}${usuario.detalle_cuenta_credito!.primeracuotamorosa}', // numero cuota + idDoc + numDoc + idAgenciaP + tipoMonedaP
            "nromoroso":
                usuario.detalle_cuenta_credito!.primeracuotamorosa, //lo mismo *
            "iddocp": usuario.iddocpagare,
            "nrodocp": usuario.nrodocpagare,
            "idagenciap": {'idagencia': usuario.idagenciapagare},
            "idanalista": usuario.idanalista,
            "idestcuomor": "01",
            "idpersona": usuario.idpersona,
            "nrocuota":
                usuario.detalle_cuenta_credito!.primeracuotamorosa, //lo mismo *
            "montoaprobado": usuario.monto_aprobado,
            "tipomonedap": usuario.tipomoneda,
            "saldo": usuario.saldo,
            "amortizacion": usuario.saldo,
            "tasainteres": usuario.tasainteres,
            "totalcuotas": usuario.plazo_apro,
            "cpagadas": usuario.detalle_cuenta_credito!.cpagadas,
            "cpendientes": usuario.detalle_cuenta_credito!.cpendientes,
            "cvencidas": usuario.detalle_cuenta_credito!.cvencidas,
            "capagar":
                usuario.detalle_cuenta_credito!.primeracuotamorosa, //lo mismo *
            "fechapagar": usuario.detalle_cuenta_credito!.feccuotamorosa,
            "diasatrazo": usuario.detalle_cuenta_credito!.diasmorosidad,
            "diasmorosidad": usuario.detalle_cuenta_credito!.diasmorosidad,
            "fechadesembolso": usuario.fecdesembolso,
            "fechaultpagointeres":
                usuario.detalle_cuenta_credito!.fecultpagointeres,
            "montoalafecha": usuario.detalle_cuenta_credito!.montoalafecha,
            "estadoprestamo": usuario.idestadodoc.idestadodoc,
            "fechar": fechaRegistro,
            "iduserr": global_personal.iduser,
            "idsocio": usuario.idmaesocios.idsocio,
            "socio": usuario.idmaesocios.socio,
            "userasignado": '1',
            "gestorasignado": global_personal.idpersona,
          },
          "morosovisitas": {
            "idmorosovisita":
                "${usuario.idagenciapagare}${usuario.iddocpagare}${usuario.tipomoneda}${usuario.nrodocpagare}${usuario.detalle_cuenta_credito!.primeracuotamorosa}",
            "nrovisita": "1",
            "nromoroso": usuario.detalle_cuenta_credito!.primeracuotamorosa,
            "iddocp": usuario.iddocpagare,
            "nrodocp": usuario.nrodocpagare,
            "idagenciap": {"idagencia": usuario.idagenciapagare},
            "tipomonedap": usuario.tipomoneda,
            "idresultadovisita": resultado,
            "idmorovisiestado": estad,
            "idmotatra": motivo,
            "personaatendio": {"idtabla": personA},
            "idgestor": global_personal.idpersona,
            "fecvisita": fechaVisita, //Carlos
            "direccion": usuario.idmaesocios.direccion,
            "comentario": obser.text.toString(),
            "compromisopago": "a",
            "montocompromiso": 200,
            "fechacompromiso": fechaNueva,
            "horaini": horaIni.trim(), //carlos
            "horafin": horaFin.trim(), //carlos
            "fechar": fechaRegistro, //carlos
            "iduserr": global_personal.iduser,
            "idevalsbsalineado": usuario.idevalsbs.toString(),
            "geolocalizacion_latitud": latitud,
            "geolocalizacion_longitud": longitud,
            "foto": base6445,
            "idsocio": usuario.idmaesocios.idsocio,
          },
        });
        print('lat: $latitud');
        print('lon: $longitud');
        print(horaIni);
        print(horaFin);
        print(horaIni.length);
        print(horaFin.length);

        final response = await client!.post(url, body: body, headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $Token_valor"
        });

        //var dataPerson = json.decode(response.body);
        //print(response.statusCode);
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
          var body = response.body;
          app_morosovisitas? gestionG =
              app_morosovisitas.fromJson(jsonDecode(body));
          //gestionG = null;

          if (gestionG != null) {
            setState(() {
              estadoBoton = true;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const drawer_visitas()),
              );
            });
            print(gestionG.comentario);
          } else {
            setState(() {
              estadoBoton = true;
            });
            mensajeDialog();
          }

          /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const drawer_visitas()),
      );*/
          return gestionG;
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
    print('Se superó el límite de intentos');
    return null;
  }

  bool conexionInternet = false;

  Future<bool> _checkInternetConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        conexionInternet = false;
      });
      _showNoInternetDialog(context);
    } else {
      setState(() {
        conexionInternet = true;
      });
    }

    return conexionInternet;
  }

  void _showNoInternetDialog(BuildContext context) {
    setState(() {
      estadoBoton = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sin conexión'),
          content: const Text('La señal de Internet se ha perdido.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double anchoPantalla = MediaQuery.of(context).size.width;
    List<String> resultado = [];
    for (Persona_atendio p in resultado1) {
      resultado.add(p.descripcion);
    }
    List<String> motivoAtraso = [];
    for (Persona_atendio p in motivoAtraso2) {
      motivoAtraso.add(p.descripcion);
    }
    List<String> personaAtendio = [];
    for (Persona_atendio p in personaAtendio3) {
      personaAtendio.add(p.descripcion);
    }

    List<String> estado = [];
    for (Persona_atendio p in estad3) {
      estado.add(p.descripcion);
    }

    List<String> estadoCivil = [
      'Soltero (a)',
      'Casado (a)',
      'Viudo (a)',
      'Divorciado (a)',
      'Conviviente'
    ];

    final size = MediaQuery.of(context).size;
    double num = size.height;
    String? nombreAval = 'Falta jalar Avala';
    String? dniAval = 'Falta jalar dni aval';
    return metodoRegistro(
        context,
        num,
        nombreAval,
        dniAval,
        fecha,
        motivoAtraso,
        resultado,
        personaAtendio,
        estado,
        estadoCivil,
        anchoPantalla);
  }

  final Map<String, HighlightedWord> _highlights = {
    'socio': HighlightedWord(
      onTap: () => print('SOCIO'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'cobranza': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'atendió': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  Scaffold metodoRegistro(
      BuildContext context,
      double num,
      String nombreAval,
      String dniAval,
      String fecha,
      List<String> motivoAtraso,
      List<String> resultado,
      List<String> personaAtendio,
      List<String> estado,
      List<String> estadoCivil,
      double anchoPantalla) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 15,
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        title: FittedBox(
          child: Column(
            children: [
              const Text(
                'Registro de gestión de clientes',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                'Duración de visita ${minutos}m : ${_elapsedSeconds}s',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color.fromARGB(255, 237, 21, 5),
                  fontWeight: FontWeight.w600,
                ),
              ),

              /*Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 204, 101, 101),
                ),
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tiempo: $minutes m:$seconds s',
                        style: const TextStyle(fontSize: 15,color: Colors.white),
                      ),
                    ),
                  ),
              ),*/
            ],
          ),
        ),
      ),
      body: Stepper(
        physics: const ClampingScrollPhysics(),
        elevation: 5,
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepContinue: continueStep,
        onStepCancel: cancelStep,
        onStepTapped: onStepTapped,
        controlsBuilder: controlsBuilder,
        steps: [
          Step(
            title: const Text(
              'Paso 1',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            content: ListBody(
              children: [
                Center(
                    child: Text(
                  'DATOS DEL SOCIO',
                  style: TextStyle(
                    fontSize: num / 40,
                    color: const Color.fromARGB(255, 51, 51, 51),
                  ),
                )),
                Container(height: num / 50),
                titulo('Nombre del socio'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.idmaesocios.socio.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Número de documento'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.idmaesocios.nrodocumento.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Dirección de domicilio'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.idmaesocios.direccion.toString(), num),
                /*const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Dirección N°1'),
                const SizedBox(
                  height: 3,
                ),
                contenido('-', num
                    /*usuario.direccion_alternativa1 == null
                          ? '-'
                          : usuario.direccion_alternativa1.toString(),
                      num*/
                    ),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Dirección N°2'),
                const SizedBox(
                  height: 3,
                ),
                contenido('-', num
                    /*usuario.direccion_alternativa2 == null
                          ? '-'
                          : usuario.direccion_alternativa2.toString(),
                      num*/
                    ),*/
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Referencia Domiciliaria'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.idmaesocios == null
                        ? '-'
                        : usuario.idmaesocios.referencia!,
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Celular N°1'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.idmaesocios.celular1 == null
                        ? '-'
                        : usuario.idmaesocios.celular1.toString(),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Celular N°2'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.idmaesocios.celular2 == null ||
                            usuario.idmaesocios.celular2.toString().trim() == ''
                        ? '-'
                        : usuario.idmaesocios.celular2.toString(),
                    num),
                /*const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),*/
                CrearBotonFiador(usuario,),
                /*titulo('Nombre de aval'),
                const SizedBox(
                  height: 3,
                ),
                contenido('-', num), //nombreAval, num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('DNI del aval'),
                const SizedBox(
                  height: 3,
                ),
                contenido('-', num), //dniAval, num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),*/
                const SizedBox(
                  height: 40,
                ),
                Center(
                    child: Text(
                  'DETALLE PAGARÉ',
                  style: TextStyle(
                    fontSize: num / 40,
                    color: const Color.fromARGB(255, 51, 51, 51),
                  ),
                )),
                Container(height: num / 50),
                titulo('Número de pagaré'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.nrodocpagare.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Calificación SBS'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.calificacionsbs == null
                        ? '-'
                        : usuario.calificacionsbs.toString(),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Cuotas vencidas'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.detalle_cuenta_credito!.cvencidas.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Cuotas Pendientes'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.detalle_cuenta_credito!.cpendientes.toString(),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Cuotas pagadas'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.detalle_cuenta_credito!.cpagadas.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Calificación SBS'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.calificacionsbs.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Saldo deudor a la fecha'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    'S/ ${usuario.detalle_cuenta_credito!.montoalafecha}', num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Fecha Ult. Pago int.'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.detalle_cuenta_credito!.fecultpagointeres
                        .toString()
                        .substring(0, 10),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('1ra Cuota morosa'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    '${usuario.detalle_cuenta_credito!.primeracuotamorosa}',
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Fecha Vencimiento'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.detalle_cuenta_credito!.feccuotamorosa
                        .toString()
                        .substring(0, 10),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                titulo('Ultima gestión'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.detalle_cuenta_credito!.fecultpagointeres
                        .toString()
                        .substring(0, 10),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 236, 236, 236),
                  thickness: 1,
                ),
                Container(height: num / 45),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 50, 4, 150),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Pantalla_cuotas(
                              usuario.tipomonedacta,
                              usuario.nrodocpagare!,
                              usuario.idagenciapagare!,
                              usuario.iddocpagare!,
                              usuario.convextra,
                              usuario.convjud)),
                    );
                  },
                  child: Text(
                    'Ver cuotas',
                    style: TextStyle(
                      fontSize: num / 45,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(height: num / 35),
              ],
            ),
            isActive: currentStep >= 0,
            state: StepState.complete,
          ),
          //////////////////////////////////////////////////////////////////////////////////
          Step(
            title: const Text(
              'Paso 2',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            content: ListBody(
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Gestión del socio',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 30, 103, 33),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Motivo del atraso',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 122, 122, 122)),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color.fromARGB(255, 253, 242, 242),
                      decoration: const InputDecoration(enabled: false),
                      value: motivoAtraso.first,
                      onChanged: (String? value) {
                        setState(() {
                          motivoAtraso.first = value!;
                          motivoAtrasoGestion.text = value;
                        });
                      },
                      items: motivoAtraso.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              value.trim(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Resultado',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: DropdownMenu(
                    controller: resultadoGestion,
                    width: anchoPantalla * 0.87,
                    initialSelection: resultado.first,
                    onSelected: (String? value) {
                      setState(() {
                        resultado.first = value!;
                      });
                    },
                    dropdownMenuEntries: resultado
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value.trim());
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Persona que atendió',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: DropdownMenu(
                    width: anchoPantalla * 0.87,
                    controller: personaAtendioGestion,
                    initialSelection: personaAtendio.first,
                    onSelected: (String? value) {
                      setState(() {
                        personaAtendio.first = value!;
                      });
                    },
                    dropdownMenuEntries: personaAtendio
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Estado',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: DropdownMenu(
                    controller: estadoGestion,
                    width: anchoPantalla * 0.87,
                    initialSelection: estado.first,
                    onSelected: (String? value) {
                      setState(() {
                        estado.first = value!;
                      });
                    },
                    dropdownMenuEntries:
                        estado.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                const Text(
                  'Compromiso de pago',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
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

                const SizedBox(height: 20),
                const Text(
                  'Celular',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: celarGestion,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone_iphone_rounded, color: Colors.green),
                    //labelText: 'Ingresar observaciones',
                  ),
                  //scrollPadding: EdgeInsets.all(50),
                  //readOnly: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Correo electronico',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: correoGestion,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email_outlined, color: Colors.green),
                    //labelText: 'Ingresar observaciones',
                  ),
                  //scrollPadding: EdgeInsets.all(50),
                  //readOnly: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Observaciones',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 108, 183, 111),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(208, 255, 255, 255),
                            blurRadius: 50,
                            offset: Offset(50, 30))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: obser,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                AvatarGlow(
                  animate: _isListening,
                  glowColor: Colors.red,
                  glowRadiusFactor: 75.0,
                  duration: const Duration(milliseconds: 2000),
                  startDelay: const Duration(milliseconds: 100),
                  repeat: true,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _isListening == false
                            ? const Color.fromARGB(255, 35, 137, 39)
                            : Colors.red,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15)),
                    onPressed: _listen,
                    child: Icon(
                      _isListening == true ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Agregar una foto',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      iconSize: 40,
                      tooltip: 'Agregar una foto',
                      color: Colors.green,
                      alignment: Alignment.bottomCenter,
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        selImagen();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                imagen != null ? cargarImagen() : const Center(),
                const SizedBox(height: 20),
                accesoInternet != true
                    ? Column(
                        children: [
                          botonGuardar(),
                          const Center(
                            child: Text(
                                'Se perdío la conexion! intente nuevamente.'),
                          ),
                        ],
                      )
                    : estadoBoton == true
                        ? botonGuardar()
                        : botonGuardar2(),
                const SizedBox(height: 50),
                //),
              ],
            ),
            isActive: currentStep >= 0,
            state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          ////////////////////////////////////////////////////////////////////////////////////////////////
        ],
      ),
    );
  }

  bool estadoBoton = true;

  AnimatedButton botonGuardar() {
    return AnimatedButton(
      text: 'Enviar respuesta',
      color: const Color.fromARGB(255, 50, 4, 150),
      pressEvent: () {
        setState(() {
          estadoBoton = false;
        });
        checkLocationService().then((value) {
          print('Entro aquiii');
          print(isGpsEnabled);
        });

        if (isGpsEnabled == true) {
          getCurrentLocation().then((value) {
            print('Latituuddd ; ' + isGpsEnabled.toString());
            print('Latituuddd ; ' + latitud.toString());
            print('Longituuudd ; ' + longitud.toString());

            confimarAccion();
          });
        }

        /*getCurrentLocation().then((value) {
                    print('Latituuddd ; ' + isGpsEnabled.toString());
                    print('Latituuddd ; ' + latitud.toString());
                    print('Longituuudd ; ' + longitud.toString());
                    // _crearGestion();91916
                  });*/
      },
    );
  }

  ElevatedButton botonGuardar2() {
    return const ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
        Color.fromARGB(255, 50, 4, 150),
      )),
      onPressed: null,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (val) => {
          if (val == 'done')
            {
              setState(() {
                _isListening = false;
              })
            }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech?.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            //print(_text);
            obser.text = _text;
            if (val.hasConfidenceRating && val.confidence > 0) {
            } else {
              print('Sigue sigue');
            }
          }),
        );
      } else {}
    } else {
      setState(() => _isListening = false);
      _speech?.stop();
    }
  }

  Expanded tabla(double num, String nombre) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(
            color: const Color.fromARGB(186, 87, 77, 135),
            width: 1,
          ),
        ),
        width: num / 10,
        height: num / 14,
        child: Center(
          child: Text(
            nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 82, 82, 83),
            ),
          ),
        ),
      ),
    );
  }

  Expanded tabla1(double num, String nombre) {
    return Expanded(
      child: Text(
        nombre,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 82, 82, 83),
        ),
      ),
    );
  }

  Container contenido(String nombre, double num) {
    return Container(
      child: Text(
        nombre,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Text titulo(String titulo) {
    return Text(
      titulo,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Color.fromARGB(255, 161, 161, 161),
        fontSize: 14,
      ),
    );
  }
}



class CrearBotonFiador extends StatefulWidget {
  App_cuenta_credito cuenta;
  CrearBotonFiador(this.cuenta, {super.key});

  @override
  State<CrearBotonFiador> createState() =>
      _CrearBotonFiadorState(cuenta);
}

class _CrearBotonFiadorState extends State<CrearBotonFiador> {
  App_cuenta_credito cuenta;
  bool prueba = false;
  _CrearBotonFiadorState(this.cuenta);
  http.Client? client;
  List<app_fiador> listaFiador =[];

  Future<dynamic> _listarFiador() async {
    try {
      client = http.Client();
      var url = Uri.parse(
          '${Url_serv}api/fiador/buscar_fiadores/${cuenta.idagenciapagare}/${cuenta.iddocpagare}/${cuenta.nrodocpagare}/${cuenta.tipomoneda}');

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
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const login()),
                      );*/
                  },
                ),
              ],
            );
          },
        );
      } else {
        String body = utf8.decode(response.bodyBytes);
        print(response.body);

        final jsonData = jsonDecode(body);
        for (var item in jsonData) {
          var body = item;
          app_fiador cartera = app_fiador.fromJson(body);
          listaFiador.add(cartera);
        }
        print('cuotas:${listaFiador.length}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    } finally {
      client?.close();
    }
  }

  @override
  void initState() {
    _listarFiador().then((value) {
      if(mounted){
        setState(() {
          prueba=true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    client?.close();
    listaFiador.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
          child: ElevatedButton(
            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    title: const Text('Datos fiador'),
                    content: SizedBox(
                      height: 250, // Altura deseada del contenido
                      width: 100,
                      child: prueba == false?const Center(child: CircularProgressIndicator(),) :listaFiador.isEmpty?const Center(child: Text('No tiene fiador',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),) : ListView.builder(
                        itemCount: listaFiador.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5,),
                              Center(child:  Text('Fiador ${index+1}',style: const TextStyle(color: Color.fromARGB(255, 20, 169, 45),fontWeight: FontWeight.w600),)),
                              const Text('Nombre del fiador',style: TextStyle(color: Color.fromARGB(255, 189, 189, 189),fontWeight: FontWeight.w600),),
                              Text(listaFiador[index].fiador!),
                              const Text('Celular 01',style: TextStyle(color: Color.fromARGB(255, 189, 189, 189),fontWeight: FontWeight.w600),),
                              listaFiador[index].celular1!.trim()==''? const Text('-') :Text(listaFiador[index].celular1!),
                              const Text('Celular 02',style: TextStyle(color: Color.fromARGB(255, 189, 189, 189),fontWeight: FontWeight.w600),),
                              listaFiador[index].celular2!.trim()==''? const Text('-') :Text(listaFiador[index].celular2!),
                              const Text('Dirección',style: TextStyle(color: Color.fromARGB(255, 189, 189, 189),fontWeight: FontWeight.w600),),
                              listaFiador[index].direccion!.trim()==''? const Text('-') :Text(listaFiador[index].direccion!),
                              const Text('N° Documento',style: TextStyle(color: Color.fromARGB(255, 189, 189, 189),fontWeight: FontWeight.w600),),
                              listaFiador[index].nrodocumento!.trim()==''? const Text('-') :Text(listaFiador[index].nrodocumento!),
                              const Divider(
                                color: Color.fromARGB(255, 191, 191, 191),
                                thickness: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'Ver Datos Fiador +',
              style: TextStyle(color: Colors.white),
            ),
          )
    );
  }
}
