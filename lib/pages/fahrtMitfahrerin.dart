import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';

class RidePickupPage extends StatelessWidget {
  const RidePickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      backgroundColor: background_grey,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // "Fahrten" Tab
        onTap: (index) {},
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: Sizes.deviceWidth * 0.3,
            decoration: BoxDecoration(
              color: button_lightblue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Sizes.borderRadius * 2),
                bottomRight: Radius.circular(Sizes.borderRadius * 2),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: Sizes.paddingBig),
            child: Center(
              child: Text(
                'Du wirst abgeholt von:',
                style: TextStyle(
                  fontSize: Sizes.textHeading,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDriverInfo(context),
                  SizedBox(height: Sizes.paddingBig),
                  _buildAddressBox(),
                  SizedBox(height: Sizes.paddingBig),
                  _buildNavigationButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressBox() {
    return Container(
      width: Sizes.deviceWidth * 0.8,
      padding: EdgeInsets.all(Sizes.paddingRegular),
      decoration: BoxDecoration(
        color: button_blue,
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: Center(
        child: Text(
          'Musterstraße 1, 10115 Berlin',
          style: TextStyle(color: Colors.white, fontSize: Sizes.textSubtitle * 1.2),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNavigationButton() {
    return CustomButton(
      label: 'Routenführung in externer App starten',
      onPressed: () {},
      color: button_orange,
      textColor: Colors.white,
      width: Sizes.deviceWidth * 0.7,
      height: Sizes.deviceHeight * 0.06,
    );
  }

  Widget _buildDriverInfo(BuildContext context) {
    return Container(
      width: Sizes.deviceWidth * 0.8,
      height: Sizes.deviceHeight * 0.2,
      padding: EdgeInsets.all(Sizes.paddingSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fahrer*in Profil geöffnet')),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Sascha  ',
                      style: TextStyle(
                        fontSize: Sizes.textSubtitle * 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.star, color: Colors.black38, size: Sizes.textSubtitle * 1.7),
                    Text('4,4', style: TextStyle(fontSize: Sizes.textSubtitle * 1.7)),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Telefonanruf für Mitfahrer gestartet')),
                  );
                },
                child: Icon(Icons.phone, color: Colors.black, size: Sizes.textSubtitle * 2),
              ),
            ],
          ),
          SizedBox(height: Sizes.paddingSmall),
          Divider(color: Colors.grey),
          SizedBox(height: Sizes.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_car, color: Colors.black54),
                  SizedBox(width: Sizes.paddingSmall),
                  Text(
                    'Opel Corsa',
                    style: TextStyle(
                      fontSize: Sizes.textSubtitle * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'B-BB 1312',
                style: TextStyle(
                  fontSize: Sizes.textSubtitle * 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}