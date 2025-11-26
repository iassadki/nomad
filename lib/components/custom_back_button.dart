import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final IconData icon;
  final EdgeInsets margin;
  
  const CustomBackButton({
    Key? key,
    this.onPressed,
    this.backgroundColor = const Color(0xFFFFF4E6),
    this.iconColor = const Color(0xFFFF8D2E),
    this.size = 50,
    this.margin = const EdgeInsets.all(0),
    this.icon = Icons.chevron_left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: onPressed ?? () => Navigator.of(context).pop(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: size * 0.5),
        ),
      ),
    );
  }
}
