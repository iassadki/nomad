import 'package:flutter/material.dart';
import '../components/custom_back_button.dart';
import '../components/bottom_nav_bar.dart';
import 'my_trip.dart';
import 'account_and_login/login.dart';

class trips_list extends StatefulWidget {
  const trips_list({super.key});

  @override
  State<trips_list> createState() => _trips_listState();
}

class _trips_listState extends State<trips_list> {
  int _selectedIndex = 1;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
        break;
      case 1:
        // Rester sur cette page
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const my_trip()),
        );
        break;
      case 3:
        // Profile
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
              'My Trips',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const my_trip()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8D2E),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Porto, from date to date',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            const Spacer(),

            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
