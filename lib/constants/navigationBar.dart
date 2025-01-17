import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';

/*
Indexing required to color the correct item corresponding to page
 */

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex; // The index of the currently selected page
  final Function(int) onTap; // A callback for handling tap events

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Highlight the selected page
      onTap: onTap, // Notify the parent widget when a tab is tapped
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Fahrten',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      selectedItemColor: button_blue, // Color for selected item
      unselectedItemColor: Colors.grey, // Color for unselected items
    );
  }
}