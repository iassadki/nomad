import 'package:flutter/material.dart';

class TripSimpleSection extends StatelessWidget {
  final String title;
  final VoidCallback? onAddPressed;

  const TripSimpleSection({super.key, required this.title, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D5C4), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 24, color: Color(0xFFFF6B35)),
            ),
          ),
        ],
      ),
    );
  }
}