import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:convert';
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:http/http.dart' as http;


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
  final LatLng _initialCenter = LatLng(52.5200, 13.4050);
  List<LatLng> _routePoints = [];

  String _startLabel = "Start";
  String _zielLabel = "Ziel";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_startLabel = widget.Starteingabe;
    //_zielLabel = widget.Zieleingabe;
    firstMarker();
    secondMarker();
  }

  void firstMarker() async{
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions =
      await geoCoder.getAddressSuggestions(address: widget.Starteingabe);
      if (suggestions.isNotEmpty) {
        print("hello");
        LookupAddress suggestion = suggestions.first;
        print(suggestion.displayName);
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

  void secondMarker() async{
    try {
      GeoCoder geoCoder = GeoCoder();
      List<LookupAddress> suggestions =
      await geoCoder.getAddressSuggestions(address: widget.Zieleingabe);
      if (suggestions.isNotEmpty) {
        print("hello");
        LookupAddress suggestion = suggestions.first;
        print(suggestion.displayName);
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
    _fetchRoute();
  }
  @override
  Widget build(BuildContext context) {
    final LatLng center = _startMarker ?? _destinationMarker ?? _initialCenter;

    return SafeArea(
      child: Scaffold(
        backgroundColor: background_grey,
        appBar: AppBar(
          backgroundColor: background_grey,
          title: Text("Fahrt suchen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        ),
        body: Column(
          children: [
            _buildStartButton(context),
            _buildZielButton(context),
            _buildMap(context, center),
            _buildDriverList(context),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
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
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomButton(
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

  Widget _buildMap(BuildContext context, LatLng center) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.925,
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FlutterMap(
            options: MapOptions(center: center, zoom: 12),
            children: [
              // Karten-Hintergrund
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),

              // Route (hinter den Markern)
              PolylineLayer(
                polylines: [
                  if (_routePoints.isNotEmpty)
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: Colors.black, // Farbe der Route
                    ),
                ],
              ),

              // Marker (im Vordergrund)
              MarkerLayer(
                markers: [
                  if (_startMarker != null)
                    Marker(
                      point: _startMarker!,
                      builder: (ctx) => Icon(
                        Icons.circle,
                        color: Colors.black, // Farbe des Startmarkers
                        size: 15,
                      ),
                    ),
                  if (_destinationMarker != null)
                    Marker(
                      point: _destinationMarker!,
                      builder: (ctx) => Icon(
                        Icons.flag,
                        color: Colors.red, // Farbe des Zielmarkers
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
          _buildDriverCard("Sascha", 4.0, "15:30", "2 freie Plätze"),
          _buildDriverCard("Jonas", 4.5, "16:00", "3 freie Plätze"),
        ],
      ),
    );
  }

  Widget _buildDriverCard(String name, double rating, String time, String seats) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: Text("$time Uhr - $seats"),
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