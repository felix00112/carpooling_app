import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:convert';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:http/http.dart' as http;
import 'package:carpooling_app/constants/button2.dart';
import 'package:carpooling_app/constants/sizes.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:intl/intl.dart'; // Für Zeitformatierung
import 'package:carpooling_app/pages/fahrtMitfahrerin.dart';

import '../services/ride_service.dart';

class FindRide extends StatefulWidget {
  final String Starteingabe;
  final String Zieleingabe;
  final String Zeitpunkt;
  FindRide({super.key, required this.Starteingabe, required this.Zieleingabe, required this.Zeitpunkt});
  @override
  _FindRideState createState() => _FindRideState();

}

class _FindRideState extends State<FindRide> {
  LatLng? _startMarker;
  LatLng? _destinationMarker;
  String? _startAddress;
  String? _destinationAddress;
  LatLng _mapCenter = LatLng(52.5200, 13.4050);
  List<LatLng> _routePoints = [];

  List<Map<String, dynamic>> _rides = []; // list for real data
  final RideService _rideService = RideService(); // ride service instance

  String _startLabel = "Start";
  String _zielLabel = "Ziel";
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
    firstMarker();
    secondMarker();
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


  Future<void> _fetchRides(String startAddress, String endAddress) async {
    String date = convertToSupabaseFormat(widget.Zeitpunkt);
    print("Date:$date");
    print("Start:$startAddress");
    print("End:$endAddress");
    try {
      final List<Map<String, dynamic>> rides = await _rideService.getRides(date,startAddress, endAddress);

      print('Geladene Fahrten: $rides');

      setState(() {
        _rides = rides.map((ride) {
          return {
            "id": ride["id"],
            "driver_id": ride["driver_id"],
            "start_location": ride["start_location"],
            "end_location": ride["end_location"],
            "date": ride["date"],
            "driver": ride["driver"] ?? {"first_name": "Unbekannter Fahrer"} // If `driver` is null
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching rides: $e");
    }
  }



  void _updateMapCenter() {
    if (_startMarker != null && _destinationMarker != null) {
      double midLat = (_startMarker!.latitude + _destinationMarker!.latitude) /
          2;
      double midLng = (_startMarker!.longitude +
          _destinationMarker!.longitude) / 2;
      setState(() {
        _mapCenter = LatLng(midLat, midLng);
      });
      _mapController.move(_mapCenter, 12); // Karte auf die Mitte zentrieren
    }
  }

  void firstMarker() async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions = await geoCoder.getAddressSuggestions(address: widget.Starteingabe);

      if (suggestions.isNotEmpty) {
        LookupAddress suggestion = suggestions.first;
        setState(() {
          _startMarker = LatLng(
            double.parse(suggestion.latitude),
            double.parse(suggestion.longitude),
          );
          _startLabel = suggestion.displayName; // Setze die Adresse für DB-Suche
        });

        print("Start: $_startLabel");
        _updateMapCenter();
        checkAndFetchRides(); // Prüfe, ob beide Marker gesetzt sind
      }
    } catch (e) {
      print("Fehler beim Geocoding: $e");
    }
  }

  void secondMarker() async {
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions = await geoCoder.getAddressSuggestions(address: widget.Zieleingabe);

      if (suggestions.isNotEmpty) {
        LookupAddress suggestion = suggestions.first;
        print("Suggestion: $suggestion");
        setState(() {
          _destinationMarker = LatLng(
            double.parse(suggestion.latitude),
            double.parse(suggestion.longitude),
          );

          _zielLabel = suggestion.displayName; // Setze die Adresse für DB-Suche
        });


        print("Ziel: $_zielLabel");
        _updateMapCenter();
        checkAndFetchRides(); // Prüfe, ob beide Marker gesetzt sind
      }
    } catch (e) {
      print("Fehler beim Geocoding: $e");
    }
    _fetchRoute();
  }

  void checkAndFetchRides() {
    if (_startMarker != null && _destinationMarker != null) {
      print("Fetching rides with addresses:$_startLabel;$_zielLabel");
      _fetchRides(_startLabel.toString(), _zielLabel.toString()); // Use converted addresses
    }
  }



  @override
  Widget build(BuildContext context) {
    //final LatLng center = _startMarker ?? _destinationMarker ?? _initialCenter;
    Sizes.initialize(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: background_grey,
        appBar: AppBar(
          backgroundColor: background_grey,
          title: Text(
            "Fahrt suchen",
            style: TextStyle(
                fontSize: Sizes.textHeading,
                fontWeight: FontWeight.bold,
                color: dark_blue,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildStartButton(context),
            _buildZielButton(context),
            _buildMap(context),
            _buildDriverList(context),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }

  Future<void> _fetchRoute() async {
    if (_startMarker == null || _destinationMarker == null) return;

    final String url =
        "https://router.project-osrm.org/route/v1/driving/${_startMarker!
        .longitude},${_startMarker!.latitude};${_destinationMarker!
        .longitude},${_destinationMarker!
        .latitude}?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> coordinates =
      data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      print("Fehler beim Abrufen der Route: ${response.statusCode}");
    }
  }

  void _showLocationInputDialog(String type) async {
    final TextEditingController _controller = TextEditingController();
    String label = await showDialog(
      context: context,
      builder: (context) {
        String response = "";
        return AlertDialog(
          title: Text("Gib die $type-Adresse ein"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: "z.B. Alexanderplatz, Berlin"),
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (type == "Start") {
                  Navigator.of(context).pop(_startLabel);
                } else {
                  Navigator.of(context).pop(_zielLabel);
                }
              },
              child: Text("Abbrechen"),
            ),
            TextButton(

              onPressed: () async {
                final input = _controller.text;
                if (input.isEmpty) {
                  if (type == "Start") {
                    Navigator.of(context).pop(_startLabel);
                    return;
                  } else {
                    Navigator.of(context).pop(_zielLabel);
                    return;
                  }
                }
                try {
                  GeoCoder geoCoder = GeoCoder();
                  List<LookupAddress> suggestions =
                  await geoCoder.getAddressSuggestions(address: input);
                  if (suggestions.isNotEmpty) {
                    print("hello");
                    LookupAddress suggestion = suggestions.first;
                    setState(() {
                      if (type == "Start") {
                        _startMarker = LatLng(
                          double.parse(suggestion.latitude),
                          double.parse(suggestion.longitude),
                        );
                        _startAddress = suggestion.displayName;
                        _startLabel = suggestion.displayName;
                        response = suggestion.displayName;
                      } else {
                        _destinationMarker = LatLng(
                          double.parse(suggestion.latitude),
                          double.parse(suggestion.longitude),
                        );
                        _destinationAddress = suggestion.displayName;
                        _zielLabel = suggestion.displayName;
                        response = suggestion.displayName;
                      }
                      _fetchRoute(); // Route berechnen
                    });
                  }
                } catch (e) {
                  print("Fehler beim Geocoding: $e");
                }
                Navigator.of(context).pop(response);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    setState(() {
      if (type == "Start") {
        _startLabel = label;
      } else {
        _zielLabel = label;
      }
    });
  }


  Widget _buildStartButton(BuildContext context) {
    return _buildButton(_startLabel, "Start", Icons.my_location, button_blue);
  }

  Widget _buildZielButton(BuildContext context) {
    return _buildButton(_zielLabel, "Ziel", Icons.location_on, dark_blue);
  }

  Widget _buildButton(String label, String type, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.paddingSmall),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomButton2(
            label: label,
            onPressed: () => _showLocationInputDialog(type),
            color: color,
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
          Positioned(left: 16, child: Icon(icon, color: Colors.white)),
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
          child: FlutterMap(
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
                      builder: (ctx) =>
                          Icon(
                            Icons.circle,
                            color: Colors.black,
                            size: 15,
                          ),
                    ),
                  if (_destinationMarker != null)
                    Marker(
                      point: _destinationMarker!,
                      builder: (ctx) =>
                          Icon(
                            Icons.flag,
                            color: Colors.red,
                            size: 40,
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverList(BuildContext context) {

    return Expanded(
      child: _rides.isEmpty
          ? Center(child: Text("Keine Fahrten gefunden", style: TextStyle(fontSize: Sizes.textSubText, color: Colors.grey)))
          : ListView.builder(
        itemCount: _rides.length,
        itemBuilder: (context, index) {
          var ride = _rides[index];
          // Make sure that `driver` is not null before accessing its properties
          String driverName = (ride['driver'] != null && ride['driver']['first_name'] != null)
              ? ride['driver']['first_name']
              : "Unbekannter Fahrer";


          return _buildDriverCard(
            context,
            driverName,
            4.5, // Example Mock Rating
            // Todo: right time format. should be dd.MM.yyyy. HH:mm
            DateFormat("HH:mm").format(DateTime.parse(ride['date'])),
            // Todo: fix seats available
            // ride['seats_available'],
            "2", // Falls du Platzanzahl hast, ersetzen
          );
        },
      ),
    );
  }


  Widget _buildDriverCard(BuildContext context, String name, double rating,
      String time, String seats) {
    DateTime now = DateTime.now();
    DateTime startTime = DateFormat("HH:mm").parse(time);
    startTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    int minutesDiff = startTime.difference(now).inMinutes;

    String timeText;
    Color timeColor;

    if (minutesDiff <= 10) {
      timeText = "jetzt";
      timeColor = Colors.red;
    } else if (minutesDiff < 60) {
      timeText = "in $minutesDiff min.";
      timeColor = Colors.orange;
    } else if (minutesDiff < 1440) {
      int hours = minutesDiff ~/ 60;
      int minutes = minutesDiff % 60;
      timeText = minutes > 0 ? "in ${hours}h ${minutes}min." : "in ${hours}h";
      timeColor = Colors.green;
    } else {
      int days = minutesDiff ~/ 1440;
      int remainingMinutes = minutesDiff % 1440;
      int hours = remainingMinutes ~/ 60;
      timeText = hours > 0 ? "in ${days} Tagen ${hours}h" : "in ${days} Tagen";
      timeColor = Colors.green;
    }

    // Farbe für die Anzahl der freien Plätze
    Color seatsColor;
    String pluralOrSingular;
    int seatsInt = int.tryParse(seats) ?? 0;

    if (seatsInt == 1) {
      seatsColor = Colors.red;
      pluralOrSingular = ' freier Platz';
    } else if (seatsInt == 2) {
      seatsColor = Colors.orange;
      pluralOrSingular = ' freie Plätze';
    } else {
      seatsColor = Colors.green;
      pluralOrSingular = ' freie Plätze';
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.paddingSmall),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
        padding: EdgeInsets.all(Sizes.paddingRegular),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Sizes.borderRadius),
        ),
        child: Column(
          children: [
            // Oberer Bereich mit Fahrer-Infos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        radius: Sizes.textSubText * 1.5,
                        backgroundColor: Colors.grey[400],
                        child: Icon(Icons.person, color: Colors.black)),
                    SizedBox(width: Sizes.paddingSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: Sizes.textSubText,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.black, size: Sizes.textSubText),
                            SizedBox(width: 4),
                            Text(rating.toStringAsFixed(1),
                                style:
                                TextStyle(fontSize: Sizes.textSubText)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RidePickupPage(
                              starteingabe: widget.Starteingabe,
                              zieleingabe: widget.Zieleingabe)),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.directions_car,
                          size: Sizes.textSubText * 1.5, color: Colors.black),
                      Text(
                        "Buchen",
                        style: TextStyle(
                            fontSize: Sizes.textSubText, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.paddingSmall),
            Divider(color: Colors.grey),
            SizedBox(height: Sizes.paddingSmall),
            // Startzeit und freie Plätze
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Start",
                        style: TextStyle(
                            fontSize: Sizes.textSubText * 1.2,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text(time,
                            style: TextStyle(
                                fontSize: Sizes.textSubText,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.hourglass_empty,
                            size: Sizes.textSubText, color: timeColor),
                        SizedBox(width: 4),
                        Text(timeText,
                            style: TextStyle(
                                fontSize: Sizes.textSubText * 0.9,
                                color: timeColor)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(seats+pluralOrSingular,
                        style: TextStyle(
                            fontSize: Sizes.textSubText,
                            color: seatsColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

