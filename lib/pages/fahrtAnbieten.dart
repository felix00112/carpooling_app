import 'package:carpooling_app/pages/fahrtFahrerin.dart';
import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/textField.dart';
import 'package:carpooling_app/constants/navigationBar.dart';

class OfferRidePage extends StatefulWidget {
  final String Starteingabe;
  final String Zieleingabe;
  const OfferRidePage({super.key, required this.Starteingabe, required this.Zieleingabe});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fahrt anbieten'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mitnahme:', style: TextStyle(fontSize: 16)),
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
                  const Text('Freie Plätze:', style: TextStyle(fontSize: 16)),
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
                  const Text('Gepäck:', style: TextStyle(fontSize: 16)),
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
                  const Text('Tiermitnahme:', style: TextStyle(fontSize: 16)),
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
                  const Text('Zwischenstopps:', style: TextStyle(fontSize: 16)),
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
                  const Text('Fahrzeug:', style: TextStyle(fontSize: 16)),
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
                  children: const [
                    CustomTextField(labelText: 'Kennzeichen', backgroundColor: Colors.grey),
                    SizedBox(height: 8),
                    CustomTextField(labelText: 'Autofarbe', backgroundColor: Colors.grey),
                    SizedBox(height: 8),
                    CustomTextField(labelText: 'Automodell', backgroundColor: Colors.grey),
                  ],
                ),
              const SizedBox(height: 16),
              const Text('Zahlungsmittel:', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildSelectableButton('Bar'),
                  _buildSelectableButton('PayPal'),
                  _buildSelectableButton('Kreditkarte'),
                ],
              ),
              const SizedBox(height: 32), // Platz für den Button unten
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      RideDetailsPage(Starteingabe: widget.Starteingabe,
                          Zieleingabe: widget.Zieleingabe)),
                );
              },
              style: ElevatedButton.styleFrom(

                backgroundColor: button_orange, // Farbe des Buttons
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Fahrt anbieten",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          ),
          CustomBottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {},
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
          color: isSelected ? button_blue : Colors.grey[200],
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
