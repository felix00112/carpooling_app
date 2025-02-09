import 'package:flutter/material.dart';

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
    return BottomNavigationBar(
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
      selectedItemColor: Colors.blue, // Color for selected item
      unselectedItemColor: Colors.grey, // Color for unselected items
    );
  }
}