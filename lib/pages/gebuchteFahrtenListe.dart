import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import '../constants/navigationBar.dart'; // Import der NavigationBar

class GebuchteFahrtenListe extends StatefulWidget {
  const GebuchteFahrtenListe({super.key});

  @override
  _GebuchteFahrtenListeState createState() => _GebuchteFahrtenListeState();
}

class _GebuchteFahrtenListeState extends State<GebuchteFahrtenListe> with SingleTickerProviderStateMixin {
  ////////////////////Navigation bar/////////////////////
  int _currentIndex = 1; // Index für die aktuell ausgewählte Seite

  void _onTabTapped(int index) {
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
  }
  /////////////////////////////////////////////////////////

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //hier sind fahrten: die titel bzw dann auch datum und die fahrten in den tagen
  Map<String, List<String>> fahrten = {
    'Heute': ['Fahrt 1', 'Fahrt 2', 'Fahrt 30000', 'Fahrt 4', 'Fahrt 5'],
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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: background_box_white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_order_ride.svg',
                  width: 700,
                  height: 700,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Deine gebuchten Fahrten",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: dark_blue,
              ),
            ),
            SizedBox(height: 16),
            Container(
            decoration: BoxDecoration(
                color: Colors.white, // Hintergrundfarbe des Containers
                borderRadius: BorderRadius.circular(8), // Abrundung der Ecken
                boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 2.0),
                    ),
                ],
            ),
                child: TabBar(
                    controller: _tabController,
                        tabs: [
                        Tab(text: 'Alle'),
                        Tab(text: 'Mitfahrer'),
                        Tab(text: 'Fahrer'),
                        ],
                    indicatorColor: button_blue,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), // Text fett formatieren
                    labelColor: button_blue, // Farbe des ausgewählten Tabs
                    unselectedLabelColor: Colors.grey, // Farbe der nicht ausgewählten Tabs
                ),
            ),
            SizedBox(height: 16),
            Expanded(
                child: ListView(
                children: fahrten.entries.map((entry) {
                    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        ListTile(
                        title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                            return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                                leading: Icon(Icons.directions_car, color: button_blue),
                                title: Text(entry.value[index]),
                                subtitle: Text('Details zur ${entry.value[index]}'),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                // Aktion bei Klick auf eine Fahrt
                                },
                            ),
                            );
                        },
                        ),
                    ],
                    );
                }).toList(),
                ),
            ),
          ],
        ),
      ),
    );
  }
}