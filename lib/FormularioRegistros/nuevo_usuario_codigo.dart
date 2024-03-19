// ignore_for_file: empty_constructor_bodies, camel_case_types, unnecessary_import, unnecessary_new, avoid_print, unnecessary_cast

import 'package:app_leon_xiii/FormularioRegistros/cambiarContrasena.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class nuevoUsuarioCodigo extends StatefulWidget {
  Personal personal;
  String codigo;
  String correo;
  nuevoUsuarioCodigo(this.personal, this.codigo, this.correo, {super.key});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _splashPantalla createState() => _splashPantalla(personal, codigo, correo);
}

class _splashPantalla extends State<nuevoUsuarioCodigo> {
  Personal personal;
  String codigo;
  String correo;
  _splashPantalla(this.personal, this.codigo, this.correo);
  final _formKey = GlobalKey<FormState>();
  TextEditingController codigoController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Column(
                  children: [
                    Card(
                      color: const Color.fromARGB(255, 231, 239, 252),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: Text(
                                'Ingresar codigo de verificación que fue enviado al siguiente correo: $correo'),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height: 15,),
                    Container(
                      margin: const EdgeInsets.only(top: 30, left: 100, right: 100),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: codigoController,
                          maxLength: 5,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Ingresar codigo',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese codigo';
                            }
                            if (value.length > 5) {
                              return 'Numero maximo de caracteres es 5';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      disabledColor: Colors.grey,
                      color: const Color.fromARGB(255, 8, 11, 100),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: const Text(
                          'Validar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (codigo == codigoController.text) {
                            
                            print('Correcto');
                            Navigator.push(
                              context as BuildContext,
                              MaterialPageRoute(
                                  builder: (context) => cambiarContrasena(
                                      personal, codigo, correo)),
                            );
                            const Text('Hola');
                          } else {
                            ScaffoldMessenger.of(context as BuildContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text('Codigo incorrecto'),
                              ),
                            );
                            print('Incorrecto');
                          }
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
