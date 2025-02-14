import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/sizes.dart';


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


class CustomButton2 extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;

  const CustomButton2({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.color,
    required this.textColor,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // Hier kannst du z. B. ElevatedButton, FlatButton etc. verwenden:
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Anpassbarer BorderRadius
          ),
        ),

        onPressed: onPressed,
        child: Container(
          // Begrenze den Inhalt auf 80% der Buttonbreite:
          width: width * 0.8,
          alignment: Alignment.center,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: height * 0.3, // Beispiel: Schriftgröße an die Buttonhöhe anpassen
            ),
          ),
        ),
      ),
    );
  }
}
