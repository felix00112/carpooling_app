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
            TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Alle'),
              Tab(text: 'Mitfahrer'),
              Tab(text: 'Fahrer'),
            ],
            indicatorColor: Colors.blue,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Beispielanzahl der gebuchten Fahrten
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.directions_car, color: button_blue),
                      title: Text('Fahrt ${index + 1}'),
                      subtitle: Text('Details zur Fahrt ${index + 1}'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Aktion bei Klick auf eine Fahrt
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}