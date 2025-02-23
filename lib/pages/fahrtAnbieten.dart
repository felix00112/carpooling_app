import 'package:carpooling_app/pages/fahrtFahrerin.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/textField.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import '../constants/button2.dart';
import '../constants/sizes.dart';

class OfferRidePage extends StatefulWidget {
  final String Starteingabe;
  final String Zieleingabe;
  final String Zeitpunkt;
  const OfferRidePage({super.key, required this.Starteingabe, required this.Zieleingabe, required this.Zeitpunkt});

  @override
  _OfferRidePageState createState() => _OfferRidePageState();
}

class _OfferRidePageState extends State<OfferRidePage> {
  bool _isLuggageAllowed = true;
  bool _isPetAllowed = false;
  int _freeSeats = 1;
  int _stops = 0;
  bool _useOwnCar = true;
  final Set<String> _selectedPaymentMethods = {};

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

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
  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fahrt anbieten",
          style: TextStyle(
            fontSize: Sizes.textHeading,
            fontWeight: FontWeight.bold,
            color: dark_blue,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: Sizes.paddingRegular), // Hier den Abstand verringern
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Verhindert zu viel vertikalen Abstand
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.925,
                padding: EdgeInsets.all(Sizes.paddingRegular),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mitnahme:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          DropdownButton<String>(
                            value: 'Alle',
                            items: const [
                              DropdownMenuItem(value: 'Alle', child: Text('Alle')),
                              DropdownMenuItem(value: 'Flinta*', child: Text('Nur Flinta*')),
                            ],
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Freie Plätze:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          DropdownButton<int>(
                            value: _freeSeats,
                            items: List.generate(
                              7,
                                  (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _freeSeats = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Gepäck:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _isLuggageAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isLuggageAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Ja'),
                              Radio<bool>(
                                value: false,
                                groupValue: _isLuggageAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isLuggageAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Nein'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tiermitnahme:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _isPetAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isPetAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Ja'),
                              Radio<bool>(
                                value: false,
                                groupValue: _isPetAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isPetAllowed = value!;
                                  });
                                },
                              ),
                              const Text('Nein'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Zwischenstopps:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          DropdownButton<int>(
                            value: _stops,
                            items: List.generate(
                              8,
                                  (index) => DropdownMenuItem(
                                value: index,
                                child: Text(index == 0 ? 'Keine' : '$index'),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _stops = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fahrzeug:', style: TextStyle(fontSize: Sizes.textSubheading)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _useOwnCar,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _useOwnCar = value!;
                                  });
                                },
                              ),
                              const Text('Eigenes'),
                              Radio<bool>(
                                value: false,
                                groupValue: _useOwnCar,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _useOwnCar = value!;
                                  });
                                },
                              ),
                              const Text('Neues Fahrzeug'),
                            ],
                          ),
                        ],
                      ),
                      if (!_useOwnCar)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(labelText: 'Kennzeichen', backgroundColor: Colors.grey),
                            SizedBox(height: Sizes.paddingSmall),
                            CustomTextField(labelText: 'Autofarbe', backgroundColor: Colors.grey),
                            SizedBox(height: Sizes.paddingSmall),
                            CustomTextField(labelText: 'Automodell', backgroundColor: Colors.grey),
                          ],
                        ),
                      SizedBox(height: Sizes.paddingSmall),
                      Text('Zahlungsmittel:', style: TextStyle(fontSize: Sizes.textSubheading)),
                      Wrap(
                        spacing: Sizes.paddingSmall,
                        children: [
                          _buildSelectableButton('Bar'),
                          _buildSelectableButton('PayPal'),
                          _buildSelectableButton('Kreditkarte'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Sizes.paddingRegular),
              _buildButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.paddingSmall),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomButton2(
            label: 'Fahrt anbieten',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    RideDetailsPage(Starteingabe: widget.Starteingabe,
                        Zieleingabe: widget.Zieleingabe)),
              );
            },
            color: button_blue,
            textColor: Colors.white,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.925,
            height: MediaQuery
                .of(context)
                .size
                .width * 0.12,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableButton(String label) {
    final isSelected = _selectedPaymentMethods.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedPaymentMethods.remove(label);
          } else {
            _selectedPaymentMethods.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? dark_blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
