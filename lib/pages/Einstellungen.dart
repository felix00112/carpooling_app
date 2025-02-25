import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';

List<Map<String,dynamic>> settings_inhalt = [
  {
    "title":"Persönliche & Zahlungsdaten",
    "routing":"'/personal'"
  },
  {
    "title":"Angaben zum eigenen Auto",
    "routing":"'/car_details'"
  },
  {
    "title":"Konto",
    "routing":"'/account'"
  },
  {
    "title":"Sucheinstellungen",
    "routing":"'/search_settings'"
  }
];

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Navigation bar index
  int _currentIndex = 2;

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
    Sizes.initialize(context);
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),


      appBar: AppBar( //header
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Zurück-Navigation
          },
        ),
        title: Text(
          'Einstellungen',
          style: TextStyle(fontSize: Sizes.textHeading),
        ),
        centerTitle: true,
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular, vertical: Sizes.paddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox( //Bild
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_settings.svg',
                  width: Sizes.deviceWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            //Inhalt
            SizedBox(height: Sizes.paddingRegular),
            ...settings_inhalt.map((entry){
              return Padding(
                padding: EdgeInsets.only(bottom: Sizes.paddingSmall),
                child: Container(
                  decoration: BoxDecoration(
                    color: background_box_white,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  ),
                  child: ListTile(
                    title: Text(entry["title"],style: TextStyle(fontSize: Sizes.textNormal),),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, entry["routing"]);
                    },
                  ),
                ),
              );
            }),
          ],
        )
      )
    );
  }
}

/*class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: Sizes.textSubheading)),
          //trailing: Icon(Icons.arrow_forward_ios, size: Sizes.textSizeRegular,),
          onTap: onTap,
        ),
      ],
    );
  }
}
*/
//alter Code
/*
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
          style: TextStyle(color: dark_blue),
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
              padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular), //Seitenabstand
              child: Align( // Damit der Block nicht die ganze Breite einnimmt
                alignment: Alignment.topCenter, // Oben bündig, horizontal zentriert
                child: Container(
                  decoration: BoxDecoration(
                    color: background_box_white,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius), // Abgerundete Ecken
                  ),
                  padding: EdgeInsets.symmetric(vertical: Sizes.paddingRegular), // Innenabstand für die Liste
                  child: ListView(
                    shrinkWrap: true, // Damit ListView nur so groß wie nötig ist
                    children: [
                      SettingsTile(
                        title: 'Persönliche & Zahlungsdaten',
                        onTap: () { //Navigation zu den entsprechenden Seiten basierend auf dem Index
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
 */