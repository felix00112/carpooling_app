import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';

import '../constants/button2.dart';
import '../constants/sizes.dart';
import '../services/car_service.dart';

class CarDetailsPage extends StatefulWidget {
  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  // Navigation bar index
  int _currentIndex = 2;
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

  Map<String, dynamic>? carData;

  @override
  void initState() {
    super.initState();
    _fetchCarData();
  }

  Future<void> _fetchCarData() async {
    final carService = CarService();
    final data = await carService.getCar();
    final car = data.first;
    setState(() {
      carData = car;
      _licensePlateController.text = car['license_plate'];
      _modelController.text = car['car_name'];
      _colorController.text = car['colour'];
    });
    print("Car Data: $carData.toString()");
  }

  Future<void> saveCarChanges() async {
    try{
      Map<String, dynamic> updates = {
        'license_plate': _licensePlateController.text,
        'car_name': _modelController.text,
        'colour': _colorController.text,
      };
      final carService = CarService();
      if(carData != null) {
        await carService.updateCarData(updates);
      } else {
        await carService.createCar(
        _modelController.text,
        _licensePlateController.text,
        _colorController.text,
        4,
      );
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auto erfolgreich aktualisiert")),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fehler beim Aktualisieren des Autos: $e")),
      );
    }
  }


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
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),

        appBar: AppBar( //header
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context); // Zurück-Navigation
            },
          ),
          title: Text(
            'Mein Auto',
            style: TextStyle(fontSize: Sizes.textHeading),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular, vertical: Sizes.paddingSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header image and illustration
                SizedBox(
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/undraw_city_driver.svg',
                      width: Sizes.deviceWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                /*Text(
                  "Mein Auto",
                  style: TextStyle(
                    fontSize: Sizes.textSubheading,
                    fontWeight: FontWeight.bold,
                    color: dark_blue,
                  ),
                ),*/
                SizedBox(height: Sizes.paddingRegular),

                Container(
                  padding: EdgeInsets.all(Sizes.paddingRegular),
                  decoration: BoxDecoration(
                    color: background_box_white,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _licensePlateController,
                        decoration: InputDecoration(
                          labelText: 'Kennzeichen',
                          labelStyle: TextStyle(color: dark_blue), // Standardfarbe des Labels
                          floatingLabelStyle: TextStyle(color: button_blue), // Farbe des Labels, wenn fokussiert
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: button_blue),
                          ),
                        ),
                      ),
                      SizedBox(height: Sizes.paddingRegular),
                      TextField(
                        controller: _modelController,
                        decoration: InputDecoration(
                          labelText: 'Modell',
                          labelStyle: TextStyle(color: dark_blue), // Standardfarbe des Labels
                          floatingLabelStyle: TextStyle(color: button_blue), // Farbe des Labels, wenn fokussiert
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: button_blue),
                          ),
                        ),
                      ),
                      SizedBox(height: Sizes.paddingRegular),
                      TextField(
                        controller: _colorController,
                        decoration: InputDecoration(
                          labelText: 'Farbe',
                          labelStyle: TextStyle(color: dark_blue), // Standardfarbe des Labels
                          floatingLabelStyle: TextStyle(color: button_blue), // Farbe des Labels, wenn fokussiert
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: button_blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Sizes.paddingRegular),

                CustomButton2(
                  label: 'Speichern',
                  onPressed: saveCarChanges,
                  color: button_blue,
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.925,
                  height: MediaQuery.of(context).size.width * 0.12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}