import 'package:carpooling_app/pages/gebuchteFahrtenListe.dart';
import 'package:carpooling_app/pages/homepage.dart';
import 'package:carpooling_app/pages/fahrt_suchen_aria.dart';
import 'package:carpooling_app/pages/fahrtAnbieten.dart';
//import 'package:carpooling_app/pages/homepage_felix.dart';
import 'package:carpooling_app/pages/profilePage.dart';
import 'package:carpooling_app/pages/fahrtFahrerin.dart';
import 'package:carpooling_app/pages/fahrtMitfahrerin.dart';

import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      //hier die drei routen für die bottom navigation bar

      '/': (context) => HomePage(),
      '/fahrten': (context) => GebuchteFahrtenListe(),
      '/profil': (context) => ProfilePage(),
      '/Suchen': (context) => findRide(),
      '/Anbieten': (context) => OfferRidePage(),
      '/RideDetails': (context) => RideDetailsPage()
      // weitere routen:


      
    },
  ));
}


