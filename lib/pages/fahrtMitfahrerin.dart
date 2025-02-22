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


class RidePickupPage extends StatefulWidget {
  final String starteingabe;
  final String zieleingabe;
  RidePickupPage({super.key, required this.starteingabe, required this.zieleingabe});

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
      List<LookupAddress> suggestions =
      await geoCoder.getAddressSuggestions(address: widget.starteingabe);
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
      await geoCoder.getAddressSuggestions(address: widget.zieleingabe);
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
  void _getStartAddress(String address) async {
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
  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      backgroundColor: background_grey,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // "Fahrten" Tab
        onTap: (index) {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Sizes.paddingRegular),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Du wirst abgeholt',
                  style: TextStyle(
                    fontSize: Sizes.textHeading,
                    fontWeight: FontWeight.bold,
                    color: dark_blue,
                  ),
                ),
              ),
            ),
            _buildAddressBox(),
            _buildDestinationButton(),
            SizedBox(height: Sizes.paddingSmall),
            _buildMap(context),
            SizedBox(height: Sizes.paddingSmall),
            _buildDriverInfo(context),
            SizedBox(height: Sizes.paddingSmall),
          ],
        ),
      ),
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
                    radius: Sizes.textSubtitle * 1.5,
                  ),
                  SizedBox(width: Sizes.paddingSmall),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sascha',
                        style: TextStyle(
                          fontSize: Sizes.textSubtitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.black38, size: Sizes.textSubtitle),
                          Text('4,0', style: TextStyle(fontSize: Sizes.textSubtitle)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.message, color: Colors.black, size: Sizes.textSubtitle * 1.5),
                  SizedBox(width: Sizes.paddingSmall),
                  Icon(Icons.phone, color: Colors.black, size: Sizes.textSubtitle * 1.5),
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
                    'Opel Corsa',
                    style: TextStyle(
                      fontSize: Sizes.textSubtitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'B-BB 1312',
                style: TextStyle(
                  fontSize: Sizes.textSubtitle,
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
