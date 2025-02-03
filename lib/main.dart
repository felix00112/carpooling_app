import 'package:carpooling_app/pages/gebuchteFahrtenListe.dart';
import 'package:carpooling_app/pages/homepage.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      //hier die drei routen für die bottom navigation bar

      '/': (context) => HomePage(),
      '/fahrten': (context) => GebuchteFahrtenListe(),
      //'/profil': (context) => ProfilePage(),

      // weitere routen:


      
    },
  ));
}


