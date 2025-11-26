import 'package:flutter/material.dart';

class TextStyles {
  // H1 - Grand titre (titres de page)
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: -0.5,
  );

  // H2 - Sous-titre principal (sections)
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    letterSpacing: -0.3,
  );

  // H3 - Sous-titre secondaire (sous-sections)
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    letterSpacing: 0,
  );

  // H4 - Petit titre (labels, cards)
  static const TextStyle h4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    letterSpacing: 0.2,
  );

  // Body - Texte normal (paragraphes)
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
    letterSpacing: 0.15,
    height: 1.5,
  );

  // Small - Petit texte (descriptions, aides)
  static const TextStyle small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
    letterSpacing: 0.1,
  );

  // Button - Texte de bouton
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}
