import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/input_text_field.dart';
import '../../constants/text_styles.dart';
import '../../components/floating_button.dart';
import '../../components/button_primary.dart';
import '../../services/trips_state.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  int _selectedIndex = 0;

  // ⬇️ AJOUTE CETTE LIGNE POUR LE DROPDOWN ⬇️
  String? _selectedDestination;

  final TextEditingController _startAddressController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  @override
  void dispose() {
    _startAddressController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _createTrip() async {
    // Validation
    if (_selectedDestination == null || _selectedDestination!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination')),
      );
      return;
    }

    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }

    // Coordonnées par défaut selon la destination
    final Map<String, Map<String, double>> coordinates = {
      'Porto': {'latitude': 41.1579, 'longitude': -8.6291},
      'Lisboa': {'latitude': 38.7223, 'longitude': -9.1393},
    };

    // Créer le nouveau voyage
    final newTrip = {
      'destination': _selectedDestination,
      'startDate': _startDateController.text,
      'endDate': _endDateController.text,
      // 'startingAddress': _startAddressController.text.isEmpty ? null : _startAddressController.text,
      'latitude': coordinates[_selectedDestination]?['latitude'] ?? 0.0,
      'longitude': coordinates[_selectedDestination]?['longitude'] ?? 0.0,
    };

    print('========== NOUVEAU VOYAGE CRÉÉ ==========');
    print('Voyage: ${jsonEncode(newTrip)}');
    print('=========================================');

    // Sauvegarder le trip
    print('Avant addTrip');
    TripsState().addTrip(newTrip);
    print('Après addTrip');

    // Afficher un message de succès
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip created successfully!')),
      );

      // Rediriger vers la page trips après 1 seconde
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        // Vider les champs
        _selectedDestination = null;
        _startAddressController.clear();
        _startDateController.clear();
        _endDateController.clear();
        
        Navigator.pushReplacementNamed(context, '/trips');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 100),

            Align(
              alignment: Alignment.centerLeft,
              child: FloatingButton(
                navigationRoute: '/CreateTrip',
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
                hint: const Text('Select destination'),
                isExpanded: true,
                underline: const SizedBox(),
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

            // const Text('Starting address (optional)', style: TextStyles.h4),

            // InputTextField(
            //   controller: _startAddressController,
            //   hintText: 'Starting address',
            //   icon: LucideIcons.search,
            //   iconColor: Colors.blue,
            //   onChanged: (value) {
            //     print('Recherche: $value');
            //   },
            // ),

            const SizedBox(height: 20),

            const Text('Start date', style: TextStyles.h4),

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
                    _startDateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
              child: AbsorbPointer(
                child: InputTextField(
                  controller: _startDateController,
                  hintText: 'Start date',
                  icon: LucideIcons.calendar,
                  iconColor: Colors.blue,
                  onChanged: (value) {},
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text('End date', style: TextStyles.h4),

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
                    _endDateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
              child: AbsorbPointer(
                child: InputTextField(
                  controller: _endDateController,
                  hintText: 'End date',
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
                onPressed: _createTrip,
              ),
            ),

            const SizedBox(height: 20),
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
