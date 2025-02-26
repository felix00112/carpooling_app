//import 'package:carpooling_app/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/button2.dart';
import '../constants/colors.dart';
import '../constants/navigationBar.dart';
import '../constants/sizes.dart';


class ZugangsdatenPage extends StatefulWidget{
  const ZugangsdatenPage({super.key});
  @override
  State<ZugangsdatenPage> createState() => _ZugangsdatenPageState();
}

class _ZugangsdatenPageState extends State<ZugangsdatenPage>{
  TextEditingController emailinputcontroller = TextEditingController();
  TextEditingController passwortinputcontroller = TextEditingController();

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
  Widget build(BuildContext context){
    Sizes.initialize(context);
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Zurück-Navigation
          },
        ),
        title: Text(
          'Zugangsdaten ändern',
          style: TextStyle(fontSize: Sizes.textHeading),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //Mail
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
                child: TextField(
                  controller: emailinputcontroller,
                  decoration: InputDecoration(
                    labelText: "alte e-Mail Adresse",
                    prefixIcon: Icon(FontAwesomeIcons.envelope),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              //Passwort
              /*Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
                  child: TextField(
                    controller: passwortinputcontroller,
                    decoration: InputDecoration(
                      labelText: "altes Passwort",
                      prefixIcon: Icon(FontAwesomeIcons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
              ),*/

              //SpeichernButton
              Stack(
                children: [
                  CustomButton2(
                    label: 'Speichern',
                    onPressed: (){
                      //was soll passieren wenn man auf den speichern klickt
                      //übergabe/aktualisieren neuer Daten
                      //zurück zur homePage?
                      //bestätigungsnachricht?
                    },
                    color: button_blue,
                    textColor: Colors.white,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.925,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 0.12,
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}