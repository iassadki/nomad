import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/text_input.dart';
import '../components/button_primary.dart';
import '../services/auth_service.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createUser() async {
    setState(() {
      _errorMessage = '';
    });

    if (_usernameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Username is required';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Password is required';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.createUser(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        // Connexion automatique
        final loginSuccess = await AuthService.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (loginSuccess && mounted) {
          Navigator.of(context).pushReplacementNamed('/profile');
        }
      } else {
        setState(() {
          _errorMessage = 'Username already exists or invalid data';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Join us on this amazing journey',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Username Input
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

                const SizedBox(height: 20),

                // Confirm Password Input
                text_input(
                  icon: const Icon(
                    LucideIcons.lock,
                    color: Color(0xFFFF8C42),
                    size: 24,
                  ),
                  placeholder: 'Confirm Password',
                  controller: _confirmPasswordController,
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
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 30),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ButtonPrimary(
                    label: _isLoading ? 'Creating...' : 'Create Account',
                    onPressed: _isLoading ? () {} : _createUser,
                  ),
                ),

                const SizedBox(height: 20),

                // Back to Login
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Already have an account? Login',
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
      ),
    );
  }
}
