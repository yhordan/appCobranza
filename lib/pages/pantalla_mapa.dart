import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class drawer_mapa extends StatefulWidget {
  // ignore: non_constant_identifier_names
  List<Cartera_Atrasada> lista_aval_original = [];
  // ignore: non_constant_identifier_names
  List<Cartera_Atrasada> lista_aval = [];
  Personal personal;
  String cadenaToken;

  drawer_mapa(this.lista_aval, this.personal, this.cadenaToken,
      this.lista_aval_original,
      {super.key});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _StateDrawer_mapa createState() =>
      // ignore: no_logic_in_create_state
      _StateDrawer_mapa(lista_aval, personal, cadenaToken, lista_aval_original);
}

// ignore: must_be_immutable, camel_case_types
class _StateDrawer_mapa extends State<drawer_mapa> {
  // ignore: non_constant_identifier_names
  List<Cartera_Atrasada> lista_aval_original = [];
  // ignore: non_constant_identifier_names
  List<Cartera_Atrasada> lista_aval = [];
  Personal personal;
  String cadenaToken;
  _StateDrawer_mapa(this.lista_aval, this.personal, this.cadenaToken,
      this.lista_aval_original);
  int i = 0;
  // ignore: non_constant_identifier_names
  List<Cartera_Atrasada> lista_nueva = [];
  List<Cartera_Atrasada> nueva = [];

  Cartera_Atrasada? selectd;
  @override
  void initState() {
    super.initState();

    selectd = widget.lista_aval.first;
  }

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////////////////////////////
    //lista_aval = lista_aval.where((x) => x.geolocalizacion_longitud != null).toList();
    ////////////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 128, 6),
        elevation: 25,
        shadowColor: const Color.fromARGB(255, 2, 128, 6),
        title: const FittedBox(
          child: Text(
            'Proceso de rutas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Color.fromARGB(255, 234, 234, 234),
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 215, 213, 213),
        padding: const EdgeInsets.all(0),
        child: ListView.separated(
          itemCount: lista_aval.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: Color.fromARGB(255, 215, 213, 213),
          ),
          itemBuilder: (_, index) {
            String fechaNueva = '';
            if (lista_aval[index].ultima_gestion != null) {
              fechaNueva = lista_aval[index].ultima_gestion!.substring(0, 10);
            } else {
              fechaNueva = 'Sin visita';
            }
            return Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  //color: Colors.amber,
                  /*border: Border.all(
                        color: const Color.fromARGB(255, 79, 74, 74),
                        width: 2,
                      ),*/
                  borderRadius: BorderRadius.circular(7.5)),
              child: Card(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListBody(children: [
                      Text(
                        lista_aval[index].nombre_socio,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        lista_aval[index].direccion_socio,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 1, 1),
                        ),
                      ),
                      Text(
                        'Última visita: $fechaNueva',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 38, 249),
                        ),
                      ),
                    ]),
                  ),
                  leading: Checkbox(
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color.fromARGB(255, 0, 141, 5);
                        }
                        return null;
                      }),
                      value: widget.lista_aval[index].isSelected,
                      onChanged: (s) {
                        widget.lista_aval[index].isSelected =
                            !widget.lista_aval[index].isSelected;
                        setState(() {
                          if (widget.lista_aval[index].isSelected == true) {
                            lista_aval[index].isSelected =
                                widget.lista_aval[index].isSelected;
                            lista_nueva.add(lista_aval[index]);
                          } else {
                            lista_aval[index].isSelected =
                                widget.lista_aval[index].isSelected;
                            lista_nueva.remove(lista_aval[index]);
                          }
                          i++;
                        });
                      }),
                  contentPadding: const EdgeInsets.all(2),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        disabledColor: Colors.grey,
        color: const Color.fromARGB(255, 235, 207, 2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text(
            'Seleccionados: ${lista_nueva.length}',
            style: const TextStyle(
                color: Color.fromARGB(255, 6, 6, 6),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () {
          _verificar();
        },
      ),
    );
  }

  void _verificar() {
    if (lista_nueva.isNotEmpty) {
      int ban = 1;
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
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    color: Color.fromARGB(255, 152, 151, 151),
                  ),
                ),
              ],
            );
          },
        );
      }
      /*Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PantallaRuteo(
                  lista_nueva, personal, cadenaToken, lista_aval_original)),
        );
      });*/
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Debe seleccionar un socio para empezar.'),
            actions: [
              TextButton(
                child: const Text(
                  "Aceptar",
                  style: TextStyle(color: Color.fromARGB(255, 3, 102, 182)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }
}
