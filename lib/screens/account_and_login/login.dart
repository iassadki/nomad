import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../navbar/trips.dart';
import '../../components/text_input.dart';
import '../../components/button_primary.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // int _selectedIndex = 0;

  // void _onNavBarTap(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   // Navigation en fonction de l'index
  //   switch (index) {
  //     case 0:
  //       // Home - rester sur la page actuelle
  //       break;
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const trips()),
  //       );
  //       break;
  //     case 2:
  //       // My Trip
  //       break;
  //     case 3:
  //       // Profile
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Input Email
              text_input(
                icon: Icon(
                  LucideIcons.user,
                  color: Color(0xFFFF8C42),
                  size: 24,
                ),
                placeholder: 'Email / Username',
              ),

              const SizedBox(height: 20),

              // Input Password
              text_input(
                icon: Icon(
                  LucideIcons.lock,
                  color: Color(0xFFFF8C42),
                  size: 24,
                ),
                placeholder: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 30),

              // Bouton Primary
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ButtonPrimary(
                  label: 'Login',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const trips()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onNavBarTap,
      // ),
    );
  }
}