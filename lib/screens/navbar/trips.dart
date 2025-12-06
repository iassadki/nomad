import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/floating_button.dart';
import '../../components/trip_card.dart';
import '../../constants/text_styles.dart';

class trips extends StatefulWidget {
  const trips({super.key});

  @override
  State<trips> createState() => _tripsState();
}

class _tripsState extends State<trips> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),

                    // Titre My Trips
                    const Text('My Trips', style: TextStyles.h1),

                    const SizedBox(height: 24),

                    // Boucle sur les trips
                    if (trips.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.luggage_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "You don't have a trip yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Create one by clicking on +',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: trips.length,
                          itemBuilder: (context, index) {
                            final trip = trips[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TripCard(
                                title: trip['destination'] ?? 'Unknown',
                                dateRange: 'From ${trip['startDate']} to ${trip['endDate']}',
                                onTap: () {
                                  Navigator.pushNamed(context, '/my_trip');
                                },
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Bouton plus flottant
                    Align(
                      alignment: Alignment.centerRight,
                      child: FloatingButton(
                        navigationRoute: '/create_trip',
                      ),
                    ),
                  ],
                ),
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
