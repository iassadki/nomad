import 'package:flutter/material.dart';
import '../../components/bottom_nav_bar.dart';
import '../../constants/text_styles.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // CustomBackButton(margin: const EdgeInsets.only(top: 10, right: 15)),
            const SizedBox(height: 30),

            const Text(
              'Profile',
              style: TextStyles.h1,
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
