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

class FindRide extends StatefulWidget {
  final String Starteingabe;
  final String Zieleingabe;
  FindRide({super.key, required this.Starteingabe, required this.Zieleingabe});
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
    //_startLabel = widget.Starteingabe;
    //_zielLabel = widget.Zieleingabe;
    firstMarker();
    secondMarker();
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
      List<LookupAddress> suggestions =
      await geoCoder.getAddressSuggestions(address: widget.Starteingabe);
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
      List<LookupAddress> suggestions =
      await geoCoder.getAddressSuggestions(address: widget.Zieleingabe);
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
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
        "https://router.project-osrm.org/route/v1/driving/${_startMarker!.longitude},${_startMarker!.latitude};${_destinationMarker!.longitude},${_destinationMarker!.latitude}?overview=full&geometries=geojson";

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

  void _showLocationInputDialog(String type) async{
    final TextEditingController _controller = TextEditingController();
    String label = await showDialog(
      context: context,
      builder: (context) {
      String response = "";
        return AlertDialog(
          title: Text("Gib die $type-Adresse ein"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "z.B. Alexanderplatz, Berlin"),
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if(type == "Start"){
                  Navigator.of(context).pop(_startLabel);
                }else{
                  Navigator.of(context).pop(_zielLabel);
                }
              },
              child: Text("Abbrechen"),
            ),
            TextButton(

              onPressed: () async {
                final input = _controller.text;
                if (input.isEmpty) {
                  if(type == "Start"){
                    Navigator.of(context).pop(_startLabel);
                    return;
                  }else{
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
      if(type == "Start"){
        _startLabel = label;
      }else{
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
            width: MediaQuery.of(context).size.width * 0.925,
            height: MediaQuery.of(context).size.width * 0.12,
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
        ),
      ),
    );
  }

  Widget _buildDriverList(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildDriverCard(context, "Sascha", 4.0, "15:30", "2 freie Plätze"),
          _buildDriverCard(context, "Jonas", 4.5, "16:00", "3 freie Plätze"),
        ],
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, String name, double rating, String time, String seats) {
    DateTime now = DateTime.now();
    DateTime startTime = DateFormat("HH:mm").parse(time);
    startTime = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    int minutesDiff = startTime.difference(now).inMinutes;
    String timeText = minutesDiff == 0 ? "jetzt" : (minutesDiff < 0 ? "vor ${minutesDiff.abs()} min." : "in $minutesDiff min.");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall * 1.4, vertical: Sizes.paddingSmall),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.borderRadius)),
        child: Padding(
          padding: EdgeInsets.all(Sizes.paddingRegular),
          child: Column(
            children: [
              // Oberer Bereich mit Fahrer-Infos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: Colors.grey[300], child: Icon(Icons.person, color: Colors.black)),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.black, size: 16),
                              SizedBox(width: 4),
                              Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: 14)),
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
                        MaterialPageRoute(builder: (context) => RidePickupPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(Icons.directions_car, size: 24, color: Colors.black),
                        Text("Buchen", style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.black, thickness: 1),

              // Startzeit und freie Plätze
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Start", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Text(timeText, style: TextStyle(fontSize: 14, color: Colors.orange)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.hourglass_empty, size: 18, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(seats, style: TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}