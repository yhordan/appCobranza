// ignore_for_file: constant_identifier_names, library_private_types_in_public_api, unused_field, prefer_const_constructors_in_immutables, unnecessary_null_comparison, must_be_immutable, prefer_final_fields, no_logic_in_create_state, unused_local_variable
import 'dart:async';

import 'package:app_leon_xiii/models/app_cuenta_credito.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PantallaRuteo extends StatefulWidget {
  List<App_cuenta_credito> listaCuentaCredito = [];
  PantallaRuteo(this.listaCuentaCredito, {super.key});
  @override
  _PantallRuteo createState() => _PantallRuteo(listaCuentaCredito);
}

class _PantallRuteo extends State<PantallaRuteo> {
  List<App_cuenta_credito> listaCuentaCredito = [];
  _PantallRuteo(this.listaCuentaCredito);
  GoogleMapController? _controller;
  Location _location = Location();
  LocationData? _locationData;
  bool prueba = false;
  Set<Marker> _markers = {};
  late StreamSubscription<LocationData> _locationSubscription;

  @override
  void initState() {
    super.initState();
    checkLocationPermission().then((value) {
      if (mounted) {
        setState(() {
          prueba = true;
        });
      }
    });
  }

  Future<void> checkLocationPermission() async {
    final bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      final bool serviceRequested = await _location.requestService();
      if (!serviceRequested) {
        return;
      }
    }

    final PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      final PermissionStatus permissionRequested =
          await _location.requestPermission();
      if (permissionRequested != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
        _updateMarkers();
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  void _updateMarkers() {
    _markers.clear();
    if (_locationData != null) {
      final marker = Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        infoWindow: const InfoWindow(title: 'Current Location'),
      );
      _markers.add(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    for(App_cuenta_credito s in listaCuentaCredito){
      //print(s.)
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Location'),
      ),
      body: prueba == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-8.10820649374886, -79.02793571995923),
                    zoom: 15,
                  ),
                  markers: _markers,
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      _controller?.animateCamera(CameraUpdate.newLatLng(LatLng(
                          _locationData!.latitude!,
                          _locationData!.longitude!)));
                    },
                    child: const Icon(Icons.location_searching),
                  ),
                ),
              ],
            ),
    );
  }
}
