import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carpooling_app/constants/colors.dart';

/*
Indexing required to color the correct item corresponding to page
 */

class CustomBottomNavigationBar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //screenwidth parameter for icons
    return BottomNavigationBar(
      backgroundColor: background_box_white,
      currentIndex: currentIndex, // Highlight the selected page

      onTap: (index) {
        onTap(index); // Notify the parent widget when a tab is tapped
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/fahrten');
            break;
          case 2:
            Navigator.pushNamed(context, '/profil');
            break;
        }
      },
      items:  [
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.house, size: screenWidth * 0.07),
              SizedBox(height: 2), // small gap between icon and label
            ],
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.list, size: screenWidth * 0.07),
              SizedBox(height: 2), // small gap between icon and label
            ],
          ),
          label: 'Fahrten',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.solidUser, size: screenWidth * 0.07),
              SizedBox(height: 2), // small gap between icon and label
            ],
          ),
          label: 'Profil',
        ),
      ],
      selectedItemColor: button_blue, // Color for selected item
      unselectedItemColor: text_sekundr, // Color for unselected items
      selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),

    );
  }
}