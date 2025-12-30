import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Color iconColor;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const InputTextField({
    super.key,
    this.hintText = 'Enter a Search term',
    this.icon = LucideIcons.search,
    this.iconColor = const Color.fromARGB(255, 0, 0, 0),
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: iconColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ),
      ),
    );
  }
}
