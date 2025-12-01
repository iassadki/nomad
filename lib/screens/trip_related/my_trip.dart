import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../components/icon_label_card.dart';
import '../../components/custom_back_button.dart';
import '../../components/bottom_nav_bar.dart';
// import '../../components/button_primary.dart';
import '../../components/trip_card.dart';
import '../../components/trip_map_section.dart';
import '../../components/trip_simple_section.dart';

class my_trip extends StatefulWidget {
  const my_trip({super.key});

  @override
  State<my_trip> createState() => _my_tripState();
}

class _my_tripState extends State<my_trip> {
  int _selectedIndex = 0;

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomBackButton(margin: const EdgeInsets.only(top: 10, right: 15)),
            const SizedBox(height: 30),

            const Text(
              'My Trip In [City]',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TripCard(
              title: 'Porto',
              dateRange: 'From [start date] to [end date]',
              onTap: () {
                // Action au clic
              },
            ),

            const SizedBox(height: 15),

            // IconLabelCard(
            //   icon: Icon(
            //     LucideIcons.mapPin,
            //     color: Color(0xFFFF8D2E),
            //     size: 24,
            //   ),
            //   label: 'Map of the city',
            //   onTap: () {
            //     print('Destination cliquée');
            //   },
            // ),

            TripMapSection(
              title: 'Porto, Portugal',
              onLocationPressed: () {
                print('Map tapped');
              },
            ),

            const SizedBox(height: 15),

            TripSimpleSection(
              title: 'Note of the trip',
              onAddPressed: () {
                print('Add note clicked');
              },
            ),

            const Spacer(),

            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Go back'),
              ),
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