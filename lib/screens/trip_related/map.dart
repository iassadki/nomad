import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  final dynamic trip; // Le trip sélectionné
  const MapPage({Key? key, this.trip}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapController;
  // final LatLng _initialPosition = const LatLng(41.1579, -8.6291); // Porto, Portugal
  // final LatLng _initialPosition = const LatLng(38.7223, -9.1393); // Lisboa, Portugal
  late LatLng _initialPosition;
  dynamic selectedTrip; 

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    selectedTrip = widget.trip;

    _initialPosition = switch (selectedTrip?['destination']) {
      'Porto' => const LatLng(41.1579, -8.6291),
      'Lisboa' => const LatLng(38.7223, -9.1393),
      _ => const LatLng(41.1579, -8.6291), // Défaut
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: _initialPosition,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.nomad.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _initialPosition,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}