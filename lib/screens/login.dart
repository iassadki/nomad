import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/text_input.dart';
import '../components/button_primary.dart';
import '../services/auth_service.dart';
import 'create_user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
    });

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/profile');
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

              // Username/Email Input
              text_input(
                icon: const Icon(
                  LucideIcons.user,
                  color: Color(0xFFFF8C42),
                  size: 24,
                ),
                placeholder: 'Username',
                controller: _usernameController,
              ),

              const SizedBox(height: 20),

              // Password Input
              text_input(
                icon: const Icon(
                  LucideIcons.lock,
                  color: Color(0xFFFF8C42),
                  size: 24,
                ),
                placeholder: 'Password',
                controller: _passwordController,
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ButtonPrimary(
                  label: _isLoading ? 'Logging in...' : 'Login',
                  onPressed: _isLoading ? () {} : _login,
                ),
              ),

              const SizedBox(height: 20),

              // Create Account Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateUser()),
                  );
                },
                child: const Text(
                  "Don't have an account? Create one",
                  style: TextStyle(
                    color: Color(0xFFFF8C42),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}