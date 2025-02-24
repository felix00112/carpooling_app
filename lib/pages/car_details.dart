import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import für File
import 'package:flutter/foundation.dart' show kIsWeb; // Import für kIsWeb
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import für Color Picker

import '../constants/constants.dart';

class CarDetailsPage extends StatefulWidget {
  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  // Navigation bar index
  int _currentIndex = 2;

  // Input field controllers
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();

  // Color picker
  Color _selectedColor = Colors.blue;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigation zu den entsprechenden Seiten basierend auf dem Index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/fahrten');
        break;
      case 2:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Farbe auswählen'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Fertig'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      appBar: AppBar( //header
        backgroundColor: background_grey,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrowLeft.svg',
            height: 24,
            colorFilter: ColorFilter.mode(dark_blue, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context); // Zurück-Navigation
          },
        ),
        title: Text(
          'Einstellungen',
          style: TextStyle(color: dark_blue),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header image and illustration
            Container(
              height: 200,
              decoration: BoxDecoration( //box around picture
                //color: background_box_white,
                borderRadius: BorderRadius.circular(Sizes.borderRadius10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_city_driver.svg',
                  width: Sizes.width, // Passe Breite an
                  height: Sizes.height, // Passe Höhe an
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // Platz über Überschrift
            Padding(
              padding: EdgeInsets.all(Sizes.paddingBig),
              child: Text(
                "Mein Auto",
                style: TextStyle(
                  fontSize: Sizes.textSizeRegular,
                  fontWeight: FontWeight.w900,
                  color: dark_blue,
                ),
              ),
            ),
            // Hier implementieren
            Padding(
              padding: EdgeInsets.all(Sizes.paddingRegular),
              child: Container(
                padding: EdgeInsets.all(Sizes.paddingRegular),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Sizes.borderRadius10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _licensePlateController,
                      decoration: InputDecoration(
                        labelText: 'Kennzeichen',
                        labelStyle: TextStyle(color: Colors.grey), // Standardfarbe des Labels
                        floatingLabelStyle: TextStyle(color: button_blue), // Farbe des Labels, wenn fokussiert
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: button_blue),
                        ),
                      ),
                      cursorColor: button_blue,
                    ),
                    SizedBox(height: Sizes.paddingRegular),
                    TextField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'Modell',
                        labelStyle: TextStyle(color: Colors.grey), // Standardfarbe des Labels
                        floatingLabelStyle: TextStyle(color: button_blue), // Farbe des Labels, wenn fokussiert
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: button_blue),
                        ),
                      ),
                      cursorColor: button_blue,
                    ),
                    SizedBox(height: Sizes.paddingRegular),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickColor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: button_lightblue, // Hintergrundfarbe des Buttons
                            foregroundColor: Colors.white, // Textfarbe des Buttons
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Sizes.borderRadius10), // Abrundung des Buttons
                            ),
                          ),
                          child: Text('Farbe auswählen'),
                        ),
                        SizedBox(width: Sizes.paddingRegular), // Abstand zwischen Button und Container
                        Container(
                          height: 50,
                          width: 50,
                          color: _selectedColor,
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.paddingRegular),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: button_lightblue, // Hintergrundfarbe des Buttons
                            foregroundColor: Colors.white, // Textfarbe des Buttons
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Sizes.borderRadius10), // Abrundung des Buttons
                            ),
                          ),
                          child: Text('Foto hochladen'),
                        ),
                        SizedBox(width: Sizes.paddingRegular), // Abstand zwischen Button und Bild
                        if (_imageFile != null)
                          kIsWeb
                              ? Image.network(
                                  _imageFile!.path,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(_imageFile!.path),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}