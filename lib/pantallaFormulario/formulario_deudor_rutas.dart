// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_field, prefer_typing_uninitialized_variables, avoid_print, unnecessary_new, unused_local_variable, unnecessary_null_comparison, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:typed_data';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_cuenta_credito.dart';
import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/models/cuotas_vencidas.dart';
import 'package:app_leon_xiii/models/persona_atendio.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:http_parser/http_parser.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart' as stt;

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoieWhvcmRhbjE3IiwiYSI6ImNsbm5xdmlhMjA3cjEyc3FqZmZzN29rMXEifQ.8Y7VwtJkrqW2shDTR7PtrQ';
final MyPosition = LatLng(40.697488, -73.979681);

// ignore: camel_case_types, must_be_immutable
class formulario_deudor_rutas extends StatefulWidget {
  late Map<dynamic, dynamic> json;

  App_cuenta_credito usuario;

  formulario_deudor_rutas(this.usuario, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<formulario_deudor_rutas> createState() => _formularioState(usuario);
}

// ignore: camel_case_types
class _formularioState extends State<formulario_deudor_rutas> {
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
  String _text = 'Presionar para hablar ...';
  double _confidence = 1.0;

  String resultText = '';

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    _speech = stt.SpeechToText();
    super.initState();
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
      print("lengt${imagenBytes.length}");

      setState(() {
        base6445 = base64Encode(imagenBytes);
      });

      String na = imagen!.path.split('/').last;

      print("imprimir: $na");
    }
  }

  Future<Position> getCurrentLocation() async {
    Position position = await determinarPosition();
    //Imprimiendo coordenadas
    latitud = position.latitude.toString();
    longitud = position.longitude.toString();
    print(position.latitude);
    print(position.longitude);
    return position;
  }

  final moonLanding = DateTime.now();
  final List<Cuotas_vencidas> cuotas_vencidas = [];
  var va = Url_serv;

  TextEditingController socioGestion = new TextEditingController();
  TextEditingController motivoAtrasoGestion = new TextEditingController();
  TextEditingController resultadoGestion = new TextEditingController();
  TextEditingController estadoCivilGestion = new TextEditingController();
  TextEditingController personaAtendioGestion = new TextEditingController();
  TextEditingController correoGestion = new TextEditingController();
  TextEditingController celarGestion = new TextEditingController();
  TextEditingController estadoGestion = new TextEditingController();
  TextEditingController compromisoPagoGestion = new TextEditingController();
  TextEditingController direccionGestion = new TextEditingController();
  TextEditingController observacionesGestion = new TextEditingController();
  String fecha = DateFormat('yyyy-MM-ddTHH:mm:00.000').format(DateTime.now());

  Future<void> subir() async {
    var header = {
      "Content-Type": 'multipart/form-data',
      "Authorization": "Bearer $Token_valor"
    };

    var postUri = Uri.parse("${va}api/gestion_socio_aval/crear_archivo");

    var request = http.MultipartRequest(
      "POST",
      postUri,
    );

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
      'file1',
      pickedFile.path,
    );
    print(DateFormat('yyyy-MM-ddTHH:mm:00.000').format(DateTime.now()));
    // ignore: avoid_init_to_null
    String? fechaNueva = null;
    if (dateInput.text != '') {
      fechaNueva = '${dateInput.text}T00:00:00.000';
    }

    String resultado = '';
    String motivo = '';
    String personA = '';
    String estad = '';
    for (Persona_atendio p in personaAtendio3) {
      if (p.descripcion == personaAtendioGestion.text) {
        personA = p.codigo;
      }
    }
    for (Persona_atendio p in resultado1) {
      if (p.descripcion == resultadoGestion.text) {
        resultado = p.codigo;
      }
    }
    for (Persona_atendio p in motivoAtraso2) {
      if (p.descripcion == motivoAtrasoGestion.text) {
        motivo = p.codigo;
      }
    }
    for (Persona_atendio p in estad3) {
      if (p.descripcion == estadoGestion.text) {
        estad = p.codigo;
      }
    }

    Map<String, String> obj = {
      /*'num_pagare': usuario.num_pagare,
      'socio_aval': socioGestion.text,
      'dni_socio_aval': usuario.dni_socio,
      'nombre_socio_aval': usuario.nombre_socio,
      'motivo_atrazo': motivo,
      'resultado': resultado,
      'persona_atendio': personA,
      'estado': estad,
      'compromiso_pago': fechaNueva!,
      'direccion': usuario.direccion_socio,
      'observaciones': _text.toString(),
      'fecha_registro': fecha.toString(),
      'usuarioregistro': global_personal.persona,
      'geolocalizacion_latitud': latitud,
      'geolocalizacion_longitud': longitud,
      'celular': celarGestion.text,
      'correo': correoGestion.text,
      'estado_civil': '-',
      'idsocio': usuario.ide_socio,
      'abreviatura': usuario.abreviatura!,*/
    };
    final jsonData = jsonEncode(obj);
    final jsonPart = http.MultipartFile.fromString(
      "json",
      jsonData,
      filename: 'data.json',
      contentType: MediaType.parse('application/json'),
    );
    request.files.add(jsonPart);
    // Map<String, String> obj = {"json": json.encode(body).toString()};

    request.files.add(multipartFile);
    request.headers.addAll(header);
    // request.fields.addAll(obj);

    //request.fields.addAll(obj);

    http.StreamedResponse response1 = await request.send();

    print("Error : $response1");
  }

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

  /*Future<dynamic> _crearGestion() async {
    print(DateFormat('yyyy-MM-ddTHH:mm:00.000').format(DateTime.now()));
    // ignore: avoid_init_to_null
    String? fechaNueva = null;
    if (dateInput.text != '') {
      fechaNueva = dateInput.text + 'T00:00:00.000';
    }

    String resultado = '';
    String motivo = '';
    String personA = '';
    String estad = '';
    for (Persona_atendio p in personaAtendio3) {
      if (p.descripcion == personaAtendioGestion.text) {
        personA = p.codigo;
      }
    }
    for (Persona_atendio p in resultado1) {
      if (p.descripcion == resultadoGestion.text) {
        resultado = p.codigo;
      }
    }
    for (Persona_atendio p in motivoAtraso2) {
      if (p.descripcion == motivoAtrasoGestion.text) {
        motivo = p.codigo;
      }
    }
    for (Persona_atendio p in estad3) {
      if (p.descripcion == estadoGestion.text) {
        estad = p.codigo;
      }
    }
    //print(fechaNueva! + 'Holaaaaaaaaaaaaaa');

    var url = Uri.parse('${va}api/gestion_socio_aval/crear');
    var body = jsonEncode({
      'num_pagare': usuario.num_pagare,
      'socio_aval': socioGestion.text,
      'dni_socio_aval': usuario.dni_socio,
      'nombre_socio_aval': usuario.nombre_socio,
      'motivo_atrazo': motivo,
      'resultado': resultado,
      'persona_atendio': personA,
      'estado': estad,
      'compromiso_pago': fechaNueva,
      'direccion': usuario.direccion_socio,
      'observaciones': _text.toString(),
      'fecha_registro': fecha.toString(),
      'usuarioregistro': global_personal.persona,
      'geolocalizacion_latitud': latitud,
      'geolocalizacion_longitud': longitud,
      'celular': celarGestion.text,
      'correo': correoGestion.text,
      'estado_civil': '-',
      'idsocio': usuario.ide_socio,
      'abreviatura': usuario.abreviatura,
      'foto': base6445,
    });

    final response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $Token_valor"
    });

    //var dataPerson = json.decode(response.body);
    //print(response.statusCode);
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
                    MaterialPageRoute(builder: (context) => login()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      if (usuario.isSelected == true) {
        var body = response.body;
        List<Cartera_Atrasada> nueva = [];
        print(jsonDecode(body));
        Gestion_Aval gestionG = Gestion_Aval.fromJson(jsonDecode(body));
        print(gestionG.dni_socio);
        print(gestionG.compromiso_pago);
        for (Cartera_Atrasada car in lista_Cartera) {
          if (usuario.num_pagare == car.num_pagare &&
              usuario.dni_socio == car.dni_socio) {
            car.isSelected = false;
            nueva.add(car);
          } else {
            nueva.add(car);
          }
        }

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PantallaRuteo(nueva, personal, Token_valor, lista_Cartera)),
        );
        return gestionG;
      } else {
        var body = response.body;
        print(jsonDecode(body));
        bool valor = false;
        Gestion_Aval gestionG = Gestion_Aval.fromJson(jsonDecode(body));

        print(gestionG.dni_socio);
        print(gestionG.compromiso_pago);

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => drawer_visitas()),
        );
        return gestionG;
      }
    }
  }
*/
 
  @override
  Widget build(BuildContext context) {
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
    getCurrentLocation();
    final size = MediaQuery.of(context).size;
    double num = size.height;
    //String? fecha = usuario.ultima_gestion;
    //String? nombreAval = usuario.nombre_aval;
    //String? dniAval = usuario.dni_aval;
    String? nombreAval = 'Falta jalar Avala';
    String? dniAval = 'Falta jalar dni aval';
    /*if (fecha == null) {
      print('ENtro aqui');
      fecha = '-';
    } else {
      fecha = fecha.substring(0, 10);
    }
    if (nombreAval.trim() == '') {
      print('Ahor aquir');
      nombreAval = '-';
    }
    if (dniAval.trim() == '') {
      print('Ahor aquir');
      dniAval = '-';
    }
    if (usuario.isSelected == true) {
      return metodoRegistro2(context, num, nombreAval, dniAval, fecha,
          motivoAtraso, resultado, personaAtendio, estado, estadoCivil);
    } else {
      return metodoRegistro(context, num, nombreAval, dniAval, fecha,
          motivoAtraso, resultado, personaAtendio, estado, estadoCivil);
    }*/
   return metodoRegistro(context, num, nombreAval, dniAval, fecha,
          motivoAtraso, resultado, personaAtendio, estado, estadoCivil);
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
      List<String> estadoCivil) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 15,
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        title: const FittedBox(
          child: Text(
            'Registro de gestión de clientes',
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
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
                    fontSize: num / 31,
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
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Número de documento'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.idmaesocios.nrodocumento.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Dirección de domicilio'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.idmaesocios.direccion.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Dirección N°1'),
                const SizedBox(
                  height: 3,
                ),
                contenido('g',num
                    /*usuario.direccion_alternativa1 == null
                        ? '-'
                        : usuario.direccion_alternativa1.toString(),
                    num*/),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Dirección N°2'),
                const SizedBox(
                  height: 3,
                ),
                contenido('g',num
                    /*usuario.direccion_alternativa2 == null
                        ? '-'
                        : usuario.direccion_alternativa2.toString(),
                    num*/),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
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
                  color: Color.fromARGB(255, 0, 0, 0),
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
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Celular N°2'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.idmaesocios.celular2 == null
                        ? '-'
                        : usuario.idmaesocios.celular2.toString(),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Número de pagaré'),
                const SizedBox(
                  height: 3,
                ),
                contenido(usuario.nrodocpagare.toString(), num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Nombre de aval'),
                const SizedBox(
                  height: 3,
                ),
                contenido(nombreAval, num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('DNI del aval'),
                const SizedBox(
                  height: 3,
                ),
                contenido(dniAval, num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Ultima gestión'),
                const SizedBox(
                  height: 3,
                ),
                contenido(fecha, num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                titulo('Calificación deudor'),
                const SizedBox(
                  height: 3,
                ),
                contenido(
                    usuario.idmaesocios.calificacion == null
                        ? '-'
                        : usuario.idmaesocios.calificacion.toString(),
                    num),
                const Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                ),
                Container(height: num / 45),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 50, 4, 150),
                  ),
                  onPressed: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Pantalla_cuotas(
                              usuario.dni_socio, usuario.num_pagare)),
                    );*/

                    //Navigator.pop(context);
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
                  child: DropdownMenu(
                    controller: motivoAtrasoGestion,
                    width: 290,
                    initialSelection: motivoAtraso.first,
                    onSelected: (String? value) {
                      setState(() {
                        motivoAtraso.first = value!;
                      });
                    },
                    dropdownMenuEntries: motivoAtraso
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
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
                    //menuHeight: 50,
                    width: 290,
                    controller: resultadoGestion,
                    initialSelection: resultado.first,
                    onSelected: (String? value) {
                      setState(() {
                        resultado.first = value!;
                      });
                    },
                    dropdownMenuEntries: resultado
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
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
                    width: 290,
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
                    width: 290,
                    controller: estadoGestion,
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
                /*TextFormField(
                  controller: observacionesGestion,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.feedback_outlined, color: Colors.green),
                    //labelText: 'Ingresar observaciones',
                  ),
                  //scrollPadding: EdgeInsets.all(50),
                  //readOnly: true,
                ),*/
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
                    child: TextHighlight(
                      text: _text,
                      words: _highlights,
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w400,
                      ),
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
                AnimatedButton(
                  text: 'Enviar respuesta',
                  color: const Color.fromARGB(255, 50, 4, 150),
                  pressEvent: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CupertinoAlertDialog(
                          title: Text('Cargando ..'),
                          actions: [
                            SizedBox(
                              height: 5.0,
                              width: 5.0,
                              child: LinearProgressIndicator(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                color: Color.fromARGB(255, 152, 151, 151),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    //_crearGestion();
                  },
                ),
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (val) => {
          if (val == 'done')
            {
              print('te cayaste!'),
              setState(() {
                _isListening=false;
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
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            } else {
              print('Sigue sigue');
            }
          }),
        );
      } else {}
    } else {
      setState(() => _isListening = false);
      print('se paro');
      _speech?.stop();
    }
  }
/*
  WillPopScope metodoRegistro2(
      BuildContext context,
      double num,
      String nombreAval,
      String dniAval,
      String fecha,
      List<String> motivoAtraso,
      List<String> resultado,
      List<String> personaAtendio,
      List<String> estado,
      List<String> estadoCivil) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Deseas salir del registro?',
                  style: TextStyle(color: Color.fromARGB(255, 22, 22, 22)),
                ),
                //content: Text('Exit?'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PantallaRuteo(lista_Cartera,
                                personal, Token_valor, lista_Cartera_original)),
                      );*/
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 15,
          shadowColor: const Color.fromARGB(255, 255, 255, 255),
          title: const FittedBox(
            child: Text(
              'Registro de gestión de clientes',
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
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
                      fontSize: num / 31,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  )),
                  Container(height: num / 50),
                  titulo('Nombre del socio'),
                  const SizedBox(
                    height: 3,
                  ),
                  contenido(usuario.nombre_socio.toString(), num),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  titulo('Número de documento'),
                  const SizedBox(
                    height: 3,
                  ),
                  contenido(usuario.dni_socio.toString(), num),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  titulo('Dirección de domicilio'),
                  const SizedBox(
                    height: 3,
                  ),
                  contenido(usuario.direccion_socio.toString(), num),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  titulo('Número de pagaré'),
                  const SizedBox(
                    height: 3,
                  ),
                  contenido(usuario.num_pagare.toString(), num),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  titulo('Nombre de aval'),
                  const SizedBox(
                    height: 3,
                  ),
                  contenido(nombreAval, num),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  titulo('DNI del aval'),
                  const SizedBox(
                    height: 3,
                  ),
                  contenido(dniAval, num),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  titulo('Ultima gestión'),
                  const SizedBox(
                    height: 3,
                  ),
                  contenido(fecha, num),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                  ),
                  Container(height: num / 45),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 50, 4, 150),
                    ),
                    onPressed: () {
                      print('Holaaaaaaaaaaa');
                      //_listarCartera(usuario.dni_socio, usuario.num_pagare);
                      ban = 1;
                      if (ban == 1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            ban = 0;
                            return const CupertinoAlertDialog(
                              title: Text('Cargando ..'),
                              actions: [
                                SizedBox(
                                  height: 5.0,
                                  width: 5.0,
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    color: Color.fromARGB(255, 152, 151, 151),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      // ignore: prefer_const_constructors
                      Future.delayed(Duration(seconds: 3), () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Pantalla_cuotas(
                                  cuotas_vencidas,
                                  Token_valor,
                                  codigoSocio,
                                  empleado,
                                  personal,
                                  usuario)),
                        );*/
                      });
                    },
                    child: Text(
                      'Ver cuotas',
                      style: TextStyle(
                        fontSize: num / 45,
                        color: Color.fromARGB(255, 255, 254, 254),
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
                    child: DropdownMenu(
                      controller: motivoAtrasoGestion,
                      width: 290,
                      initialSelection: motivoAtraso.first,
                      onSelected: (String? value) {
                        setState(() {
                          motivoAtraso.first = value!;
                        });
                      },
                      dropdownMenuEntries: motivoAtraso
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
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
                      //menuHeight: 50,
                      width: 290,
                      controller: resultadoGestion,
                      initialSelection: resultado.first,
                      onSelected: (String? value) {
                        setState(() {
                          resultado.first = value!;
                        });
                      },
                      dropdownMenuEntries: resultado
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
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
                      width: 290,
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
                      width: 290,
                      controller: estadoGestion,
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
                  /*const Text(
                    'Estado civil',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 4, 4, 4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: DropdownMenu(
                      width: 290,
                      controller: estadoCivilGestion,
                      initialSelection: estadoCivil.first,
                      onSelected: (String? value) {
                        setState(() {
                          estadoCivil.first = value!;
                        });
                      },
                      dropdownMenuEntries: estadoCivil
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                    ),
                  ),*/
                  const SizedBox(height: 20),
                  //Padding(
                  //padding: EdgeInsets.all(80),
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
                    'Observaciones',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 4, 4, 4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    controller: observacionesGestion,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.feedback_outlined, color: Colors.green),
                      //labelText: 'Ingresar observaciones',
                    ),
                    //scrollPadding: EdgeInsets.all(50),
                    //readOnly: true,
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
                      icon:
                          Icon(Icons.phone_iphone_rounded, color: Colors.green),
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
                  imagen == null ? Center() : Image.file(imagen!),
                  const SizedBox(height: 20),
                  AnimatedButton(
                    text: 'Enviar respuestaaaaaa',
                    color: Color.fromARGB(255, 50, 4, 150),
                    pressEvent: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.scale,
                          showCloseIcon: true,
                          title: 'Enviado',
                          desc: 'Registrado con Exito! ',
                          btnOkOnPress: () {
                            print("entro");
                            subir();
                          }).show();
                    },
                  ),
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
      ),
    );
  }
*/
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
    int l = nombre.length;
    double f = 40;
    if (l >= 29) {
      print("Este: $l$nombre");
      f = 70;
    }
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
