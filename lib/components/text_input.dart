import 'package:flutter/material.dart';

class text_input extends StatelessWidget {
  final Widget icon; // Slot pour n'importe quelle icône
  final String placeholder;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Color backgroundColor;
  final Color textColor;
  final Color placeholderColor;
  final double borderRadius;
  final EdgeInsets? padding;

  const text_input({
    Key? key,
    required this.icon,
    required this.placeholder,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.backgroundColor = const Color(0xFFE8E8E8),
    this.textColor = Colors.black87,
    this.placeholderColor = Colors.black45,
    this.borderRadius = 30,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: placeholderColor, fontSize: 16),
          prefixIcon: Padding(
            padding: padding ?? const EdgeInsets.only(left: 20, right: 15),
            child: icon,
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 50, minHeight: 24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
