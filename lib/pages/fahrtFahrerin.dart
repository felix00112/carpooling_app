import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';
import 'package:carpooling_app/constants/button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Zum Öffnen der URL
import 'package:geocoding_resolver/geocoding_resolver.dart';
import 'package:latlong2/latlong.dart';
import '../services/booking_service.dart';
import '../services/user_service.dart';
import '../services/ride_service.dart'; // Stelle sicher, dass du einen RideService hast

class RideDetailsPage extends StatefulWidget {
  final String Starteingabe;
  final String Zieleingabe;
  final int rideId;
  const RideDetailsPage({super.key, required this.Starteingabe, required this.Zieleingabe, required this.rideId});

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  String _startLabel = "Start";
  String _zielLabel = "Ziel";
  LatLng? _startMarker;
  LatLng? _destinationMarker;
  final BookingService _bookingService = BookingService();
  final UserService _userService = UserService();
  final RideService _rideService = RideService(); // RideService hinzufügen
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  int _currentIndex = 1;

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
    _getDestAddress(widget.Starteingabe);
    _getStartAddress(widget.Zieleingabe);
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final bookings = await _bookingService.getBookingsForRide(widget.rideId);
      List<Map<String, dynamic>> bookingDetails = [];
      for (var booking in bookings) {
        final userResponse = await _userService.getUserById(booking['passenger_id']);
        if (userResponse.isNotEmpty) {
          final user = userResponse[0];
          bookingDetails.add({
            ...booking,
            'user_name': user['first_name'] ?? 'Unbekannt',
            'phone_number': user['phone_number'] ?? 'Keine Nummer verfügbar'
          });
        } else {
          bookingDetails.add({
            ...booking,
            'user_name': 'Unbekannt',
            'phone_number': 'Keine Nummer verfügbar',
          });
        }
      }
      setState(() {
        this.bookings = bookingDetails;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Buchungen: $e')),
      );
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

  Future<void> _deleteRide() async {
    try {
      await _rideService.deleteRide(widget.rideId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fahrt erfolgreich gelöscht')),
      );
      Navigator.pop(context); // Zurück zur vorherigen Seite navigieren
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen der Fahrt: $e')),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fahrt löschen'),
          content: Text('Möchtest du diese Fahrt wirklich löschen?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
                _deleteRide(); // Fahrt löschen
              },
              child: Text('Löschen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: background_grey,
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {},
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Zeile mit "Deine Fahrt" und dem Mülltonnen-Button
              SizedBox(height: Sizes.paddingXL),
              Padding(
                padding: EdgeInsets.all(Sizes.paddingRegular),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deine Fahrt',
                      style: TextStyle(
                        fontSize: Sizes.textHeading,
                        fontWeight: FontWeight.bold,
                        color: dark_blue,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: dark_blue), // Mülltonnen-Symbol
                      onPressed: _confirmDelete, // Bestätigungsdialog anzeigen
                    ),
                  ],
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
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildBookingList(context),
              SizedBox(height: Sizes.paddingSmall),
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
            ],
          ),
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

  Widget _buildBookingList(BuildContext context) {
    return Column(
      children: bookings.asMap().entries.map((entry) {
        final index = entry.key;
        final booking = entry.value;
        return _buildBookingCard(
          context,
          booking['user_name'],
          booking['phone_number'],
          index,
        );
      }).toList(),
    );
  }

  Widget _buildBookingCard(BuildContext context, String userName, String phoneNumber, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
          child: Text(
            "Mitfahrer ${index + 1}",
            style: TextStyle(
              fontSize: Sizes.textSubText * 0.9,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: Sizes.paddingSmall),
        Container(
          width: MediaQuery.of(context).size.width * 0.925,
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
                            userName,
                            style: TextStyle(
                              fontSize: Sizes.textSubText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.solidStar, color: Colors.black38, size: Sizes.textSubText),
                              SizedBox(height: Sizes.paddingSmall,),
                              Text(
                                "4.5",
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
                        icon: Icon(FontAwesomeIcons.solidMessage, color: Colors.black, size: Sizes.textSubText * 1.5),
                        onPressed: () {
                          print('Nachricht an $userName');
                        },
                      ),
                      SizedBox(width: Sizes.paddingSmall),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.phone, color: Colors.black, size: Sizes.textSubText * 1.5),
                        onPressed: () {
                          print('Anruf an $userName');
                        },
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
                      Icon(FontAwesomeIcons.phone, color: Colors.black54),
                      SizedBox(width: Sizes.paddingSmall),
                      Text(
                        phoneNumber,
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
            width: MediaQuery.of(context).size.width * 0.925,
            height: MediaQuery.of(context).size.width * 0.12,
          ),
          Positioned(left: 16, child: Icon(Icons.flag, color: Colors.white)),
        ],
      ),
    );
  }

  void _openGoogleMaps(String address) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?q=${Uri.encodeComponent(address)}';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Konnte Google Maps nicht öffnen';
    }
  }
}