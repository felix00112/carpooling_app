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
  TextEditingController neuEmailinputcontroller = TextEditingController();
  TextEditingController altEmailinputcontroller = TextEditingController();
  TextEditingController neuPasswortinputcontroller = TextEditingController();
  TextEditingController altPasswortinputcontroller = TextEditingController();
  TextEditingController neuesPasswortinputcontroller = TextEditingController();
  bool _showPasswordHint = false;
  bool _isPassword = false;


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

      body: Center(//wenn nicht Mittig verlaget, dann SingleChildScrollView statt Center
        child: Padding(
          padding: EdgeInsets.only(top: Sizes.paddingBig, left: Sizes.paddingSmall, right: Sizes.paddingSmall),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background_box_white,
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //Inhalt
              children: [
                //Überschrift Mail
                Padding(padding: EdgeInsets.only(top:Sizes.paddingRegular, bottom:Sizes.paddingSmall, left:Sizes.paddingSmall, right:Sizes.paddingSmall),
                  child: Text("E-Mail Adresse:",
                    style: TextStyle(
                        color: dark_blue,
                        fontSize: Sizes.textSubheading
                    ),
                  ),
                ),

                //alte Mail
                Padding(
                  padding: EdgeInsets.only(left: Sizes.paddingSmall, right: Sizes.paddingSmall, bottom: Sizes.paddingSmall),
                  child: TextField(
                    controller: neuEmailinputcontroller,
                    decoration: InputDecoration(
                      labelText: "alte E-Mail Adresse",
                      prefixIcon: Icon(FontAwesomeIcons.envelope),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //neue Mail
                Padding(
                  padding: EdgeInsets.only(left: Sizes.paddingSmall, right: Sizes.paddingSmall, bottom: Sizes.paddingRegular),
                  child: TextField(
                    controller: altEmailinputcontroller,
                    decoration: InputDecoration(
                      labelText: "neue E-Mail Adresse",
                      prefixIcon: Icon(FontAwesomeIcons.envelope),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                //Überschrift Passwort
                Padding(padding: EdgeInsets.only(top:Sizes.paddingRegular, bottom:Sizes.paddingSmall, left:Sizes.paddingSmall, right:Sizes.paddingSmall),
                  child: Text("Passwort:",
                    style: TextStyle(
                        color: dark_blue,
                        fontSize: Sizes.textSubheading
                    ),
                  ),
                ),

                //altes Passwort
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall),
                  child: TextField(
                    controller: altPasswortinputcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "altes Passwort",
                      prefixIcon: Icon(FontAwesomeIcons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isPassword,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall),
                    child: Text(
                      "Bitte geben Sie Ihr Passwort ein!!",
                      style: TextStyle(color: text_error, fontSize: Sizes.textSubText),
                    ),
                  ),
                ),

                SizedBox(height: Sizes.paddingSmall),

                //neues PW
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall),
                  child: TextField(
                    controller: neuPasswortinputcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "neues Passwort",
                      prefixIcon: Icon(FontAwesomeIcons.key),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() { //kontrollieren ob pw allgemeinen richtlinien passt
                        _showPasswordHint = text.isNotEmpty && text.length < 8;
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: _showPasswordHint,
                  child: Padding(
                    padding: EdgeInsets.only(left: Sizes.paddingSmall, right: Sizes.paddingSmall, top: Sizes.paddingSmall),
                    child: Text(
                      "Das Passwort muss mindestens 8 Zeichen lang sein!",
                      style: TextStyle(color: text_error, fontSize: Sizes.textSubText),
                    ),
                  ),
                ),

                SizedBox(height: Sizes.paddingRegular),

                //SpeichernButton
                Padding(padding: EdgeInsets.only(left: Sizes.paddingSmall, right: Sizes.paddingSmall, bottom: Sizes.paddingRegular),
                  child: Stack(
                    children: [
                      CustomButton2(
                        label: 'Speichern',
                        onPressed: (){
                          //was soll passieren wenn man auf den speichern klickt
                          //übergabe/aktualisieren neuer Daten
                          //zurück zur homePage?
                          //bestätigungsnachricht?

                          setState(() {//Überprüfung OB ein PW eingegebn wurde
                            // Überprüfung, ob das alte Passwort eingegeben wurde
                            _isPassword = altPasswortinputcontroller.text.isEmpty;
                          });
                          if (_isPassword) { // Beende die Funktion bei leerer PW Eingabe, damit die Daten nicht gespeichert werden
                            return;
                          }

                          //Schauen ob eine von beiden Sachen geändert wurde
                          if(neuEmailinputcontroller.text.isEmpty || neuPasswortinputcontroller.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Gebe die neuen Daten ein!"))
                            );
                          }

                          //Bestätigungsnachricht, dass Daten geändert wurden
                          ScaffoldMessenger.of(context).showSnackBar(//Bestätigungsnachricht bisher ohne Bedingung
                              SnackBar(content: Text("Zugangsdaten wurden geändert!"))
                          );

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
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}