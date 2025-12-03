import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Composant 1 : Section avec carte (Itinerary)
class TripMapSection extends StatelessWidget {
  final String title;
  final VoidCallback? onAddPressed;
  final VoidCallback? onLocationPressed;
  final Widget? mapWidget; // Pour mettre une vraie carte plus tard

  const TripMapSection({
    super.key,
    required this.title,
    this.onAddPressed,
    this.onLocationPressed,
    this.mapWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D5C4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec titre et icônes
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Icône location/directions
                GestureDetector(
                  onTap: onLocationPressed,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.near_me,
                      size: 20,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Icône add
                // GestureDetector(
                //   onTap: onAddPressed,
                //   child: Container(
                //     padding: const EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(
                //       Icons.add,
                //       size: 20,
                //       color: Color(0xFFFF6B35),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // Zone de la carte
          Container(
            height: 150,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: mapWidget ??
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: const LatLng(41.1579, -8.6291), // Porto, Portugal
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
                            point: const LatLng(41.1579, -8.6291),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFFFF6B35),
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
