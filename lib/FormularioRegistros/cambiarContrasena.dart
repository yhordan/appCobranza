// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state, camel_case_types, must_be_immutable, file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/splash/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class cambiarContrasena extends StatefulWidget {
  Personal personal;
  String codigo;
  String correo;
  cambiarContrasena(this.personal, this.codigo, this.correo, {super.key});
  @override
  _cambiarContrasenaState createState() =>
      _cambiarContrasenaState(personal, codigo, correo);
}

class _cambiarContrasenaState extends State<cambiarContrasena> {
  var va = Url_serv;
  String mensaje = '';
  //TextEditingController passwordController = new TextEditingController();
  Personal personal;
  String codigo;
  String correo;
  _cambiarContrasenaState(this.personal, this.codigo, this.correo);
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  Future<dynamic> _editarContrasena() async {
    print(personal.iduser);
    print(personal.login);
    print(personal.persona);
    print(personal.correo);
    print(personal.iduser);
    var url = Uri.parse('${va}api/personal/actualizar');
    var body = jsonEncode({
      'login': personal.login,
      'persona': personal.persona,
      'idpersona': personal.idpersona,
      'password': stringToBase64.encode(repCodigoController.text),
      'correo': correo
    });

    final response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });

    //var dataPerson = json.decode(response.body);
    //print(response.statusCode);
    if (response.statusCode == 204) {
      mensaje = "Usuario o contrañena incorrectas";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
      print(mensaje);
      return response;
    } else {
      var body = response.body;
      //print(jsonDecode(body));
      Personal personal = Personal.fromJson(jsonDecode(body));
      print(response.body);
      print(personal.login);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const splashLogo()),
      );
      return personal;
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController codigoController = TextEditingController();
  TextEditingController repCodigoController = TextEditingController();
  bool passToggle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Crear nueva contraseña',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 3, 115, 5),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Ingrese nueva contraseña',
                    style: TextStyle(
                      color: Color.fromARGB(255, 3, 115, 5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: TextFormField(
                      controller: codigoController,
                      //maxLength: 5,
                      obscureText: passToggle,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'ingrese contraseña',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Contraseña vacia';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Text(
                    'Repetir contraseña',
                    style: TextStyle(
                      color: Color.fromARGB(255, 3, 115, 5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: TextFormField(
                      controller: repCodigoController,
                      //maxLength: 5,
                      obscureText: passToggle,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        labelText: 'ingrese contraseña',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString() != codigoController.text) {
                          return 'Contraseñas no coiciden';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    disabledColor: Colors.grey,
                    color: const Color.fromARGB(255, 30, 103, 33),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      child: const Text(
                        'VALIDAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _editarContrasena();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
