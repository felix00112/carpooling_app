import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';
import 'package:carpooling_app/constants/button2.dart';
import 'package:url_launcher/url_launcher.dart'; // Zum Öffnen der URL
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:latlong2/latlong.dart';



class RideDetailsPage extends StatefulWidget {
  final String Starteingabe;
  final String Zieleingabe;
  const RideDetailsPage({super.key, required this.Starteingabe, required this.Zieleingabe});

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState();
}
class _RideDetailsPageState extends State<RideDetailsPage> {
  String _startLabel = "Start";
  String _zielLabel = "Ziel";
  LatLng? _startMarker;
  LatLng? _destinationMarker;

  int _currentIndex = 1;
  int passengerIndex = 1;


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
    _getDestAddress(widget.Starteingabe);
    _getStartAddress(widget.Zieleingabe);
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
        currentIndex: 1,
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
                  'Deine Fahrt',
                  style: TextStyle(
                    fontSize: Sizes.textHeading,
                    fontWeight: FontWeight.bold,
                    color: dark_blue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Sizes.paddingRegular, top: Sizes.paddingSmall),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: Sizes.textSubText,
                    fontWeight: FontWeight.bold,
                    color: dark_blue,
                  ),
                ),
              ),
            ),
            _buildAddressBox(),
            SizedBox(height: Sizes.paddingSmall),
            _buildDriverList(context),
            Padding(
              padding: EdgeInsets.only(left: Sizes.paddingRegular),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ziel',
                  style: TextStyle(
                    fontSize: Sizes.textSubText,
                    fontWeight: FontWeight.bold,
                    color: dark_blue,
                  ),
                ),
              ),
            ),
            _buildDestinationButton(),
            SizedBox(height: Sizes.paddingSmall),
          ]
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.925,
            height: MediaQuery
                .of(context)
                .size
                .width * 0.12,
          ),
          Positioned(
              left: 16, child: Icon(Icons.location_on, color: Colors.white)),
        ],
      ),
    );
  }
  void _incrementCounter() {
    setState(() {
      passengerIndex++; // Erhöht den Zähler um 1
    });
  }

  Widget _buildDriverList(BuildContext context) {
    List<Map<String, dynamic>> passengers = [
      {"name": "Sascha", "rating": 4.0, "time": "15:30", "address": "Musterstraße 1"},
      {"name": "Jonas", "rating": 4.5, "time": "16:00", "address": "Musterstraße 2"},
    ];

    return Column(
      children: List.generate(passengers.length, (index) {
        return Column(
          children: [
            _buildPassengerInfo(
              context,
              passengers[index]["name"],
              passengers[index]["rating"],
              passengers[index]["time"],
              passengers[index]["address"],
              index + 1, // Passenger Nummerierung
            ),
            SizedBox(height: Sizes.paddingRegular), // Abstand zwischen den Cards
          ],
        );
      }),
    );
  }



  Widget _buildPassengerInfo(BuildContext context, String name, double rating, String time, String address, int passengerIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Überschrift linksbündig
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
          child: Text(
            "Zustieg $passengerIndex",
            style: TextStyle(
              fontSize: Sizes.textSubText * 0.9,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: Sizes.paddingSmall), // Abstand zwischen Titel und Card
        Container(
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
                            name,
                            style: TextStyle(
                              fontSize: Sizes.textSubText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.black38,
                                  size: Sizes.textSubText),
                              Text(rating.toStringAsFixed(1),
                                  style: TextStyle(fontSize: Sizes.textSubText)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.message, color: Colors.black,
                          size: Sizes.textSubText * 1.5),
                      SizedBox(width: Sizes.paddingSmall),
                      Icon(Icons.phone, color: Colors.black,
                          size: Sizes.textSubText * 1.5),
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
                      Text(time),
                      SizedBox(width: Sizes.paddingSmall),
                      Text(
                        address,
                        style: TextStyle(
                          fontSize: Sizes.textSubText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.925,
            height: MediaQuery
                .of(context)
                .size
                .width * 0.12,
          ),
          Positioned(left: 16, child: Icon(Icons.flag, color: Colors.white)),
        ],
      ),
    );
  }

  void _openGoogleMaps(String address) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?q=${Uri
        .encodeComponent(address)}';

    // Prüfen, ob die URL geöffnet werden kann
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl); // Öffne den Google Maps Link
    } else {
      throw 'Konnte Google Maps nicht öffnen';
    }
  }
}