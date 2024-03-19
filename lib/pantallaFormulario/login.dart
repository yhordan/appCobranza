//ignore_for_file: prefer_const_constructors, camel_case_types, library_private_types_in_public_api, unnecessary_new, unused_element, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:app_leon_xiii/FormularioRegistros/nuevo_usuario.dart';
import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/Token.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/splash/splash_pantallas.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  _stateLogin createState() => _stateLogin();
}

String decodeUserData(String code) {
  String normalizedSource = base64Url.normalize(code.split(".")[1]);
  return utf8.decode(base64Url.decode(normalizedSource));
}

class _stateLogin extends State<login> {
  var va = Url_serv;

  String mensaje = '';
  Token? token;
  String cadenaToken = '';
  String user = '';
  String pass = '';
  bool prueba = false;
  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  bool visibilidad = true;
  bool recordarContrasena = false;

  _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String letras = '';
    if (prefs.getBool('recordarContrasena') == true) {
      setState(() {
        controllerUser.text = prefs.getString('controllerUser') ?? '';
        controllerPassword.text = prefs.getString('controllerPassword') ?? '';
        recordarContrasena = prefs.getBool('recordarContrasena') ?? false;
      });
    } else {
      setState(() {
        controllerUser.text = '';
        controllerPassword.text = '';
        recordarContrasena = false;
      });
    }
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('controllerUser', controllerUser.text);
    prefs.setString('controllerPassword', controllerPassword.text);
    prefs.setBool('recordarContrasena', recordarContrasena);
  }

  String hashPassword(String password) {
    final key = utf8.encode(password);
    final bytes = utf8.encode('saltoiwenpfiwjepfiojwepfijwpoefijwprijpeiropef');

    // Agregar el salt a la contraseña antes de realizar el hash
    final hmacSha256 = Hmac(sha256, key);
    final hash = hmacSha256.convert(bytes);

    return hash.toString();
  }

  Future<dynamic> _getListadoUser() async {
    var url = Uri.parse('${va}api/personal/listar');
    final response = await http.get(url);
    var dataPerson = json.decode(response.body);
    return json.decode(response.body);
  }

  Future<dynamic> _obtenerToken() async {
    String passwordHash = hashPassword(controllerPassword.text);
    var url = Uri.parse('${va}rest/auth/login');
    var body = jsonEncode(
        {'codigo': controllerUser.text, 'usuario': controllerPassword.text});

    final response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });

    print("codigo: " + response.statusCode.toString());

    if (bandera <= 2) {
      if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Documento o contraseña incorrecta.! '),
              content: Text("Por favor, ingrese nuevamente sus datos."),
              actions: [
                TextButton(
                  child: Text(
                    "Aceptar",
                    style: TextStyle(color: Color.fromARGB(255, 198, 6, 6)),
                  ),
                  onPressed: () {
                    controllerPassword.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        bandera++;
        return response;
      } else {
        var body1 = response.body;
        Token token = Token.fromJson(jsonDecode(body1));

        var mensaje = decodeUserData(token.token);
        Personal personal = Personal.fromJson(jsonDecode(mensaje));
        cadenaToken = token.token;
        print('${personal.idagencia}  ${personal.idarea}');
        print(" token es" + cadenaToken);

        //prueba = _prefs!.getBool("check")!;

        print('habilitado: ' + personal.habilitado.toString());
        if (personal.habilitado.toString().trim() == '1') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => splashPantalla(personal, cadenaToken)),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('Su cuenta a sido bloqueda.'),
                content: Text("Por favor, comunicarse con su jefe inmediato."),
                actions: [
                  TextButton(
                    child: Text(
                      "Aceptar",
                      style: TextStyle(color: Color.fromARGB(255, 198, 6, 6)),
                    ),
                    onPressed: () {
                      controllerPassword.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        return personal;
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Su cuenta a sido bloqueada! '),
            content: Text("Por favor, actualize sus datos."),
            actions: [
              TextButton(
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Color.fromARGB(255, 3, 102, 182)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          nuevoUsuario('Recuperar contraseña', 'actualización'),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return token;
  }

  final _formKey = GlobalKey<FormState>();

  int bandera = 0;

  @override
  void initState() {
    _loadSavedData();
    setState(() {
      listaGlobalCuentaCredito.clear();
      listaDepartamentos.clear();
      motivoAtraso2.clear();
      estad3.clear();
      motivoAtraso2.clear();
      personaAtendio3.clear();
      resultado1.clear();
      listaPersonal.clear();
      listaMoroVisitas.clear();
      globalDrawer = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String valor = 'Hola';
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Salir?',
                  style: TextStyle(color: Color.fromARGB(255, 22, 22, 22)),
                ),
                //content: Text('Exit?'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => exit(0)),
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(233, 255, 255, 255),
          child: Stack(
            children: [
              logoLogin(),
              contenidoLogin(valor, size, context),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView contenidoLogin(
      String valor, Size size, BuildContext context) {
    final size = MediaQuery.of(context).size;
    double num = size.height;
    bool passToggle = true;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(height: size.height / 2.8),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            width: size.height / 1.8,
            height: 500,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(208, 215, 208, 208),
                      blurRadius: 50,
                      offset: Offset(50, 30))
                ]),
            child: ListView(
              children: [
                //SizedBox(height: 5),
                Center(
                  child: Text(
                    "Bienvenido",
                    style: TextStyle(
                        fontSize: num / 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 30, 103, 33)),
                  ),
                ),
                SizedBox(height: 10),
                // ignore: avoid_unnecessary_containers
                Container(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerUser,
                          onChanged: (value) {
                            setState(() {
                              user = value;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: 'Ingresar documento',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.badge_outlined,
                                color: const Color.fromARGB(255, 46, 108, 48),
                              )),
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
                        const SizedBox(height: 25),
                        TextFormField(
                          //autocorrect: false,
                          obscureText: visibilidad,
                          keyboardType: TextInputType.visiblePassword,
                          controller: controllerPassword,

                          onChanged: (value) {
                            setState(() {
                              pass = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibilidad = !visibilidad;
                                  });
                                },
                                icon: visibilidad == true
                                    ? const Icon(
                                        Icons.visibility_off_outlined,
                                        color:
                                            Color.fromARGB(255, 185, 185, 185),
                                      )
                                    : const Icon(
                                        Icons.visibility_outlined,
                                        color: Colors.green,
                                      )),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: const Color.fromARGB(255, 46, 108, 48),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Agregar contraseña';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                  value: recordarContrasena,
                                  activeColor: Colors.green,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      recordarContrasena = value!;
                                    });
                                  }),
                              const Text(
                                'Recordar datos',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          disabledColor: Colors.grey,
                          color: Color.fromARGB(255, 30, 103, 33),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            child: Text(
                              'Ingresar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _obtenerToken();
                              setState(() {
                                _saveData();
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => nuevoUsuario(
                                          'Recuperar contraseña',
                                          'actualización')),
                                );
                              },
                              style: ButtonStyle(
                                alignment: Alignment.topLeft, //
                              ),
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 3, 115, 5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => nuevoUsuario(
                                          'Actualizar mis datos', 'creación')),
                                );
                              },
                              style: ButtonStyle(
                                alignment: Alignment
                                    .center, // <-- had to set alignment
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets
                                      .zero, // <-- had to set padding to zero
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    '¿Eres nuevo? ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Actualizar datos.',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 3, 115, 5),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Container boxLogin(Size size) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: const [
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
      ])),
      width: double.infinity,
      height: size.height * 0.7,
    );
  }
}

class burbuja extends StatelessWidget {
  const burbuja({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          color: Color.fromARGB(40, 169, 213, 167)),
    );
  }
}

class logoLogin extends StatelessWidget {
  const logoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(70),
      //padding: EdgeInsets.symmetric(horizontal:size.height/15, vertical: 70),
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: CircleAvatar(
        radius: 120.0,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('images/LogoLeonXIII.jpeg'),
      ),
    );
  }
}
