// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:app_leon_xiii/pantallaFormulario/login.dart';
import 'package:flutter/material.dart';

class splashLogo extends StatefulWidget {
  const splashLogo({super.key});

  @override
  _splashLogo createState() => _splashLogo();
}

class _splashLogo extends State<splashLogo> {
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 5000),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const login(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //double num = 0;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Row(
            children: [
              Expanded(
                  child: Image(
                image: const AssetImage('images/imagen01.png'),
                height: size.height / 5,
              ))
            ],
          ),
          const Spacer(),
          SizedBox(
            height: size.height / 8,
            width: size.height / 8,
            child: const CircularProgressIndicator(
              semanticsLabel: 'Circular progress indicator',
              color: Color.fromARGB(255, 30, 103, 33),
            ),
          ),
          const Spacer(),
          const Text(
            'v2.0.0',
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,),
          )
        ],
      ),
    );
  }
}
