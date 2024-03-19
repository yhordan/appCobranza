import 'package:app_leon_xiii/models/app_morosos.dart';
import 'package:app_leon_xiii/models/personal.dart';
import 'package:app_leon_xiii/pantallaFormulario/formulario_visitas.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class buscarGestion extends SearchDelegate<App_morosos> {
  final List<App_morosos> gestion;
  Personal personal;
  List<App_morosos> filtroGestion = [];
  final String nombre;
  String cadenaToken = '';
  buscarGestion(this.personal,  this.gestion, this.nombre,
      this.cadenaToken);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Buscar',
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close_sharp),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, filtroGestion[0]);
      },
      icon: const Icon(Icons.arrow_circle_left_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filtroGestion = gestion.where((usuario) {
      return usuario.idsocio!
              .toLowerCase()
              .contains(query.trim().toLowerCase()) ||
          usuario.socio!.toLowerCase().contains(
                query.trim().toLowerCase(),
              ) ||
          usuario.idmoroso.toLowerCase().contains(
                query.trim().toLowerCase(),
              ) ||
          usuario.nrodocp
              .toString()
              .toLowerCase()
              .contains(query.trim().toLowerCase());
    }).toList();
    return ListView.separated(
      itemCount: filtroGestion.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.5)),
          child: Card(
            child: ListTile(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            formulario_visitas(filtroGestion[index])),
                  );
                },
              title: Padding(
                padding: const EdgeInsets.all(4),
                child: ListBody(children: [
                  Text(
                    filtroGestion[index].socio.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'ID socio: ${filtroGestion[index].idsocio.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'Pagaré: ${filtroGestion[index].nrodocp}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color.fromARGB(255, 38, 12, 241)),
                  ),
                  Text(
                    'Saldo: S/${filtroGestion[index].saldo}',
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'C. Vencida: ${filtroGestion[index].cvencidas}',
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'C. Pendiente: ${filtroGestion[index].cpendientes}',
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ]),
              ),
              leading: const Icon(
                Icons.location_on_outlined,
                color: Color.fromARGB(255, 2, 128, 6),
                size: 50,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Color.fromARGB(255, 2, 205, 15),
              ),
              contentPadding: const EdgeInsets.all(2),
            ),
          ),
        );
      },
    );
  }
}
