import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  // Variablen
  bool hasPet = false;
  bool flinta = false;
  bool smoker = false;

  // TextEditingController für die Eingabefelder
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();


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
          'Profil bearbeiten',
          style: TextStyle(fontSize: Sizes.textHeading),
        ),
        centerTitle: true,
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular, vertical: Sizes.paddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                width: Sizes.deviceWidth/3*2,
                height: Sizes.deviceWidth/3*2,
                child: Stack(
                  //alternatives Bild: 'assets/images/ProfileSettings.png',
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: Sizes.deviceWidth/3*2,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(FontAwesomeIcons.user, size: 80, color: Colors.black),
                    ),
                    Positioned(
                        bottom: Sizes.deviceWidth/18,
                        right: Sizes.deviceWidth/18,
                        child: CircleAvatar(
                          backgroundColor: text_sekundr,
                          child: Icon(FontAwesomeIcons.pencil, color: Colors.black),
                        ),
                    ),
                  ],
                ),
              ),
            ),
            
            
            //Abstand zwischen Profilbild und Text/Inhalt
            SizedBox(height: Sizes.paddingBig),

            //Inhalt
            DecoratedBox(
              decoration: BoxDecoration(
                color: background_box_white,
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
              ),
              child: Padding(
                //Abstand ganz oben und unten zwischen Box und Text
                padding: EdgeInsets.symmetric(vertical: Sizes.paddingRegular, horizontal: Sizes.paddingRegular),
                child: Column(
                  children: [
                    //Vorname
                    TextField(
                      controller: firstNameController, // Controller für Vorname
                      decoration: InputDecoration(
                        labelText: "Vorname",
                        prefixIcon: Icon(FontAwesomeIcons.solidUser, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Sizes.paddingSmall),

                    //Nachnamen
                    TextField(
                      controller: lastNameController, //Nachnamen Controller
                      decoration: InputDecoration(
                        labelText: "Nachname",
                        prefixIcon: Icon(FontAwesomeIcons.solidUser, color: Colors.black,),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Sizes.paddingSmall),

                    // Haustier Toggle
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall), // Gleicher Abstand wie bei den anderen TextFields
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.paw, color: Colors.black),
                              SizedBox(width: Sizes.paddingRegular),
                              Text("Hast du ein Tier?"),
                            ],
                          ),
                          Switch(
                            value: hasPet,
                            onChanged: (value) {
                              setState(() {
                                hasPet = value;
                              });
                            },
                            activeColor: green,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Sizes.paddingSmall),
                    //Flinta
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall), // Gleicher Abstand wie bei den anderen TextFields
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.peopleRoof, color: Colors.black),
                              SizedBox(width: Sizes.paddingRegular),
                              Text("Gehörst du zu Flinta?"),
                            ],
                          ),
                          Switch(
                            value: flinta,
                            onChanged: (value) {
                              setState(() {
                                flinta = value;
                              });
                            },
                            activeColor: green,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Sizes.paddingSmall),
                    //Smoker
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall), // Gleicher Abstand wie bei den anderen TextFields
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.smoking, color: Colors.black),
                              SizedBox(width: Sizes.paddingRegular),
                              Text("Gehörst du zu Flinta?"),
                            ],
                          ),
                          Switch(
                            value: smoker,
                            onChanged: (value) {
                              setState(() {
                                smoker = value;
                              });
                            },
                            activeColor: green,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Sizes.paddingSmall),

                    //Handynummer
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Handynummer",
                        prefixIcon: Icon(FontAwesomeIcons.mobileButton, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}