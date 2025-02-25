import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';

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
  final TextEditingController _colorController = TextEditingController(); // Controller für Farbe

  @override
  void dispose() {
    _licensePlateController.dispose();
    _modelController.dispose();
    _colorController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
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
        },
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
                  width: Sizes.width,
                  height: Sizes.height, 
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // Platz über Überschrift
              Text(
                "Mein Auto",
                style: TextStyle(
                  fontSize: Sizes.textSizeRegular,
                  fontWeight: FontWeight.w900,
                  color: dark_blue,
                ),
              ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingMediumLarge),
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
                    TextField(
                      controller: _colorController,
                      decoration: InputDecoration(
                        labelText: 'Farbe',
                        labelStyle: TextStyle(color: Colors.grey), // Standardfarbe des Labels
                        floatingLabelStyle: TextStyle(color: button_blue), // Farbe des Labels, wenn fokussiert
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: button_blue),
                        ),
                      ),
                      cursorColor: button_blue,
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