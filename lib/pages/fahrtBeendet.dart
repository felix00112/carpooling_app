import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import 'package:carpooling_app/constants/sizes.dart';
import '../services/rating_service.dart'; // Importiere den RatingService

class FahrtBeendet extends StatefulWidget {
  final Map<String, dynamic> rideDetails;
  const FahrtBeendet({super.key, required this.rideDetails});

  @override
  _FahrtBeendetState createState() => _FahrtBeendetState();
}

class _FahrtBeendetState extends State<FahrtBeendet> with SingleTickerProviderStateMixin {
  int _rating = 1; // Rating Wert für die Fahrt
  String _feedback = ''; // Text Feedback für die Fahrt
  final TextEditingController _feedbackController = TextEditingController(); // Controller für das Textfeld
  final RatingService _ratingService = RatingService(); // Instanz des RatingService

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return SafeArea(
      child: Scaffold(
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
                              content: Container(
                                width: Sizes.ContentWidth, // Begrenzung der Breite des Popups
                                child: Column(
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
                                        labelStyle: TextStyle(color: dark_blue), // Farbe des Labels
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: dark_blue), // Farbe der Unterstreichung
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: dark_blue), // Farbe der Unterstreichung beim Fokussieren
                                        ),
                                      ),
                                      cursorColor: dark_blue, // Farbe des Cursors
                                      style: TextStyle(color: dark_blue), // Farbe des eingegebenen Textes
                                      maxLines: 8,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Abbrechen'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: dark_blue, // Textfarbe
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      _rating = _dialogRating; // Aktualisiert den Hauptzustand
                                      _feedback = _feedbackController.text; // Speichert das zusätzliche Feedback
                                    });

                                    try {
                                      // Rufe die createRating-Methode auf
                                      await _ratingService.createRating(
                                        _rating.toDouble(), // Rating als double
                                        widget.rideDetails['driver_id'], // Fahrer-ID
                                        _feedback, // Feedback-Text
                                      );

                                      // Schließe den Dialog und navigiere zur Homepage
                                      Navigator.of(context).pop();
                                      Navigator.pushNamed(context, '/');
                                    } catch (e) {
                                      // Fehlerbehandlung
                                      print("Fehler beim Speichern des Ratings: $e");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Fehler beim Speichern des Ratings: $e"),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Absenden'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: dark_blue, // Textfarbe
                                  ),
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
                    backgroundColor: button_lightblue, // Hintergrundfarbe
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
      ),
    );
  }
}