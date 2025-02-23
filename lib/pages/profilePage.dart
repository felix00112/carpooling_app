import 'dart:convert';

import 'package:carpooling_app/pages/faq.dart';
import 'package:carpooling_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carpooling_app/constants/colors.dart';
import '../auth/auth_service.dart';
import '../constants/navigationBar.dart'; // Import der NavigationBar
import '../services/car_service.dart';
import '../services/rating_service.dart';
import '../services/ride_service.dart';
import 'Einstellungen.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ////////////////////Navigation bar/////////////////////
  int _currentIndex = 2; // Index für die aktuell ausgewählte Seite

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigation zu den entsprechenden Seiten basierend auf dem Index ist nicht mehr notwendig
  }
/////////////////////////////////////////////////////////

  Map<String, dynamic>? realUserData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  final authService = AuthService();

  void logout() async {
    await authService.signOut();
    _currentIndex = 0;
  }

Future<void> _fetchUserData() async {
    final userService = UserService();
    final carService = CarService();
    final ratingService = RatingService();
    final rideService = RideService();
    final data = await userService.getUserProfile();
    final bool hasCar = await userService.hasUserCar(); // Auto-Check
    final carData = await carService.getCar();
    final ratings = await ratingService.getRatings(data?['id']);
    final ratingCount = ratings.length;
    final avgRating = ratings.isEmpty ? 0.0 : ratings.map((rating) => rating['rating']).reduce((a, b) => a + b) / ratings.length;
    final rideCount = await rideService.getRideCount(data?['id']);

    setState(() {
      realUserData = {
        ...?data,
        'has_car': hasCar,
        'car': carData,
        'ratings': ratings,
        'rating_count': ratingCount,
        'avg_rating': avgRating,
        'ride_count' : rideCount
      };
    });
    print(realUserData.toString());
}

  bool _isExpanded = false;

  final Map<String, dynamic> userData = {
    'name': 'Julia Meier',
    'memberSince': '2020',
    'isSmoker': true,
    'hasPets': true,
    'points': 200,
    'rides': 5,
    'reviews': 3,
    'car' : 'Opel',
    'seats': 4,
    'rating': 4.5,
    'reviewsText': [
      'Sehr freundliche Fahrerin!',
      'Auto war sauber und bequem.',
      'Pünktlich und zuverlässig!'
    ],
  };

  @override
  Widget build(BuildContext context) {

    final userEmail = authService.getCurrentUserEmail();

    if (realUserData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(FontAwesomeIcons.rightFromBracket, size: 24),
                    onPressed: () {
                      logout();
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.circleInfo, size: 24),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FaqsPage()),
                          );
                          // Info-Button Logik
                        },
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.gear, size: 24),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                          );// Einstellungen-Button Logik
                        },
                      ),
                    ],
                  ),
                ],
              ),

              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(FontAwesomeIcons.user, size: 50, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10),

              SizedBox(height: 20),
              Text('${realUserData?['first_name']} ${realUserData?['last_name']}' ?? 'N/A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
              SizedBox(height: 5),
              Text(userEmail.toString()),
              SizedBox(height: 10),
              Chip(
                label: Text('Mitglied seit ${DateTime.parse(realUserData?['created_at'])?.year ?? 'N/A'}'),
                backgroundColor: button_lightblue,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (realUserData?['is_smoker'] == true) _buildFeatureChip(FontAwesomeIcons.smoking, 'Raucher*in'),
                  SizedBox(width: 10),
                  if (realUserData?['has_pats'] == true) _buildFeatureChip(FontAwesomeIcons.paw, 'Haustiere'),
                  SizedBox(width: 10),
                  if(realUserData?['has_car'] == true) _buildFeatureChip(FontAwesomeIcons.car, 'Auto'),
                  SizedBox(width: 10),
                  if (realUserData?['is_flinta'] == true) _buildFeatureChip(FontAwesomeIcons.transgender, 'Flinta'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(userData['points'].toString(), 'Punkte'),
                  _buildStatItem(realUserData!['ride_count'].toString(), 'Fahrten'),
                  _buildStatItem(realUserData!['rating_count'].toString(), 'Bewertungen'),
                ],
              ),
              SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mein Auto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.car, size: 18),
                          SizedBox(width: 5),
                          Text(realUserData?['car'] != null && realUserData!['car'].isNotEmpty
                              ? realUserData!['car'][0]['car_name']
                              : 'Kein Auto angegeben'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.hashtag, size: 18),
                          SizedBox(width: 5),
                          Text(realUserData?['car'] != null && realUserData!['car'].isNotEmpty
                              ? realUserData!['car'][0]['license_plate'] ?? 'Kein Auto angegeben'
                              : 'Kein Auto angegeben'),

                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.userGroup, size: 18),
                          SizedBox(width: 5),
                          Text(
                            realUserData?['car'] != null && realUserData!['car'].isNotEmpty
                                ? '${realUserData!['car'][0]['seats'] ?? 'Unbekannte Anzahl'} Sitze'
                                : 'Keine Sitze angegeben',
                          ),

                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          StarRating(rating: realUserData!['avg_rating'].toDouble()),
                          SizedBox(width: 5),
                          Text('(${realUserData!['avg_rating'].toStringAsFixed(2)}/5)', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Bewertungen anzeigen'),
                        initiallyExpanded: _isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _isExpanded = expanded;
                          });
                        },
                        children: realUserData?['ratings'] != null && realUserData!['ratings'].isNotEmpty
                            ? realUserData!['ratings'].map<Widget>((rating) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    StarRating(rating: rating['rating'].toDouble()), // Sterne-Bewertung
                                    SizedBox(width: 10),
                                    Text('(${rating['rating']}/5)', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text('- ${rating['review'] ?? 'Keine Bewertungstext'}', style: TextStyle(fontSize: 14)),
                                Divider(),
                              ],
                            ),
                          );
                        }).toList()
                            : [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Keine Bewertungen vorhanden', style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
/// **Neue StarRating Klasse** für dynamische Sterne-Bewertung
class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;

  const StarRating({Key? key, required this.rating, this.starCount = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index < rating.floor()) {
          return Icon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 18,);
        } else if (index < rating) {
          return Icon(FontAwesomeIcons.starHalfStroke, color: Colors.amber, size: 18,);
        } else {
          return Icon(FontAwesomeIcons.star, color: Colors.amber, size: 18,);
        }
      }),
    );
  }
}