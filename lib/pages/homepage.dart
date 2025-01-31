import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart'; // Import hinzufügen
import '../constants/navigationBar.dart'; // Import der NavigationBar

import '../constants/colors.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ////////////////////Navigation bar/////////////////////
  int _currentIndex = 0; // Index für die aktuell ausgewählte Seite

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigation zu den entsprechenden Seiten basierend auf dem Index ist nicht mehr notwendig
  }
/////////////////////////////////////////////////////////

  String _selectedOption = "Anbieten";
  TextEditingController _dateTimeController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? date = DateTime.now();
    TimeOfDay? time = TimeOfDay.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: button_blue, // Farbe der Kopfzeile
            colorScheme: ColorScheme.light(
              primary: button_blue, // Farbe der ausgewählten Zeit
              secondary: button_blue, // Farbe der Schaltflächen
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Farbe des Textes der Schaltflächen
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      date = pickedDate;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: time,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: button_blue, // Farbe der Kopfzeile
              colorScheme: ColorScheme.light(
                primary: button_blue, // Farbe der ausgewählten Zeit
                secondary: button_blue, // Farbe der Schaltflächen
              ),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary, // Farbe des Textes der Schaltflächen
              ),
            ),
            child: child!,
          );
        },        
      );

      if (pickedTime != null) {
        time = pickedTime;
        final DateTime finalDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        _dateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm').format(finalDateTime);
      }
    }
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
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: dark_blue,
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
              controller: _dateTimeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Zeitpunkt",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectDateTime(context),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Anbieten", 
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    title: Text("Suchen",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
