import 'package:flutter/material.dart';

Widget boton(String nombre, String acronimo) {
  return InkWell(
    child: SizedBox(
      width: 170,
      height: 170,
      child: Card(
        margin: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 138, 6, 6),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FittedBox(
              child: Icon(Icons.co_present, size: 100, color: Colors.white),
            ),
            FittedBox(
              child: Text(
                nombre,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      // ignore: avoid_print
      print("OK");
    },
  );
}
