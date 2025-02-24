import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import für File
import 'package:flutter/foundation.dart' show kIsWeb; // Import für kIsWeb

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
  final TextEditingController _colorController = TextEditingController();

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
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'Modell',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _colorController,
                      decoration: InputDecoration(
                        labelText: 'Farbe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Foto hochladen'),
                    ),
                    SizedBox(height: 16),
                    if (_imageFile != null)
                      Center(
                        child: kIsWeb
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