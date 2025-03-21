import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*
Callable like this:
CustomTextField(
  labelText: 'Enter your email',
  icon: Icons.email,
  backgroundColor: Colors.grey[200]!,
  labelTextStyle: const TextStyle(
    color: Colors.blue,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),

Callable like this:
CustomTextField(
  labelText: 'Enter your email',
  svgIconPath: 'assets/icons/email_icon.svg',
  backgroundColor: Colors.grey[200]!,
  labelTextStyle: const TextStyle(
    color: Colors.blue,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),


wenn du nur svg file laden willst dann benutz das hier in deinem code.
beachte das du flutter.svg  importieren musst wie oben:

body: Center(
          child: SvgPicture.asset(
            'assets/icons/user.svg', // Der Pfad zu deiner SVG-Datei
            width: 100,  // Die Breite des SVGs
            height: 100, // Die Höhe des SVGs
          ),
        ),


*/

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData? icon; // Optionales Icon für Material-Icons
  final String? svgIconPath; // Optionaler Pfad zu einer SVG-Datei
  final Color backgroundColor; // Hintergrundfarbe für das Textfeld
  final TextStyle? labelTextStyle; // Benutzerdefinierte Textstyle für das Label

  const CustomTextField({
    super.key,
    required this.labelText,
    this.icon,
    this.svgIconPath,
    this.backgroundColor = Colors.transparent, // Standard: Transparenter Hintergrund
    this.labelTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8), // Abgerundete Ecken für das Container
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelTextStyle, // Benutzerdefinierte Textstyle für das Label
          prefixIcon: svgIconPath != null
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(svgIconPath!, width: 24, height: 24),
          )
              : (icon != null ? Icon(icon) : null), // Fallback zu IconData, wenn SVG nicht vorhanden
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Abgerundete Ecken für das Textfeld
            //borderSide: BorderSide.none, // Entferne die Standard-Rahmenlinie
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}
