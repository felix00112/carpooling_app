import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carpooling_app/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isExpanded = false;

  final Map<String, dynamic> userData = {
    'name': 'Julia Meier',
    'memberSince': '2024',
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(FontAwesomeIcons.circleInfo, size: 24),
                    onPressed: () {
                      // Info-Button Logik
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.gear, size: 24),
                    onPressed: () {
                      // Einstellungen-Button Logik
                    },
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
              Text(userData['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
              SizedBox(height: 10),
              Chip(
                label: Text('Mitglied seit ${userData['memberSince']}'),
                backgroundColor: button_lightblue,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (userData['isSmoker']) _buildFeatureChip(FontAwesomeIcons.smoking, 'Raucher*in'),
                  SizedBox(width: 10),
                  if (userData['hasPets']) _buildFeatureChip(FontAwesomeIcons.paw, 'Haustiere'),
                  SizedBox(width: 10),
                  if(userData['car'] != null) _buildFeatureChip(FontAwesomeIcons.car, 'Auto'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(userData['points'].toString(), 'Punkte'),
                  _buildStatItem(userData['rides'].toString(), 'Fahrten'),
                  _buildStatItem(userData['reviews'].toString(), 'Bewertungen'),
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
                          Text(userData['car'] ?? 'Kein Auto angegeben'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.userGroup, size: 18),
                          SizedBox(width: 5),
                          Text('${userData['seats']} Sitze'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          StarRating(rating: userData['rating'].toDouble()),
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
                        children: userData['reviewsText'].map<Widget>((review) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('- $review'),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.list, size: 24),
            label: 'Menü',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUser, size: 24),
            label: 'Profil',
          ),
        ],
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