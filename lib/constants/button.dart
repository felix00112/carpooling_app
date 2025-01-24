import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';

/*
callable like this:
CustomButton(
              label: 'Submit',
              onPressed: () {
                final inputText = _inputController.text;
                if (inputText.isNotEmpty) {
                  print('Input: $inputText');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Submitted: $inputText')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter some text!')),
                  );
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              borderRadius: 12,
              height: 50,
            ),
 */

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon; // Optional icon
  final Color color; // Background color of the button
  final Color textColor; // Color of the text and icon
  final double borderRadius;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = button_blue,
    this.textColor = Colors.white, // Default text color is white
    this.borderRadius = 10.0,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: width == null ? 24 : 0, // Default horizontal padding if no width is provided
            vertical: height == null ? 12 : 0, // Default vertical padding if no height is provided
          ),
        ),
        child: icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor), // Icon uses customizable text color
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: textColor), // Text uses customizable text color
            ),
          ],
        )
            : Text(
          label,
          style: TextStyle(color: textColor), // Text uses customizable text color
        ),
      ),
    );
  }
}