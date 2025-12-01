import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/bottom_nav_bar.dart';
import '../../../components/input_text_field.dart';
import '../../../constants/text_styles.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // CustomBackButton(margin: const EdgeInsets.only(top: 10, right: 15)),
            const SizedBox(height: 30),

            const Text('Destination', style: TextStyles.h1),

            InputTextField(
              hintText: 'Destination',
              icon: LucideIcons.user,
              iconColor: Colors.blue,
              onChanged: (value) {
                print('Recherche: $value');
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
