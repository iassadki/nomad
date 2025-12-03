import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // <---

  const SectionCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap, // <---
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap, // <---
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF1E3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE58A2B), size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
