// ignore_for_file: camel_case_types, must_be_immutable, unnecessary_new, unnecessary_cast, avoid_print, sort_child_properties_last, no_logic_in_create_state, library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';

import 'package:app_leon_xiii/FormularioRegistros/nuevo_usuario_codigo.dart';
import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class nuevoUsuario extends StatefulWidget {
  String frase = '';
  String frase2 = '';
  nuevoUsuario(this.frase, this.frase2, {super.key});
  @override
  _nuevoUsuarioState createState() => _nuevoUsuarioState(frase, frase2);
}

int aleatorio2(int min, int max) {
  return Random().nextInt(max - min + 1) + min;
}

class _nuevoUsuarioState extends State<nuevoUsuario> {
  final _formKey = GlobalKey<FormState>();

  String frase = '';
  String frase2 = '';
  bool prueba = true;
  bool contraIncorrecta = false;
  _nuevoUsuarioState(this.frase, this.frase2);

  TextEditingController correoController = new TextEditingController();
  TextEditingController dniController = new TextEditingController();
  var va = Url_serv;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String mensaje = '';

  Future<dynamic> _buscarPersonal(
      String correo, String dni, String codigo) async {
    var url = Uri.parse(
        '${va}api/personal/enviar_correo/$correo/$dni/${stringToBase64.encode(codigo)}');

    final response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });

    //var dataPerson = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 403) {
      mensaje = "Usuario o contrañena incorrectas";
      // ignore: use_build_context_synchronously
      setState(() {
        contraIncorrecta = true;
      });
      return response;
    } else {
      var body = response.body;
      print(jsonDecode(body));
      Personal personal = Personal.fromJson(jsonDecode(body));
      print(personal.persona);
      print(personal.login);
      print(personal.toString());

      Navigator.push(
        context as BuildContext,
        MaterialPageRoute(
            builder: (context) =>
                nuevoUsuarioCodigo(personal, codigo, correoController.text)),
      );
      return personal;
    }
  }

  var n = aleatorio2(10000, 99999);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          frase,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 3, 115, 5),
          ),
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                //margin: const EdgeInsets.symmetric(vertical: 50,horizontal: 20),
                // ignore: prefer_const_constructors
                child: Column(
                  children: [
                    const Text('Ingresar correo ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(
                      height: 4,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(children: <Widget>[
                        TextFormField(
                          controller: correoController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Ingrese correo',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese correo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('Ingresar documento de identidad ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: dniController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Documento de identidad',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Agregar documento';
                            }
                            if (value.length > 8) {
                              return 'Numero maximo de caracteres es 8';
                            }
                            return null;
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                //disabledColor: const Color.fromARGB(255, 229, 26, 26),
                color: const Color.fromARGB(255, 9, 22, 119),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: prueba == true
                      ? const Text(
                          'Validar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
                onPressed: () {
                  setState(() {
                    prueba = false;
                  });
                  _buscarPersonal(correoController.text, dniController.text,
                          n.toString())
                      .then((value) {
                    setState(() {
                      prueba = true;
                    });
                  });
                },
              ),
              contraIncorrecta == true
                  ? const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  Center(
                        child: Text(
                        'Datos incorrectos, verificar datos.',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  )
                  : const Center(),
              const SizedBox(
                height: 60,
              ),
              Card(
                color: const Color.fromARGB(255, 231, 239, 252),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(
                          'Se le enviara a su correo, un codigo de verificación para su respectiva $frase2 de contraseña.'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
