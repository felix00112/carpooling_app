import 'package:carpooling_app/pages/gebuchteFahrtenListe.dart';
import 'package:carpooling_app/pages/homepage.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/fahrten': (context) => GebuchteFahrtenListe(),
      //'/profil': (context) => ProfilePage(),
    },
  ));
}


