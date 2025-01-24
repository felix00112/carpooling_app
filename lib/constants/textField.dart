import 'package:flutter/material.dart';

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
*/

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData? icon; // Optional icon
  final Color backgroundColor; // Background color for the text field
  final TextStyle? labelTextStyle; // Custom text style for the label

  const CustomTextField({
    super.key,
    required this.labelText,
    this.icon,
    this.backgroundColor = Colors.transparent, // Default: Transparent background
    this.labelTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8), // Rounded corners for the container
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelTextStyle, // Corrected: Use labelStyle to customize the text style
          prefixIcon: icon != null ? Icon(icon) : null, // Add icon only if provided
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Match border radius to the container
            borderSide: BorderSide.none, // Remove default border
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}