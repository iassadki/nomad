import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/bottom_nav_bar.dart';
import '../../../components/input_text_field.dart';
import '../../../constants/text_styles.dart';
import '../../../components/floating_button.dart';
import '../../../components/button_primary.dart';

class create_trip extends StatefulWidget {
  const create_trip({super.key});

  @override
  State<create_trip> createState() => _create_tripState();
}

class _create_tripState extends State<create_trip> {
  int _selectedIndex = 0;

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
            // const SizedBox(height: 30),

            // Bouton plus flottant
            Align(
              alignment: Alignment.centerLeft,
              child: FloatingButton(
                navigationRoute: '/create_trip',
                child: Icon(LucideIcons.plus, color: Colors.white),
              )
            ),
            const SizedBox(height: 20),

            const Text('Create a Trip', style: TextStyles.h1),

            const SizedBox(height: 20),

            const Text('Create a Trip', style: TextStyles.h4),

            InputTextField(
              hintText: 'Destination',
              icon: LucideIcons.search,
              iconColor: Colors.blue,
              onChanged: (value) {
                print('Recherche: $value');
              },
            ),

            const SizedBox(height: 20),

            const Text('Starting adress (optional)', style: TextStyles.h4),

            InputTextField(
              hintText: 'Destination',
              icon: LucideIcons.search,
              iconColor: Colors.blue,
              onChanged: (value) {
                print('Recherche: $value');
              },
            ),

            const SizedBox(height: 20),

            const Text('Date of your trip', style: TextStyles.h4),

            InputTextField(
              hintText: 'Destination',
              icon: LucideIcons.search,
              iconColor: Colors.blue,
              onChanged: (value) {
                print('Recherche: $value');
              },
            ),

            const SizedBox(height: 20),

            // Button primary
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ButtonPrimary(
                label: 'Create Trip',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/trips');
                },
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
