import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.title,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5E9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8D5C4), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            // Ligne de séparation
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 1,
              color: Colors.black26,
            ),

            // Contenu de la note
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
