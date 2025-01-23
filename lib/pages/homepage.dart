import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/colors.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedOption = "Anbieten";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Menü',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
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
                  'assets/images/undraw_city_driver.svg',
                  width: 700,
                  height: 700,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Wohin möchtest du fahren?",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: button_blue,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Start",
                prefixIcon: Icon(Icons.gps_fixed),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Ziel",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Zeitpunkt",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Anbieten"),
                    value: "Anbieten",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Suchen"),
                    value: "Suchen",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Button-Action hier einfügen
                },
                icon: SvgPicture.asset(
                  'assets/icons/route.svg',
                  height: 24,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ), // Verwende SVG-Icon
                label: Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 18, // Schriftgröße anpassen
                    fontWeight: FontWeight.bold, // Schriftstärke anpassen
                    color: Colors.white, // Textfarbe anpassen
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: button_blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: Size(double.infinity, 60), // Button länger machen
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30), // Nur untere Ecken abrunden
                      bottomRight: Radius.circular(30),
                    ), // Abgerundete Ecken
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
