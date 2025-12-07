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
  const my_trip({super.key});

  @override
  State<my_trip> createState() => _my_tripState();
}

class _my_tripState extends State<my_trip> {
  int _selectedIndex = 0;
  List<dynamic> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      final String response = await rootBundle.loadString('assets/api/user_data_filled.json');
      final data = json.decode(response);
      setState(() {
        trips = data['user']['trips'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des trips: $e');
      setState(() {
        isLoading = false;
      });
    }
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

                  // Boucle sur les trips
                  if (trips.isEmpty)
                    const Center(
                      child: Text('Aucun voyage trouvé'),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: TripCard(
                              title: trip['destination'] ?? 'Unknown',
                              dateRange: 'From ${trip['startDate']} to ${trip['endDate']}',
                              onTap: () {
                                // Action au clic sur une carte de voyage
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 15),

                  ItinerarySectionCard(
                    icon: LucideIcons.map,
                    label: "Itinerary",
                    onTap: () {
                      Navigator.pushNamed(context, '/map');
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