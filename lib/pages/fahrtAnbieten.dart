import 'package:carpooling_app/pages/fahrtFahrerin.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/textField.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:intl/intl.dart';
import '../constants/button2.dart';
import '../constants/sizes.dart';
import 'package:carpooling_app/services/ride_service.dart';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:latlong2/latlong.dart';

import 'package:carpooling_app/services/ride_service.dart';


class OfferRidePage extends StatefulWidget {
  final String Starteingabe;
  final String Zieleingabe;
  final String Zeitpunkt;
  const OfferRidePage({super.key, required this.Starteingabe, required this.Zieleingabe, required this.Zeitpunkt});

  @override
  _OfferRidePageState createState() => _OfferRidePageState();
}

class _OfferRidePageState extends State<OfferRidePage> {
  bool _isLuggageAllowed = true;
  bool _isPetAllowed = false;
  int _freeSeats = 1;
  int _stops = 0;
  bool _useOwnCar = true;
  final Set<String> _selectedPaymentMethods = {};
  final RideService _rideService = RideService();
  String _startLabel = "Start";
  String _zielLabel = "Ziel";
  LatLng? _startMarker;
  LatLng? _destinationMarker;

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

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

  void initState() {
    super.initState();
    print("Empfangener Startwert: ${widget.Starteingabe}");
    print("Empfangener Zielwert: ${widget.Zieleingabe}");
    _getDestAddress(widget.Zieleingabe);
    _getStartAddress(widget.Starteingabe);
    printAllRides();
  }

  Future<void> printAllRides() async {
    try {
      final rides = await _rideService.getAllRides(); // Rufe alle Fahrten ab
      print("Alle Fahrten:");
      for (var ride in rides) {
        print(ride); // Gib jede Fahrt in der Konsole aus
      }
    } catch (e) {
      print("Fehler beim Abrufen der Fahrten: $e");
    }
  }

  void _getDestAddress(String address) async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions =
      await geoCoder.getAddressSuggestions(address: address);
      if (suggestions.isNotEmpty) {
        LookupAddress suggestion = suggestions.first;
        setState(() {
          _destinationMarker = LatLng(
            double.parse(suggestion.latitude),
            double.parse(suggestion.longitude),
          );
          _zielLabel = suggestion.displayName;
        });
      }
    } catch (e) {
      print("Fehler beim Geocoding: $e");
    }
  }

  void _getStartAddress(String address) async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions =
      await geoCoder.getAddressSuggestions(address: address);
      if (suggestions.isNotEmpty) {
        LookupAddress suggestion = suggestions.first;
        setState(() {
          _startMarker = LatLng(
            double.parse(suggestion.latitude),
            double.parse(suggestion.longitude),
          );
          _startLabel = suggestion.displayName;
        });
      }
    } catch (e) {
      print("Fehler beim Geocoding: $e");
    }
  }

  String convertToSupabaseFormat(String inputDate) {
    // Input format (2025-02-23 – 12:48)
    DateFormat inputFormat = DateFormat("yyyy-MM-dd – HH:mm");

    // Parse Date Object
    DateTime parsedDate = inputFormat.parse(inputDate);

    // Transform in desired format (2025-02-22 20:00:00+00)
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss'+00'");

    return outputFormat.format(parsedDate);
  }

  void _onOfferRide() async {
    // Hole alle Werte, die du für createRide benötigst
    String start = _startLabel;
    print("start: ");
    print(_startLabel);
    String stop = _zielLabel;
    print("ziel: ");
    print(_zielLabel);
    // Hier sicherstellen, dass das Datum korrekt formatiert ist
    String date = convertToSupabaseFormat(widget.Zeitpunkt);  // Beispiel: "2025-02-22T20:00:00"
    int seats = _freeSeats;
    bool flintaOnly = false; // Beispielwert
    bool petsAllowed = _isPetAllowed;
    bool luggageAllowed = _isLuggageAllowed;
    int maxStops = _stops;
    List<String> paymentMethods = _selectedPaymentMethods.toList();
    print("paymentMEthods: ");
    print(paymentMethods);

    try {
      // Rufe die Methode auf, um die Fahrt zu erstellen
      await _rideService.createRide(
        start,
        stop,
        date,
        seats,
        flintaOnly,
        petsAllowed,
        luggageAllowed,
        maxStops,
        paymentMethods,
      );

      // Zeige eine Erfolgsmeldung an
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fahrt erfolgreich angeboten!')),
      );
    } catch (e) {
      // Zeige eine Fehlermeldung an, falls die Fahrt nicht erstellt werden konnte
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Erstellen der Fahrt: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fahrt anbieten",
          style: TextStyle(
            fontSize: Sizes.textHeading,
            fontWeight: FontWeight.bold,
            color: dark_blue,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: Sizes.paddingRegular), // Hier den Abstand verringern
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Verhindert zu viel vertikalen Abstand
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.925,
                padding: EdgeInsets.all(Sizes.paddingRegular),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mitnahme:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          DropdownButton<String>(
                            value: 'Alle',
                            items: const [
                              DropdownMenuItem(value: 'Alle', child: Text('Alle')),
                              DropdownMenuItem(value: 'Flinta*', child: Text('Nur Flinta*')),
                            ],
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Freie Plätze:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          DropdownButton<int>(
                            value: _freeSeats,
                            items: List.generate(
                              7,
                                  (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _freeSeats = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Gepäck:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _isLuggageAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isLuggageAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Ja'),
                              Radio<bool>(
                                value: false,
                                groupValue: _isLuggageAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isLuggageAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Nein'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tiermitnahme:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _isPetAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isPetAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Ja'),
                              Radio<bool>(
                                value: false,
                                groupValue: _isPetAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isPetAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Nein'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Zwischenstopps:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          DropdownButton<int>(
                            value: _stops,
                            items: List.generate(
                              8,
                                  (index) => DropdownMenuItem(
                                value: index,
                                child: Text(index == 0 ? 'Keine' : '$index'),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _stops = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fahrzeug:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _useOwnCar,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _useOwnCar = value!;
                                  });
                                },
                              ),
                              const Text('Eigenes'),
                              Radio<bool>(
                                value: false,
                                groupValue: _useOwnCar,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _useOwnCar = value!;
                                  });
                                },
                              ),
                              const Text('Neues Fahrzeug'),
                            ],
                          ),
                        ],
                      ),
                      if (!_useOwnCar)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(labelText: 'Kennzeichen', backgroundColor: Colors.grey),
                            SizedBox(height: Sizes.paddingSmall),
                            CustomTextField(labelText: 'Autofarbe', backgroundColor: Colors.grey),
                            SizedBox(height: Sizes.paddingSmall),
                            CustomTextField(labelText: 'Automodell', backgroundColor: Colors.grey),
                          ],
                        ),
                      SizedBox(height: Sizes.paddingSmall),
                      Text('Zahlungsmittel:', style: TextStyle(fontSize: Sizes.textSubheading)),
                      Wrap(
                        spacing: Sizes.paddingSmall,
                        children: [
                          _buildSelectableButton('cash'),
                          _buildSelectableButton('paypal'),
                          _buildSelectableButton('card'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Sizes.paddingRegular),
              _buildButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.paddingSmall),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomButton2(
            label: 'Fahrt anbieten',
            onPressed: () {
              _onOfferRide(); // Der tatsächliche Aufruf der Methode
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    RideDetailsPage(Starteingabe: widget.Starteingabe,
                        Zieleingabe: widget.Zieleingabe)),
              );
            },
            color: button_blue,
            textColor: Colors.white,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.925,
            height: MediaQuery
                .of(context)
                .size
                .width * 0.12,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableButton(String label) {
    final isSelected = _selectedPaymentMethods.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedPaymentMethods.remove(label);
          } else {
            _selectedPaymentMethods.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? dark_blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}