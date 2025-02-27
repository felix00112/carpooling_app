import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';

import '../constants/constants.dart';
import '../services/car_service.dart';

class CarDetailsPage extends StatefulWidget {
  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  // Navigation bar index
  int _currentIndex = 2;

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
      child: Scaffold(
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
              ElevatedButton(
                onPressed: saveCarChanges,
                child: Text("Speichern"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}