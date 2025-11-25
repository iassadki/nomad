import 'package:flutter/material.dart';

class IconLabelCard extends StatelessWidget {
  final Widget icon; // Slot pour l'icône (flexible)
  final String label; // Texte
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap; // Optionnel pour rendre clickable

  const IconLabelCard({
    Key? key,
    required this.icon,
    required this.label,
    this.backgroundColor = const Color(0xFFFFF4E6),
    this.iconColor = const Color(0xFFFF8D2E),
    this.textColor = Colors.black87,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône à gauche
            icon,
            const SizedBox(width: 12),
            // Texte
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
