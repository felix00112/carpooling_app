import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import 'package:carpooling_app/constants/sizes.dart';

class FahrtBeendet extends StatefulWidget {
  const FahrtBeendet({super.key});

  @override
  _FahrtBeendetState createState() => _FahrtBeendetState();
}

class _FahrtBeendetState extends State<FahrtBeendet> with SingleTickerProviderStateMixin {
  int _rating = 1; // Initialer Wert auf 1 gesetzt
  String _feedback = ''; // Variable für zusätzliches Feedback
  final TextEditingController _feedbackController = TextEditingController(); // Controller für das Textfeld

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Sizes.paddingSmall), // allgemeiner Rand zwischen Inhalt und Handyrand
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: Sizes.topBarHeight,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_completing_gsf8.svg',
                  width: 700,
                  height: 700,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // Platz über Überschrift
            Center(
              child: Text(
                "Fahrt Beendet!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: dark_blue,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // Platz unter Überschrift
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _feedbackController.text = _feedback; // Setzt den gespeicherten Text in den Controller
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      int _dialogRating = _rating; // Lokale Variable für den Dialogzustand
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Feedback abgeben'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Bitte bewerten Sie Ihre Fahrt:'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return IconButton(
                                      icon: Icon(
                                        index < _dialogRating ? Icons.star : Icons.star_border,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _dialogRating = index + 1;
                                        });
                                      },
                                    );
                                  }),
                                ),
                                TextField(
                                  controller: _feedbackController,
                                  decoration: InputDecoration(
                                    labelText: 'Zusätzliches Feedback',
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Abbrechen'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _rating = _dialogRating; // Aktualisiert den Hauptzustand
                                    _feedback = _feedbackController.text; // Speichert das zusätzliche Feedback
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text('Absenden'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark_blue, // Hintergrundfarbe
                  foregroundColor: Colors.white, // Textfarbe
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Innenabstand
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Feedback abgeben'),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // Platz unter dem ersten Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/'); // Navigiert zur Homepage
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark_blue, // Hintergrundfarbe
                  foregroundColor: Colors.white, // Textfarbe
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Innenabstand
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Zurück zur Homepage'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}