import 'package:flutter/material.dart';
import 'package:nomad/screens/trip_related/map.dart';
import 'package:nomad/screens/trip_related/notes.dart'; 
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../components/icon_label_card.dart';
import '../../components/custom_back_button.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/trip_card.dart';
import '../../components/trip_map_section.dart';
import '../../components/trip_simple_section.dart';
import '../../components/section_card.dart';
import '../../components/itinerary_section_card.dart';


class my_trip extends StatefulWidget {
  final dynamic trip; // Le trip sélectionné

  const my_trip({super.key, this.trip});

  @override
  State<my_trip> createState() => _my_tripState();
}

class _my_tripState extends State<my_trip> {
  int _selectedIndex = 0;
  dynamic selectedTrip;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Utiliser le trip passé en paramètre
    selectedTrip = widget.trip;
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomBackButton(margin: const EdgeInsets.only(top: 10, right: 15)),
                  const SizedBox(height: 30),

                  const Text(
                    'My Trips',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  // Afficher le trip sélectionné
                  if (selectedTrip == null)
                    const Center(
                      child: Text('Aucun voyage trouvé'),
                    )
                  else
                    TripCard(
                      title: selectedTrip['destination'] ?? 'Unknown',
                      dateRange: 'From ${selectedTrip['startDate']} to ${selectedTrip['endDate']}',
                      onTap: () {
                        // Action au clic sur la carte de voyage
                      },
                    ),

                  const SizedBox(height: 15),

                  ItinerarySectionCard(
                    icon: LucideIcons.map,
                    label: "Itinerary",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(trip: selectedTrip),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  SectionCard(
                    icon: LucideIcons.stickyNote,
                    label: "Note of the trip",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotesPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        context: context,
      ),
    );
  }
}