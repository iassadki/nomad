import 'package:flutter/material.dart';

class ItinerarySectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // <---

  const ItinerarySectionCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap, // <---
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap, // <---
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF1E3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFE58A2B), size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 180,
                child: Container(color: Colors.grey[300]), // ta map
              ),
            ),
          ],
        ),
      ),
    );
  }
}
