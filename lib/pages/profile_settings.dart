import 'dart:io';

import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../services/user_service.dart';


class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }



  // Variablen
  Map<String, dynamic>? userData;
  bool hasPet = false;
  bool isFlinta = false;
  bool isSmoker = false;
  String? avatarUrl;

  // TextEditingController für die Eingabefelder
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Fetch user data
  Future<void> _fetchUserData() async {
    final userService = UserService();
    final data = await userService.getUserProfile();
    setState(() {
      userData = {...?data,};
      firstNameController.text = userData?['first_name'] ?? '';
      lastNameController.text = userData?['last_name'] ?? '';
      phoneNumberController.text = userData?['phone_number'] ?? '';
      hasPet = userData?['has_pets'] ?? false;
      isFlinta = userData?['is_flinta'] ?? false;
      isSmoker = userData?['is_smoker'] ?? false;
      avatarUrl = userData?['avatar_url'];
    });
    print(userData.toString());
  }

  Future<void> saveProfileChanges() async {
    try {
      Map<String, dynamic> updates = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'phone_number': phoneNumberController.text,
        'has_pets': hasPet,
        'is_flinta': isFlinta,
        'is_smoker': isSmoker,
      };
      final userService = UserService();
      await userService.updateUserProfile(updates);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil erfolgreich aktualisiert")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Aktualisieren des Profils: $e")),
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return; // Nutzer hat kein Bild gewählt

    try {
      final userService = UserService();
      final String? newAvatarUrl = await userService.uploadProfileImage(pickedFile);

      if (newAvatarUrl != null) {
        setState(() {
          userData?['avatar_url'] = newAvatarUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profilbild erfolgreich aktualisiert")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fehler beim Hochladen des Bildes")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler: $e")),
      );
    }
  }





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
  Widget build(BuildContext context) {
    // indicator if data is not yet loaded
    if (userData == null) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    Sizes.initialize(context);
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),


      appBar: AppBar( //header
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Zurück-Navigation
          },
        ),
        title: Text(
          'Profil bearbeiten',
          style: TextStyle(fontSize: Sizes.textHeading),
        ),
        centerTitle: true,
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular, vertical: Sizes.paddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                width: Sizes.deviceWidth/3*2,
                height: Sizes.deviceWidth/3*2,
                child: Stack(
                  //alternatives Bild: 'assets/images/ProfileSettings.png',
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: Sizes.deviceWidth/3*2,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl!)
                          : null,
                      child: avatarUrl == null
                          ? Icon(FontAwesomeIcons.user, size: 50, color: Colors.black)
                          : null,
                    ),
                    Positioned(
                      bottom: Sizes.deviceWidth / 18,
                      right: Sizes.deviceWidth / 18,
                      child: GestureDetector(
                        onTap: _pickAndUploadImage, // Bildauswahl öffnen
                        child: CircleAvatar(
                          backgroundColor: text_sekundr,
                          child: Icon(FontAwesomeIcons.pencil, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            
            //Abstand zwischen Profilbild und Text/Inhalt
            SizedBox(height: Sizes.paddingBig),

            //Inhalt
            DecoratedBox(
              decoration: BoxDecoration(
                color: background_box_white,
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
              ),
              child: Padding(
                //Abstand ganz oben und unten zwischen Box und Text
                padding: EdgeInsets.symmetric(vertical: Sizes.paddingRegular, horizontal: Sizes.paddingRegular),
                child: Column(
                  children: [
                    //Vorname
                    TextField(
                      controller: firstNameController, // Controller für Vorname
                      decoration: InputDecoration(
                        labelText: "Vorname",
                        prefixIcon: Icon(FontAwesomeIcons.solidUser, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Sizes.paddingSmall),

                    //Nachnamen
                    TextField(
                      controller: lastNameController, //Nachnamen Controller
                      decoration: InputDecoration(
                        labelText: "Nachname",
                        prefixIcon: Icon(FontAwesomeIcons.solidUser, color: Colors.black,),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Sizes.paddingSmall),

                    // Haustier Toggle
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall), // Gleicher Abstand wie bei den anderen TextFields
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.paw, color: Colors.black),
                              SizedBox(width: Sizes.paddingRegular),
                              Text("Hast du ein Tier?"),
                            ],
                          ),
                          Switch(
                            value: hasPet,
                            onChanged: (value) {
                              setState(() {
                                hasPet = value;
                              });
                            },
                            activeColor: green,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Sizes.paddingSmall),
                    //Flinta
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall), // Gleicher Abstand wie bei den anderen TextFields
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.transgender, color: Colors.black),
                              SizedBox(width: Sizes.paddingRegular),
                              Text("Gehörst du zu Flinta?"),
                            ],
                          ),
                          Switch(
                            value: isFlinta,
                            onChanged: (value) {
                              setState(() {
                                isFlinta = value;
                              });
                            },
                            activeColor: green,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Sizes.paddingSmall),
                    //Smoker
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall), // Gleicher Abstand wie bei den anderen TextFields
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.smoking, color: Colors.black),
                              SizedBox(width: Sizes.paddingRegular),
                              Text("Bist du Raucher?"),
                            ],
                          ),
                          Switch(
                            value: isSmoker,
                            onChanged: (value) {
                              setState(() {
                                isSmoker = value;
                              });
                            },
                            activeColor: green,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Sizes.paddingSmall),

                    //Handynummer
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Handynummer",
                        prefixIcon: Icon(FontAwesomeIcons.mobileButton, color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: Sizes.paddingRegular),

                    ElevatedButton(
                      onPressed: saveProfileChanges,
                      child: Text("Speichern"),
                    ),

                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}