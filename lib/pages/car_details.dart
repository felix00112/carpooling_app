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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_city_driver.svg',
                  width: 150, // Passe Breite an
                  height: 150, // Passe Höhe an
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
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: dark_blue,
                ),
              ),
            ),
            // Hier implementieren
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _licensePlateController,
                      decoration: InputDecoration(
                        labelText: 'Kennzeichen',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: dark_blue),
                        ),
                      ),
                      cursorColor: dark_blue,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'Modell',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: dark_blue),
                        ),
                      ),
                      cursorColor: dark_blue,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickColor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dark_blue, // Hintergrundfarbe des Buttons
                            foregroundColor: Colors.white, // Textfarbe des Buttons
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Abrundung des Buttons
                            ),
                          ),
                          child: Text('Farbe auswählen'),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 50,
                          width: 50,
                          color: _selectedColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dark_blue, // Hintergrundfarbe des Buttons
                            foregroundColor: Colors.white, // Textfarbe des Buttons
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Abrundung des Buttons
                            ),
                          ),
                          child: Text('Foto hochladen'),
                        ),
                        SizedBox(width: 16),
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