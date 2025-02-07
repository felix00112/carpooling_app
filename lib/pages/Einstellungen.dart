import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Navigation bar index
  int _currentIndex = 1;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      appBar: AppBar( //header
        backgroundColor: background_grey,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrowLeft.svg',
            height: 24,
            colorFilter: ColorFilter.mode(dark_blue, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context); // Zurück-Navigation
          },
        ),
        title: Text(
          'Einstellungen',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header image and illustration
          Container(
            height: 200,
            decoration: BoxDecoration( //box around picture
              //color: background_box_white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/undraw_settings.svg',
                width: 150, // Passe Breite an
                height: 150, // Passe Höhe an
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Settings options
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16), //Seitenabstand
              child: Align( // Damit der Block nicht die ganze Breite einnimmt
                alignment: Alignment.topCenter, // Oben bündig, horizontal zentriert
                child: Container(
                  decoration: BoxDecoration(
                    color: background_box_white,
                    borderRadius: BorderRadius.circular(12), // Abgerundete Ecken
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16), // Innenabstand für die Liste
                  child: ListView(
                    shrinkWrap: true, // Damit ListView nur so groß wie nötig ist
                    children: [
                      SettingsTile(
                        title: 'Persönliche & Zahlungsdaten',
                        onTap: () {
                          Navigator.pushNamed(context, '/personal');
                        },
                      ),
                      Divider(), // Trennlinie
                      SettingsTile(
                        title: 'Angaben zum eigenen Auto',
                        onTap: () {
                          Navigator.pushNamed(context, '/car_details');
                        },
                      ),
                      Divider(),
                      SettingsTile(
                        title: 'Konto',
                        onTap: () {
                          Navigator.pushNamed(context, '/account');
                        },
                      ),
                      Divider(),
                      SettingsTile(
                        title: 'Sucheinstellungen',
                        onTap: () {
                          Navigator.pushNamed(context, '/search_settings');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsTile({super.key, 
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16,),
          onTap: onTap,
        ),
      ],
    );
  }
}

/*
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: SettingsPage(),
  routes: {
    '/home': (context) => HomeScreen(), // Definiere deine Seiten hier
    '/fahrten': (context) => FahrtenScreen(),
    '/profil': (context) => ProfilScreen(),
    '/personal': (context) => PersonalScreen(),
    '/car_details': (context) => CarDetailsScreen(),
    '/account': (context) => AccountScreen(),
    '/search_settings': (context) => SearchSettingsScreen(),
  },
));
*/