import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:flutter_map/flutter_map.dart';


class findRide extends StatelessWidget {
  final LatLng _startLocation = LatLng(52.5200, 13.4050);

  findRide({super.key}); // Beispiel-Koordinaten für Berlin

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Container(
        //
        color: Colors.black,
        child: Scaffold(
          backgroundColor: background_grey,
          appBar: AppBar(
              backgroundColor: background_grey,
              title:
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04), // 2% der Bildschirmhöhe
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.925,
                  color: background_grey,
                  alignment: Alignment.centerLeft,
                  child: Text("Fahrt suchen",
                      //textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.050,
                        fontWeight: FontWeight.w900,
                      )
                  ),
                ),
              )),
          body: Column(
            children: [
              _buildStartButton(context),
              _buildZielButton(context),
              _buildMap(context),
              _buildDriverList(context),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02), // 1% der Bildschirmhöhe
      child: Center( // Zentriert den gesamten Button
        child: Stack(
          alignment: Alignment.center, // Zentriert den Text
          children: [
            CustomButton(
              label: "Start",
              onPressed: () {
                print("Start-Button gedrückt");
              },
              color: button_blue,
              textColor: Colors.white,
              width: MediaQuery.of(context).size.width * 0.925,
              height: MediaQuery.of(context).size.width * 0.12,
            ),
            Positioned(
              left: 16, // Positioniert das Icon am linken Rand
              child: Icon(Icons.my_location, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildZielButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Stack(
        alignment: Alignment.center, // Zentriert den Text
        children: [
          CustomButton(
            label: "Ziel",
            onPressed: () {
              print("Ziel-Button gedrückt");
            },
            color: dark_blue,
            textColor: Colors.white,
            width: MediaQuery.of(context).size.width * 0.925,
            height: MediaQuery.of(context).size.width * 0.12,
          ),
          Positioned(
            left: 16, // Abstand zum linken Rand (je nach Button-Design anpassen)
            child: Icon(Icons.location_on, color: Colors.white),
          ),
        ],
      ),
    );
  }


  Widget _buildMap(BuildContext context) {
    // Beispielkoordinaten, passe _startLocation entsprechend an
    final LatLng startLocation = LatLng(52.5200, 13.4050); // z.B. Berlin

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.925,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FlutterMap(
            options: MapOptions(
              //onTap: _handleTap,
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app', // Passe den Paketnamen an
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverList(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94,
        child: ListView(
          children: [
            _buildDriverCard("Sascha", 4.0, "15:30", "2 freie Plätze", context),
            _buildDriverCard("Jonas", 4.5, "16:00", "3 freie Plätze", context),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(String name, double rating, String time, String seats, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01), // 5% der Bildschirmhöhe
      child: SizedBox(

        child: Card(
          color: Colors.white,
          child: Padding( // Fügt etwas Innenabstand hinzu
            padding: EdgeInsets.all(8.0),
            child: ListTile(

              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Vermeidet Überlauf
                children: [
                  Text(name),
                  Icon(Icons.directions_car),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Automatische Abstände
                    children: [
                      Text("Start: $time"),
                      Text(seats, style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ],
              ),
            ),
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