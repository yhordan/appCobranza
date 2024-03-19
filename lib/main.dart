// ignore_for_file: library_private_types_in_public_api

import 'package:app_leon_xiii/pages/pantalla_direcciones.dart';
import 'package:app_leon_xiii/splash/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String filter = "none";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DirectionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cobranza Móvil',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const splashLogo(),
      ),
    );
  }
}
