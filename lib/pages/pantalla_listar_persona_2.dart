// ignore_for_file: unused_element
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pages/pantalla_trazado_02.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class pantalla_listar_personal_2 extends StatefulWidget {
  const pantalla_listar_personal_2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Statepantalla_listar_personal createState() =>
      _Statepantalla_listar_personal();
}

// ignore: camel_case_types
class _Statepantalla_listar_personal extends State<pantalla_listar_personal_2> {
  TextEditingController dateInput =
      TextEditingController(text: DateTime.now().toString().substring(0, 10));

  @override
  void initState() {
    super.initState();
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Consulta estadistica',
          style: TextStyle(
              color: Color.fromARGB(255, 32, 101, 0),
              fontWeight: FontWeight.w700,
              fontSize: 25),
        )),
        backgroundColor: const Color.fromARGB(255, 145, 252, 142),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color.fromARGB(255, 145, 252, 142),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              'Ingresar fecha a consultar',
              style: TextStyle(
                  color: Color.fromARGB(255, 32, 101, 0),
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 0, 106, 9), width: 5),
                    borderRadius: BorderRadius.circular(15)),
                width: 240,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),
                    controller: dateInput,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_month,
                            color: Color.fromARGB(255, 0, 0, 0), size: 35),
                        border: InputBorder.none),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        //locale: const Locale("es","ES"),
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        // ignore: avoid_print
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        // ignore: avoid_print
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          dateInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 3, 77, 0)),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(15.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Trazado_pantalla_2(dateInput.text)),
                );
              },
              child: const Text(
                'Consultar',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w800,
                    fontSize: 25),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _mostrarDialogo(Personal personal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Seleccionar fecha a consultar',
            style: TextStyle(fontSize: 20),
          )),
          backgroundColor: const Color.fromARGB(255, 233, 233, 233),
          actions: [
            TextField(
              controller: dateInput,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month, color: Colors.green),
                  border: OutlineInputBorder()),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  //locale: const Locale("es","ES"),
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  // ignore: avoid_print
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  // ignore: avoid_print
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    dateInput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Trazado_pantalla_2(dateInput.text),
                  ),
                );
              },
              child: const Text(
                'Consultar',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
              ),
            )
          ],
        );
      },
    );
  }
}
