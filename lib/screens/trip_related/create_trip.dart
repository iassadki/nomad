import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
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

  // ⬇️ AJOUTE CETTE LIGNE POUR LE DROPDOWN ⬇️
  String? _selectedDestination;

  final TextEditingController _startAddressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _startAddressController.dispose();
    _dateController.dispose();
    super.dispose();
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

            Align(
              alignment: Alignment.centerLeft,
              child: FloatingButton(
                navigationRoute: '/create_trip',
                child: Icon(LucideIcons.chevronLeft, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Create a Trip', style: TextStyles.h1),

            const SizedBox(height: 20),

            const Text('Destination', style: TextStyles.h4),

            const SizedBox(height: 10),

            // ⬇️ DROPDOWN MENU POUR LA DESTINATION ⬇️
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                value: _selectedDestination,
                hint: Text('Select destination'),
                isExpanded: true,
                underline: SizedBox(),
                icon: Icon(LucideIcons.chevronDown, color: Colors.blue),
                items: ['Porto', 'Lisboa'].map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDestination = newValue;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text('Starting address (optional)', style: TextStyles.h4),

            InputTextField(
              controller: _startAddressController,
              hintText: 'Starting address',
              icon: LucideIcons.search,
              iconColor: Colors.blue,
              onChanged: (value) {
                print('Recherche: $value');
              },
            ),

            const SizedBox(height: 20),

            const Text('Date of your trip', style: TextStyles.h4),

GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  setState(() {
                    _dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
              child: AbsorbPointer(
                child: InputTextField(
                  controller: _dateController,
                  hintText: 'Date of your trip',
                  icon: LucideIcons.calendar,
                  iconColor: Colors.blue,
                  onChanged: (value) {},
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ButtonPrimary(
                label: 'Create Trip',
                onPressed: () {
                  // Récupère les données
                  final tripData = {
                    'destination':
                        _selectedDestination ??
                        '', // ⬅️ Utilise la destination sélectionnée
                    'startAddress': _startAddressController.text,
                    'date': _dateController.text,
                  };

                  // Envoie vers la page suivante
                  Navigator.pushNamed(context, '/trips', arguments: tripData);
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
