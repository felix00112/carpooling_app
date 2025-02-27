import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import 'package:carpooling_app/constants/sizes.dart';
import '../constants/navigationBar.dart'; // Import der NavigationBar
import 'package:intl/intl.dart';
import '../services/ride_service.dart';
import 'fahrtFahrerin.dart';
import 'fahrtMitfahrerin.dart';

class GebuchteFahrtenListe extends StatefulWidget {
  const GebuchteFahrtenListe({super.key});

  @override
  _GebuchteFahrtenListeState createState() => _GebuchteFahrtenListeState();
}

class _GebuchteFahrtenListeState extends State<GebuchteFahrtenListe> with SingleTickerProviderStateMixin {
  ////////////////////Navigation bar/////////////////////
  int _currentIndex = 1; // Index für die aktuell ausgewählte Seite
  List<Map<String, dynamic>> bookedRides = [];
  List<Map<String, dynamic>> offeredRides = [];
  final RideService _rideService = RideService();

  bool isLoading = true;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigation zu den entsprechenden Seiten basierend auf dem Index ist nicht mehr notwendig
  }

  /////////////////////////////////////////////////////////

  late TabController _tabController;

  String _formatDate(String dateString) {
    try {
      // Hier das Datum parsen und in das gewünschte Format bringen
      DateTime date = DateTime.parse(dateString);
      return '${DateFormat('dd.MM.yyyy HH:mm').format(date)} Uhr'; // "Uhr" hinzufügen
    } catch (e) {
      return 'Unbekanntes Datum';
    }
  }

  String _getRideGroup(DateTime rideDate) {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(Duration(days: 1));
    DateTime dayAfterTomorrow = now.add(Duration(days: 2));
    DateTime endOfWeek = now.add(Duration(days: 7));
    DateTime nextWeekStart = now.add(Duration(days: 8));

    if (_isSameDay(rideDate, now)) {
      return 'Heute';
    } else if (_isSameDay(rideDate, tomorrow)) {
      return 'Übermorgen';
    } else if (_isThisWeek(rideDate, now)) {
      return 'Diese Woche';
    } else if (_isNextWeek(rideDate, now)) {
      return 'Nächste Woche';
    } else {
      return 'Später';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  bool _isThisWeek(DateTime date, DateTime now) {
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Start der Woche
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6)); // Ende der Woche
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek.add(Duration(days: 1)));
  }

  bool _isNextWeek(DateTime date, DateTime now) {
    DateTime startOfNextWeek = now.add(Duration(days: 7 - now.weekday)); // Start der nächsten Woche
    DateTime endOfNextWeek = startOfNextWeek.add(Duration(days: 6)); // Ende der nächsten Woche
    return date.isAfter(startOfNextWeek) && date.isBefore(endOfNextWeek.add(Duration(days: 1)));
  }

  void _onRideClicked(Map<String, dynamic> rideDetails) async {
    print("onrideclicked ");
    print(rideDetails['id']);

    // Überprüfen, ob es sich um eine angebotene Fahrt handelt
    bool isOfferedRide = offeredRides.contains(rideDetails);

    if (isOfferedRide) {
      // Navigiere zur RideDetailsPage für angebotene Fahrten
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideDetailsPage(
            Starteingabe: rideDetails['start_location'] ?? 'Unbekannter Startort',
            Zieleingabe: rideDetails['end_location'] ?? 'Unbekanntes Ziel',
            rideId: rideDetails['id'],
          ),
        ),
      );
    } else {
      // Rufe die Methode auf, um die vollständigen Fahrtdetails basierend auf der rideId zu erhalten
      try {
        List<Map<String, dynamic>> rideData = await _rideService.getRideById(rideDetails['ride_id'].toString());

        if (rideData.isNotEmpty) {
          // Füge die rideId in rideDetails ein, falls noch nicht vorhanden
          rideDetails['id'] = rideDetails['ride_id'];
          print("rideDetails['id'] = ");
          print(rideDetails);

          // Kombiniere die erhaltenen Daten mit den vorhandenen rideDetails
          Map<String, dynamic> fullRideDetails = {...rideDetails, ...rideData.first};

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RidePickupPage(
                starteingabe: fullRideDetails['start_location'] ?? 'Unbekannter Startort',  // Fallback-Wert hinzugefügt
                zieleingabe: fullRideDetails['end_location'] ?? 'Unbekanntes Ziel', // Fallback-Wert hinzugefügt
                rideDetails: fullRideDetails, // Ganze rideDetails inklusive rideId und zusätzlicher Daten
              ),
            ),
          );
        } else {
          print("Keine Daten für die angegebene rideId gefunden.");
        }
      } catch (e) {
        print("Fehler beim Abrufen der Fahrtdetails: $e");
      }
    }
  }


  Map<String, List<Map<String, dynamic>>> _groupRidesByDate(List<Map<String, dynamic>> rides) {
    Map<String, List<Map<String, dynamic>>> groupedRides = {
      'Heute': [],
      'Übermorgen': [],
      'Diese Woche': [],
      'Nächste Woche': [],
      'Später': [],
      'Vergangene Fahrten': [], // Neue Gruppe für vergangene Fahrten
    };

    for (var ride in rides) {
      var rideData = ride['ride'] ?? ride; // Verwende ride['ride'], falls vorhanden, sonst ride direkt
      if (rideData['date'] == null) {
        print("Fehler: Datum fehlt in der Fahrt: $rideData");
        continue; // Überspringe diese Fahrt, da das Datum fehlt
      }

      DateTime rideDate = DateTime.parse(rideData['date']);
      String groupKey = _getRideGroup(rideDate);

      if (_isPast(rideDate)) {
        groupedRides['Vergangene Fahrten']?.add(ride); // Vergangene Fahrten in separate Gruppe
      } else {
        groupedRides[groupKey]?.add(ride);
      }
    }

    return groupedRides;
  }

  bool _isPast(DateTime date) {
    DateTime now = DateTime.now();
    return date.isBefore(now); // Überprüft, ob das Datum in der Vergangenheit liegt
  }

  List<Map<String, dynamic>> _sortRidesByDate(List<Map<String, dynamic>> rides) {
    rides.sort((a, b) {
      DateTime dateA = DateTime.parse(a['ride']['date']);
      DateTime dateB = DateTime.parse(b['ride']['date']);
      return dateA.compareTo(dateB); // Aufsteigende Sortierung
    });
    return rides;
  }

  Future<void> _loadRides() async {
    try {
      List<Map<String, dynamic>> booked = await RideService().getUserBookedRides();

      List<Map<String, dynamic>> offered = await RideService().getUserOfferedRides();
      print("offered date: ");
      print(offered);
      setState(() {
        bookedRides = booked;
        offeredRides = offered;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Fahrten: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Neu rendern, wenn Tab gewechselt wird
    });
    _loadRides();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //hier sind fahrten: die titel bzw dann auch datum und die fahrten in den tagen
  Map<String, List<String>> fahrten = {
    'Heute': ['Fahrt 1', 'Fahrt 2', 'Fahrt 3', 'Fahrt 4', 'Fahrt 5'],
    'Morgen': ['Fahrt 1', 'Fahrt 2', 'Fahrt 3'],
    'Übermorgen': ['Fahrt 1', 'Fahrt 2'],
    'Nächste Woche': ['Fahrt 1', 'Fahrt 2', 'Fahrt 3', 'Fahrt 4'],
  };

  void addFahrt(String tag, String fahrt) {
    setState(() {
      if (fahrten.containsKey(tag)) {
        fahrten[tag]?.add(fahrt);
      } else {
        fahrten[tag] = [fahrt];
      }
    });
  }

  void removeFahrt(String tag, String fahrt) {
    setState(() {
      if (fahrten.containsKey(tag)) {
        fahrten[tag]?.remove(fahrt);
        if (fahrten[tag]?.isEmpty ?? false) {
          fahrten.remove(tag);
        }
      }
    });
  }

  @override
  Widget _buildRideList(List<Map<String, dynamic>> rides) {
    var groupedRides = _groupRidesByDate(rides); // Gruppiere die Fahrten nach Datum

    return ListView(
      physics: BouncingScrollPhysics(),
      children: groupedRides.entries.map((entry) {
        String group = entry.key;
        List<Map<String, dynamic>> ridesInGroup = entry.value;

        if (ridesInGroup.isEmpty) {
          return SizedBox.shrink(); // Wenn keine Fahrten in dieser Gruppe, überspringe
        }

        if (group == 'Vergangene Fahrten') {
          // Für vergangene Fahrten verwenden wir ExpansionTile
          return ExpansionTile(
            title: Text(
              group,
              style: TextStyle(
                fontSize: Sizes.textSubheading,
                fontWeight: FontWeight.w600,
                color: dark_blue,
              ),
            ),
            children: ridesInGroup.map((ride) {
              print("gebuchte Fahrten   ride:  ");
              print(ride);
              // Hier extrahieren wir das Datum und den Zielort korrekt
              var rideData = ride['ride'] ?? ride; // Wenn ride['ride'] null ist, greifen wir auf ride direkt zu
              String endLocation = rideData['end_location'] ?? 'Unbekanntes Ziel';
              String date = rideData['date'] ?? 'Unbekannte Zeit';

              return Padding(
                padding: EdgeInsets.only(bottom: Sizes.paddingSmall),
                child: Container(
                  decoration: BoxDecoration(
                    color: background_box_white,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.directions_car, color: button_blue),
                    title: Text(
                      endLocation,
                      style: TextStyle(color: dark_blue, fontSize: Sizes.textNormal),
                    ),
                    subtitle: Text(
                      'Abfahrt: ${_formatDate(date)}', // Wir formatieren das Datum hier
                      style: TextStyle(color: dark_blue, fontSize: Sizes.textSubText),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _onRideClicked(ride); // Hier die Methode für die Weiterleitung aufrufen
                    },
                  ),
                ),
              );
            }).toList(),
          );
        }

        // Für alle anderen Gruppen
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingSmall, horizontal: Sizes.paddingRegular),
              child: Text(
                group,
                style: TextStyle(
                  fontSize: Sizes.textSubheading,
                  fontWeight: FontWeight.w600,
                  color: dark_blue,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true, // Verhindert, dass die ListView unendlich wächst
              physics: NeverScrollableScrollPhysics(),
              itemCount: ridesInGroup.length,
              itemBuilder: (context, index) {
                var rideData = ridesInGroup[index]['ride'] ?? ridesInGroup[index]; // Hier wieder dieselbe Logik
                String endLocation = rideData['end_location'] ?? 'Unbekanntes Ziel';
                String date = rideData['date'] ?? 'Unbekannte Zeit';

                return Padding(
                  padding: EdgeInsets.only(bottom: Sizes.paddingSmall),
                  child: Container(
                    decoration: BoxDecoration(
                      color: background_box_white,
                      borderRadius: BorderRadius.circular(Sizes.borderRadius),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.directions_car, color: button_blue),
                      title: Text(
                        endLocation,
                        style: TextStyle(color: dark_blue, fontSize: Sizes.textNormal),
                      ),
                      subtitle: Text(
                        'Abfahrt: ${_formatDate(date)}',
                        style: TextStyle(color: dark_blue, fontSize: Sizes.textSubText),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _onRideClicked(ridesInGroup[index]); // Hier die Methode für die Weiterleitung aufrufen
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(Sizes.paddingRegular),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Sizes.paddingRegular),
              SizedBox(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/undraw_order_ride.svg',
                    width: Sizes.deviceWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: Sizes.paddingRegular),
              Text(
                "Gebuchte Fahrten",
                style: TextStyle(
                  fontSize: Sizes.textHeading,
                  fontWeight: FontWeight.w900,
                  color: dark_blue,
                ),
              ),
              SizedBox(height: Sizes.paddingBig),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                ),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: background_box_white,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Alle'),
                      Tab(text: 'Mitfahrer*in'),
                      Tab(text: 'Fahrer*in'),
                    ],
                    indicatorColor: button_blue,
                    labelStyle: TextStyle(fontSize: Sizes.textSubheading),
                    labelColor: button_blue,
                    unselectedLabelColor: text_sekundr,
                  ),
                ),
              ),
              SizedBox(height: Sizes.paddingRegular),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRideList([...bookedRides, ...offeredRides]), // Alle Fahrten
                    _buildRideList(bookedRides), // Nur Mitfahrer-Fahrten
                    _buildRideList(offeredRides), // Nur Fahrer-Fahrten
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
