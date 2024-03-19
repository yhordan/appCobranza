import 'package:app_leon_xiii/pages/pantalla_direcciones.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoieWhvcmRhbjE3IiwiYSI6ImNsbm5xdmlhMjA3cjEyc3FqZmZzN29rMXEifQ.8Y7VwtJkrqW2shDTR7PtrQ';
//final MyPosition = LatLng(40.697488, -73.979681);

// ignore: must_be_immutable
class Mapa extends StatelessWidget {
  double longitud = 0.0;
  double latitud = 0.0;
  String nombre = '';
  Mapa(this.longitud, this.latitud, this.nombre, {super.key});

  @override
  Widget build(BuildContext context) {
    final posicion = LatLng(longitud, latitud);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        toolbarHeight: 0,
        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
        centerTitle: true,
        title: const Text(
          'Mis rutas',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color.fromARGB(255, 253, 253, 253)),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        child: Consumer<DirectionProvider>(
          builder:
              (BuildContext context, DirectionProvider api, Widget? child) {
            return Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: posicion,
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                        markerId: const MarkerId('Id'),
                        position: LatLng(longitud, latitud),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                        infoWindow: InfoWindow(title: nombre)),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
