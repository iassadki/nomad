import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? navigationRoute;
  final Color? backgroundColor;
  final double size;
  final Widget? child;

  const FloatingButton({
    super.key,
    this.onPressed,
    this.navigationRoute,
    this.backgroundColor,
    this.size = 56.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (navigationRoute != null) {
          Navigator.of(context).pushReplacementNamed(navigationRoute!);
        } else if (onPressed != null) {
          onPressed!();
        }
      },
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
        child: child ?? Icon(
          Icons.add,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
