import 'package:carpooling_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:carpooling_app/constants/sizes.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/button2.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart'; // Zum Öffnen der URL
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/car_service.dart';
import '../services/user_service.dart';
import '../services/rating_service.dart';
import '../services/booking_service.dart';
import 'fahrtBeendet.dart';

class RidePickupPage extends StatefulWidget {
  final String starteingabe;
  final String zieleingabe;
  final Map<String, dynamic> rideDetails;
  // Neue Eigenschaft für Fahrtdetails
  RidePickupPage({super.key, required this.starteingabe, required this.zieleingabe, required this.rideDetails});

  @override
  _RidePickupPageState createState() => _RidePickupPageState();
}

class _RidePickupPageState extends State<RidePickupPage> {
  String _startLabel = "Start";
  String _zielLabel = "Ziel";
  LatLng? _startMarker;
  LatLng? _destinationMarker;
  String? _startAddress;
  String? _destinationAddress;
  LatLng _mapCenter = LatLng(52.5200, 13.4050);
  List<LatLng> _routePoints = [];

  final CarService _carService = CarService();
  final UserService _userService = UserService();
  final RatingService _ratingService = RatingService();
  final BookingService _bookingService = BookingService();
  List<Map<String, dynamic>> _userCars = [];
  List<Map<String, dynamic>> _ratings = [];
  String? phoneNumber = "";
  double ratingValue = 0;

  int _currentIndex = 1;

  final MapController _mapController = MapController();

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

  @override
  void initState() {
    super.initState();
    _getDestAddress(widget.starteingabe);
    _getStartAddress(widget.zieleingabe);
    firstMarker();
    secondMarker();
    _fetchUserCars();
    _fetchDriverPhoneNumber();
    _fetchRatings();
    _printBookingsForRide(widget.rideDetails['id']);

  }

  Future<void> _printBookingsForRide(int rideId) async {
    try {
      // Rufe die Buchungen für die angegebene Fahrt ab
      final bookings = await _bookingService.getBookingsForRide(rideId);

      if (bookings.isNotEmpty) {
        // Falls Buchungen vorhanden sind, gebe sie in der Konsole aus
        print("Buchungen für Fahrt ID $rideId:");
        bookings.forEach((booking) {
          print(booking);
        });
      } else {
        print("Keine Buchungen für Fahrt ID $rideId gefunden.");
      }
    } catch (e) {
      print("Fehler beim Abrufen der Buchungen: $e");
    }
  }


  Future<void> _fetchRatings() async {
    if (widget.rideDetails.isEmpty) return;

    String driverId = widget.rideDetails['driver_id'];

    try {
      final ratings = await _ratingService.getRatings(driverId);
      setState(() {
        _ratings = ratings;
        ratingValue = _calculateAverageRating(_ratings);
      });
      print("Rating: ");
      print(ratingValue);
    } catch (e) {
      print("Fehler beim Abrufen der Bewertungen: $e");
    }
  }

  double _calculateAverageRating(List<Map<String, dynamic>> ratings) {
    if (ratings.isEmpty) return 0.0; // Falls keine Bewertungen existieren

    double sum = ratings.fold(0, (prev, rating) => prev + (rating['rating'] as num));
    double average = sum / ratings.length;

    return double.parse(average.toStringAsFixed(1)); // Auf eine Nachkommastelle runden
  }

  Future<void> _fetchDriverPhoneNumber() async {
    if (widget.rideDetails.isEmpty) return;

    String driverId = widget.rideDetails['driver_id'];

    try {
      String? phone = await _userService.getPhoneNumber(driverId);
      setState(() {
        phoneNumber = phone ?? "Keine Nummer verfügbar";
      });
    } catch (e) {
      print("Fehler beim Abrufen der Telefonnummer: $e");
    }
  }
  void _callDriver() async {
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      final Uri telUri = Uri.parse("tel:$phoneNumber");

      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        print("Fehler: Konnte die Telefonnummer nicht anrufen.");
      }
    } else {
      print("Keine Telefonnummer verfügbar.");
    }
  }
  void _sendMessage() async {
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      final Uri smsUri = Uri.parse("sms:$phoneNumber");

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        print("Fehler: Konnte die SMS-App nicht öffnen.");
      }
    } else {
      print("Keine Telefonnummer verfügbar.");
    }
  }


  Future<void> _fetchUserCars() async {
    print("ride List: ");
    print(widget.rideDetails);
    if (widget.rideDetails.isEmpty) {
      return; // Keine Fahrtdetails vorhanden
    }

    // Extrahiere die driver_id aus den rideDetails
    String driverId = widget.rideDetails['driver_id'];

    try {
      final cars = await _carService.getCarsByUser(driverId); // Autos des Fahrers abrufen
      setState(() {
        _userCars = cars; // Autos im State speichern
      });
      print("cars: ");
      print(cars);
    } catch (e) {
      print("Fehler beim Abrufen der Autos: $e");
    }
  }

  void _updateMapCenter() {
    if (_startMarker != null && _destinationMarker != null) {
      double midLat = (_startMarker!.latitude + _destinationMarker!.latitude) / 2;
      double midLng = (_startMarker!.longitude + _destinationMarker!.longitude) / 2;
      setState(() {
        _mapCenter = LatLng(midLat, midLng);
      });
      _mapController.move(_mapCenter, 12); // Karte auf die Mitte zentrieren
    }
  }

  void firstMarker() async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions = await geoCoder.getAddressSuggestions(address: widget.starteingabe);
      if (suggestions.isNotEmpty) {
        LookupAddress suggestion = suggestions.first;
        setState(() {
          _startMarker = LatLng(
            double.parse(suggestion.latitude),
            double.parse(suggestion.longitude),
          );
          _startLabel = suggestion.displayName;
        });
        _updateMapCenter(); // Mitte berechnen
      }
    } catch (e) {
      print("Fehler beim Geocoding: $e");
    }
  }

  void secondMarker() async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions = await geoCoder.getAddressSuggestions(address: widget.zieleingabe);
      if (suggestions.isNotEmpty) {
        LookupAddress suggestion = suggestions.first;
        setState(() {
          _destinationMarker = LatLng(
            double.parse(suggestion.latitude),
            double.parse(suggestion.longitude),
          );
          _zielLabel = suggestion.displayName;
        });
        _updateMapCenter(); // Mitte berechnen
      }
    } catch (e) {
      print("Fehler beim Geocoding: $e");
    }
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    if (_startMarker == null || _destinationMarker == null) return;

    final String url =
        "https://router.project-osrm.org/route/v1/driving/${_startMarker!.longitude},${_startMarker!.latitude};${_destinationMarker!.longitude},${_destinationMarker!.latitude}?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    } else {
      print("Fehler beim Abrufen der Route: ${response.statusCode}");
    }
  }

  void _openGoogleMaps(String address) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?q=${Uri.encodeComponent(address)}';

    // Prüfen, ob die URL geöffnet werden kann
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl); // Öffne den Google Maps Link
    } else {
      throw 'Konnte Google Maps nicht öffnen';
    }
  }

  void _getDestAddress(String address) async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions = await geoCoder.getAddressSuggestions(address: address);
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

  void _getStartAddress(String address) async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions = await geoCoder.getAddressSuggestions(address: address);
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

  @override
  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: background_grey,
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1, // "Fahrten" Tab
          onTap: (index) {},
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Überschrift mit Mülltonnensymbol
              Padding(
                padding: EdgeInsets.all(Sizes.paddingRegular),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Du wirst abgeholt',
                      style: TextStyle(
                        fontSize: Sizes.textHeading,
                        fontWeight: FontWeight.bold,
                        color: dark_blue,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: dark_blue), // Mülltonnensymbol
                      onPressed: () {
                        // Bestätigungsdialog anzeigen
                        _confirmDeleteBooking();
                      },
                    ),
                  ],
                ),
              ),
              _buildAddressBox(),
              _buildDestinationButton(),
              SizedBox(height: Sizes.paddingSmall),
              _buildMap(context),
              SizedBox(height: Sizes.paddingSmall),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Abfahrt: ${widget.rideDetails['date']}', // Formatiere das Datum
                    style: TextStyle(
                      fontSize: Sizes.textSubText,
                      fontWeight: FontWeight.bold,
                      color: dark_blue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Sizes.paddingSmall), // Abstand zwischen dem Text und der Fahrerinfo
              _buildDriverInfo(context), // Zeige die Fahrerdaten an
              SizedBox(height: Sizes.paddingSmall), // Abstand zwischen Fahrerinfo und Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigiere zur FahrtBeendet-Seite und übergib die notwendigen Daten
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FahrtBeendet(
                            rideDetails: widget.rideDetails
                        ),
                        // TODO: Start- und Zielmarker hier übergeben, falls benötigt
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark_blue, // Hintergrundfarbe
                    foregroundColor: Colors.white, // Textfarbe
                    padding: EdgeInsets.symmetric(vertical: Sizes.paddingRegular), // Innenabstand
                    textStyle: TextStyle(
                      fontSize: Sizes.textSubText,
                      fontWeight: FontWeight.bold,
                    ),
                    minimumSize: Size(double.infinity, 50), // Volle Breite und Höhe
                  ),
                  child: Text('Fahrt abschließen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Methode zum Anzeigen des Bestätigungsdialogs
  void _confirmDeleteBooking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buchung löschen'),
          content: Text('Möchtest du diese Buchung wirklich löschen?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dialog schließen
                try {
                  await _bookingService.deleteBookingForCurrentUser(widget.rideDetails['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Buchung erfolgreich gelöscht')),
                  );
                  Navigator.pop(context); // Zurück zur vorherigen Seite navigieren
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fehler beim Löschen der Buchung: $e')),
                  );
                }
              },
              child: Text('Löschen'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddressBox() {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.paddingSmall),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomButton2(
            label: _startLabel,
            onPressed: () => _openGoogleMaps(_startLabel),
            color: button_blue,
            textColor: Colors.white,
            width: MediaQuery.of(context).size.width * 0.925,
            height: MediaQuery.of(context).size.width * 0.12,
          ),
          Positioned(left: 16, child: Icon(Icons.location_on, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDestinationButton() {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.paddingSmall),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomButton2(
            label: _zielLabel,
            onPressed: () => _openGoogleMaps(_zielLabel),
            color: dark_blue,
            textColor: Colors.white,
            width: MediaQuery.of(context).size.width * 0.925,
            height: MediaQuery.of(context).size.width * 0.12,
          ),
          Positioned(left: 16, child: Icon(Icons.flag, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.paddingSmall),
      child: Container(
        width: Sizes.ContentWidth,
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(center: _mapCenter, zoom: 12),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  PolylineLayer(
                    polylines: [
                      if (_routePoints.isNotEmpty)
                        Polyline(
                          points: _routePoints,
                          strokeWidth: 4.0,
                          color: Colors.black,
                        ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      if (_startMarker != null)
                        Marker(
                          point: _startMarker!,
                          builder: (ctx) => Icon(
                            Icons.circle,
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                      if (_destinationMarker != null)
                        Marker(
                          point: _destinationMarker!,
                          builder: (ctx) => Icon(
                            Icons.flag,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    _openGoogleMapsWithRoute(_startLabel, _zielLabel);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.map,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openGoogleMapsWithRoute(String startAddress, String destinationAddress) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${Uri.encodeComponent(startAddress)}&destination=${Uri.encodeComponent(destinationAddress)}';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Konnte Google Maps nicht öffnen';
    }
  }

  Widget _buildDriverInfo(BuildContext context) {
    if (_userCars.isEmpty) {
      return Center(child: Text("Keine Autos gefunden"));
    }

    // Nehme das erste Auto aus der Liste (kann angepasst werden)
    Map<String, dynamic> car = _userCars[0];
    print(car);
    Map<String, dynamic> ride = widget.rideDetails;
    String driverName = ride['driver']?['first_name'] ?? 'Unbekannter Fahrer';
    double rating = ratingValue; // Beispiel-Bewertung (kann aus rideDetails geholt werden, falls vorhanden)
    String carModel = '${car['car_name'] ?? 'Unbekanntes Modell'} (${car['colour'] ?? 'Unbekannte Farbe'})';
    String licensePlate = car['license_plate'] ?? 'Unbekanntes Kennzeichen';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
      padding: EdgeInsets.all(Sizes.paddingRegular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    radius: Sizes.textSubText * 1.5,
                  ),
                  SizedBox(width: Sizes.paddingSmall),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName, // Zeige den Namen des Fahrers an
                        style: TextStyle(
                          fontSize: Sizes.textSubText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.black38, size: Sizes.textSubText),
                          Text(
                            rating.toStringAsFixed(1), // Zeige die Bewertung an
                            style: TextStyle(fontSize: Sizes.textSubText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.message, color: Colors.black, size: Sizes.textSubText * 1.5),
                    onPressed: _sendMessage, // Ruft die Nummer an
                  ),
                  SizedBox(width: Sizes.paddingSmall),
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.black, size: Sizes.textSubText * 1.5),
                    onPressed: _callDriver, // Ruft die Nummer an
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Sizes.paddingSmall),
          Divider(color: Colors.grey),
          SizedBox(height: Sizes.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_car, color: Colors.black54),
                  SizedBox(width: Sizes.paddingSmall),
                  Text(
                    carModel, // Zeige das Automodell an
                    style: TextStyle(
                      fontSize: Sizes.textSubText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                licensePlate, // Zeige das Kennzeichen an
                style: TextStyle(
                  fontSize: Sizes.textSubText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}