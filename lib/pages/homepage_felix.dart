import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import 'profilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedOption = "Anbieten";
  final TextEditingController _dateTimeController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: _buildDatePickerTheme,
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: _buildTimePickerTheme,
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _dateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime);
      }
    }
  }

  Widget _buildInputField(String label, IconData icon, {bool readOnly = false, TextEditingController? controller, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 24),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildOptionSelector() {
    return Row(
      children: ["Anbieten", "Suchen"].map((option) {
        return Expanded(
          child: RadioListTile(
            title: Text(option, style: TextStyle(fontWeight: FontWeight.bold)),
            value: option,
            groupValue: _selectedOption,
            onChanged: (value) => setState(() => _selectedOption = value.toString()),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: button_blue,
        colorScheme: ColorScheme.light(primary: button_blue, secondary: button_blue),
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: child!,
    );
  }

  Widget _buildTimePickerTheme(BuildContext context, Widget? child) => _buildDatePickerTheme(context, child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 2) { // Profilseite öffnen
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
        items: [
          _buildBottomNavItem(FontAwesomeIcons.house, 'Home', () {}),
          _buildBottomNavItem(FontAwesomeIcons.list, 'Menü', () {}),
          _buildBottomNavItem(FontAwesomeIcons.solidUser, 'Profil', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(),
            SizedBox(height: 16),
            _buildTitle(),
            SizedBox(height: 16),
            _buildInputField("Start", FontAwesomeIcons.locationCrosshairs),
            SizedBox(height: 16),
            _buildInputField("Ziel", FontAwesomeIcons.locationDot),
            SizedBox(height: 16),
            _buildInputField("Zeitpunkt", FontAwesomeIcons.calendar, readOnly: true, controller: _dateTimeController, onTap: () => _selectDateTime(context)),
            SizedBox(height: 16),
            _buildOptionSelector(),
            SizedBox(height: 16),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
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
    );
  }

  Widget _buildTitle() {
    return Text(
      "Wohin möchtest du fahren?",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: dark_blue),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label, VoidCallback onTap) {
    return BottomNavigationBarItem(
      // icon: Icon(icon, size: 24),
      icon: GestureDetector(onTap: onTap, child: Icon(icon, size: 24)),
      label: label,
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(FontAwesomeIcons.route, size: 24, color: Colors.white),
        label: Text("Start", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: button_blue,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),
        ),
      ),
    );
  }
}