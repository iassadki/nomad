import 'package:flutter/material.dart';
import '../../components/bottom_nav_bar.dart';
import '../../constants/text_styles.dart';
import '../../components/trip_card.dart';
import '../../components/button_primary.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  int _selectedIndex = 3;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 100),
            // CustomBackButton(margin: const EdgeInsets.only(top: 10, right: 15)),

            const Text(
              'Profile',
              style: TextStyles.h1,
            ),

            const SizedBox(height: 30),

            const Text('Name', style: TextStyles.h4),
            
            const Text(
              'Ilias ASSADKI',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 40),

            const Text('Trips', style: TextStyles.h4),

            const SizedBox(height: 20),

            TripCard(
              title: 'Porto',
              dateRange: 'From 20 december to 3 january',
              onTap: () {
                // Action au clic
            },
            ),

            const SizedBox(height: 20),

            // Button primary
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ButtonPrimary(
                label: 'Logout',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ButtonPrimary(
                label: 'Delete Account',
                onPressed: () {
                  // TODO: Implémenter la suppression de compte
                },
              ),
            ),

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
