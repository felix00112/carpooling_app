import 'package:carpooling_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/navigationBar.dart';
import '../constants/sizes.dart';


class ZugangsdatenPage extends StatefulWidget{
  const ZugangsdatenPage({super.key});
  @override
  State<ZugangsdatenPage> createState() => _ZugangsdatenPageState();
}

class _ZugangsdatenPageState extends State<ZugangsdatenPage>{
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
    );
  }
}