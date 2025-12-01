import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const FloatingAddButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFFFF6B35),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? const Color(0xFFFF6B35)).withOpacity(
                0.3,
              ),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: iconColor ?? Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
