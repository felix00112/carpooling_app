import 'package:carpooling_app/pages/fahrtAnbieten.dart';
import 'package:carpooling_app/pages/fahrt_suchen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart'; // Import hinzufügen
import 'package:carpooling_app/constants/sizes.dart';
import '../constants/navigationBar.dart'; // Import der NavigationBar
import '../constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _formKey = GlobalKey<FormState>(); // Form Key für Validierung
  final TextEditingController Startinputcontroller = TextEditingController();
  final TextEditingController Zielinputcontroller = TextEditingController();
  String _selectedOption = "Anbieten";
  final TextEditingController _dateTimeController = TextEditingController();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void initState() {
    super.initState();
    _setDefaultDateTime();
  }


  void _setDefaultDateTime() {
    DateTime now = DateTime.now();
    _dateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime now = DateTime.now(); // Aktuelle Zeit holen
    DateTime? date;
    TimeOfDay? time;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      date = pickedDate;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      time = pickedTime ?? TimeOfDay.fromDateTime(now); // Falls keine Uhrzeit gewählt wird, nehme aktuelle Zeit
    } else {
      date = now; // Falls kein Datum gewählt wird, nehme aktuelles Datum
      time = TimeOfDay.fromDateTime(now);
    }

    final DateTime finalDateTime = DateTime(
      date!.year,
      date.month,
      date.day,
      time!.hour,
      time.minute,
    );

    _dateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm').format(finalDateTime);
  }

  void _handleStart() {
    setState(() {
      if (Startinputcontroller.text.isEmpty) {
        Startinputcontroller.text = "Bitte ausfüllen!";
      }
      if (Zielinputcontroller.text.isEmpty) {
        Zielinputcontroller.text = "Bitte ausfüllen!";
      }
    });

    // Stelle sicher, dass keine "Bitte ausfüllen!"-Werte gesendet werden
    if (Startinputcontroller.text != "Bitte ausfüllen!" &&
        Zielinputcontroller.text != "Bitte ausfüllen!") {
      if (_selectedOption == "Suchen") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FindRide(
              Starteingabe: Startinputcontroller.text,
              Zieleingabe: Zielinputcontroller.text,
              Zeitpunkt: _dateTimeController.text,
            ),
          ),
        );
      } else if (_selectedOption == "Anbieten") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferRidePage(
              Starteingabe: Startinputcontroller.text,
              Zieleingabe: Zielinputcontroller.text,
              Zeitpunkt: _dateTimeController.text,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
  Sizes.initialize(context);
  return Scaffold(
    bottomNavigationBar: CustomBottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(Sizes.paddingRegular),
      child: Form(
        key: _formKey, // Formular mit Key um Validierung zu ermöglichen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.topBarHeight,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_city_driver.svg',
                  width: Sizes.deviceWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular),
            Text(
              "Wohin möchtest du fahren?",
              style: TextStyle(
                fontSize: Sizes.textHeading,
                fontWeight: FontWeight.w900,
                color: dark_blue,
              ),
            ),
            SizedBox(height: Sizes.paddingBig),
            DecoratedBox(
              decoration: BoxDecoration(
                color: background_box_white,
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
              ),
              child: Column(
                children: [
                  SizedBox(height: Sizes.paddingRegular),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall),
                    child: TextField(
                      controller: Startinputcontroller,
                      decoration: InputDecoration(
                        labelText: "Start",
                        prefixIcon: Icon(Icons.gps_fixed),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: Startinputcontroller.text == "Bitte ausfüllen!" ? text_error : dark_blue,
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {}); // Aktualisiert nur die Farbe des Labels
                      },
                    ),
                  ),

                  SizedBox(height: Sizes.paddingSmall),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall),
                    child: TextField(
                      controller: Zielinputcontroller,
                      decoration: InputDecoration(
                        labelText: "Ziel",
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: Zielinputcontroller.text == "Bitte ausfüllen!" ? text_error : dark_blue,
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {}); // Aktualisiert nur die Farbe des Labels
                      },
                    ),
                  ),

                  SizedBox(height: Sizes.paddingSmall),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall),
                    child: TextField(
                      controller: _dateTimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Zeitpunkt",
                        fillColor: dark_blue,
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectDateTime(context),
                    ),
                  ),
                  SizedBox(height: Sizes.paddingSmall),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text(
                            "Anbieten",
                            style: TextStyle(
                              fontSize: Sizes.textNormal,
                              fontWeight: FontWeight.bold,
                              color: dark_blue,
                            ),
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
                          title: Text(
                            "Suchen",
                            style: TextStyle(
                              fontSize: Sizes.textNormal,
                              fontWeight: FontWeight.bold,
                              color: dark_blue,
                            ),
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
                  SizedBox(height: Sizes.paddingSmall),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _handleStart,
                      icon: SvgPicture.asset(
                        'assets/icons/route.svg',
                        height: 24,
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      label: Text(
                        "Start",
                        style: TextStyle(
                          fontSize: Sizes.textSubheading,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: button_blue,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(Sizes.borderRadius),
                            bottomRight: Radius.circular(Sizes.borderRadius),
                          ),
                        ),
                      ),
                    ),
                  ),
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
