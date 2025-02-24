import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/pages/faq.dart';
import 'package:carpooling_app/pages/gebuchteFahrtenListe.dart';
import 'package:carpooling_app/pages/homepage.dart';
import 'package:carpooling_app/pages/fahrt_suchen.dart';
import 'package:carpooling_app/pages/fahrtAnbieten.dart';
//import 'package:carpooling_app/pages/homepage_felix.dart';
import 'package:carpooling_app/pages/profilePage.dart';
import 'package:carpooling_app/pages/fahrtFahrerin.dart';
import 'package:carpooling_app/pages/fahrtMitfahrerin.dart';
import 'package:carpooling_app/pages/Einstellungen.dart';
import 'package:carpooling_app/pages/fahrtBeendet.dart';
import 'package:carpooling_app/pages/profile_completion_page.dart';
import 'package:carpooling_app/pages/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import 'auth/auth_gate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // supabase setup
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhybWRwZGJ2bGxxanRjYm11ampjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAwMDE5MDIsImV4cCI6MjA1NTU3NzkwMn0.rXGUkK0LUYOnyvkHIYRG0NFVPkMfjXlEF7QmYFSpgH4",
    url: "https://hrmdpdbvllqjtcbmujjc.supabase.co",
  );

  // Data base connection check
  try {
    final response = await Supabase.instance.client
        .from('cars') // Ersetze mit einer existierenden Tabelle
        .select()
        .limit(1);

    if (response.isNotEmpty) {
      print('✅ Verbindung erfolgreich: $response');
    } else {
      print('⚠️ Verbindung erfolgreich, aber keine Daten gefunden');
    }
  } catch (e) {
    print('❌ Verbindung fehlgeschlagen: $e');
  }


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carpooling App',
      theme: ThemeData( //default Hintergrund
        scaffoldBackgroundColor: background_default,
        appBarTheme: AppBarTheme(
          backgroundColor: background_default,
          titleTextStyle: TextStyle(color: dark_blue, fontWeight: FontWeight.bold), //fontSize: Sizes.textHeading,
        ),
      ),
      home: AuthGate(),
      routes: {
        //hier die drei routen für die bottom navigation bar

        // '/': (context) => HomePage(),
        '/fahrten': (context) => GebuchteFahrtenListe(),
        '/profil': (context) => ProfilePage(),
        '/home': (context) => HomePage(),

        //suche starten
        //'/Suchen': (context) => FindRide(),
        //'/Anbieten': (context) => OfferRidePage(),
        //'/RideDetails': (context) => RideDetailsPage(),
        // weitere routen:
        '/Settings': (context) => SettingsPage(),
        '/goal': (context) => FahrtBeendet(),
        '/signup' : (context) => SignupPage(),
        '/complete-profile': (context) => ProfileCompletionPage(),
      },

    );
  }
}


