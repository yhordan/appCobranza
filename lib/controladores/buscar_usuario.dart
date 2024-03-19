import 'package:app_leon_xiii/Globales/globals.dart';
import 'package:app_leon_xiii/models/app_cuenta_credito.dart';
import 'package:app_leon_xiii/models/cartera_atrasada.dart';
import 'package:app_leon_xiii/pantallaFormulario/formulario_deudor.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class buscarUsuario extends SearchDelegate<App_cuenta_credito> {
  final List<App_cuenta_credito> usuarios;
  List<App_cuenta_credito> filtroUsuario = [];
  buscarUsuario(
    this.usuarios,
  );

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
        close(context, filtroUsuario[0]);
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
    filtroUsuario = usuarios.where((usuario) {
      return usuario.idmaesocios.socio
              .toLowerCase()
              .contains(query.trim().toLowerCase()) ||
          usuario.denominacion!
              .toLowerCase()
              .contains(query.trim().toLowerCase()) ||
          usuario.denominacion!
              .toLowerCase()
              .contains(query.trim().toLowerCase()) ||
          usuario.nrodocpagare!
              .toLowerCase()
              .contains(query.trim().toLowerCase()) ||
          usuario.idestadodoc.estado
              .toLowerCase()
              .contains(query.trim().toLowerCase()) ||
          usuario.idmaesocios.idsocio
              .toLowerCase()
              .contains(query.trim().toLowerCase()) ||
          usuario.idmaesocios.nrodocumento
              .toLowerCase()
              .contains(query.trim().toLowerCase());
    }).toList();

    // ignore: unused_local_variable
    List<Cartera_Atrasada> filtroFinal = [];

    return ListView.separated(
      itemCount: filtroUsuario.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      itemBuilder: (_, index) {
        int m = listaMoroVisitas
            .where((x) =>
                x.nrodocp == filtroUsuario[index].nrodocpagare &&
                x.idagenciap!.idagencia == filtroUsuario[index].idagenciacta)
            .toList()
            .length;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.5),),
          child: Card(
            elevation: 5,
            color: const Color.fromARGB(255, 255, 255, 255),
            shadowColor: const Color.fromARGB(255, 0, 0, 0),
            surfaceTintColor: Colors.white,
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          formulario_deudor(filtroUsuario[index])),
                );
              },
              title: //Center(
                  Padding(
                padding: const EdgeInsets.all(8),
                child: ListBody(children: [
                  Text(
                    // ignore: unnecessary_string_interpolations
                    '${filtroUsuario[index].idmaesocios.socio.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 2, 160, 31)),
                  ),
                  Text(
                    'IDSocio: ${filtroUsuario[index].idmaesocios.idsocio} ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(112, 0, 19, 229)),
                  ),
                  Row(
                    children: [
                      Text(
                        'N° pagaré: ${filtroUsuario[index].nrodocpagare} ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(112, 0, 19, 229)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'V: $m ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(112, 0, 19, 229)),
                      ),
                    ],
                  ),
                  Text(
                    'N° Documento: ${filtroUsuario[index].idmaesocios.nrodocumento} ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color.fromARGB(255, 137, 137, 137)),
                  ),
                  Text(
                    '${filtroUsuario[index].denominacion} ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color.fromARGB(255, 137, 137, 137)),
                  ),
                  Text(
                    'Estado: ${filtroUsuario[index].idestadodoc.estado} ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color.fromARGB(255, 137, 137, 137)),
                  ),
                  Text(
                    'Monto desenbolsado: ${filtroUsuario[index].monto_aprobado} ',
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'Plazo: ${filtroUsuario[index].plazo_apro} ',
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'Saldo actual: ${filtroUsuario[index].saldo} ',
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'N° Cuotas vencidas: ${filtroUsuario[index].detalle_cuenta_credito!.cvencidas} ',
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ]),
              ),
              leading: const Icon(
                Icons.person_2_outlined,
                color: Color.fromARGB(148, 2, 128, 6),
                size: 40,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Color.fromARGB(255, 2, 199, 2),
              ),
              contentPadding: const EdgeInsets.all(2),
            ),
          ),
        );
      },
    );
  }
}
