import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';

class RideDetailsPage extends StatelessWidget {
  const RideDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      backgroundColor: background_grey,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
      body: Column(
        children: [
          Container(
            color: background_grey,
            padding: EdgeInsets.only(bottom: Sizes.paddingSmall),
            child: Container(
              width: double.infinity,
              height:Sizes.deviceHeight*0.15,
              padding: EdgeInsets.symmetric(
                vertical: Sizes.paddingRegular,
                horizontal: Sizes.paddingBig,
              ),

              decoration: BoxDecoration(
                color: button_lightblue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Sizes.borderRadius * 2),
                  bottomRight: Radius.circular(Sizes.borderRadius * 2),
                ),
              ),
              child: Center(
                child: Text(
                  'Deine Fahrt',
                  style: TextStyle(
                    fontSize: Sizes.textHeading,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: Sizes.paddingSmall),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(
                    top: Sizes.deviceHeight * 0.2,
                    bottom: Sizes.deviceHeight * 0.15,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildPassengerTile(index + 1, context);
                  },
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: background_grey,
                        padding: EdgeInsets.only(bottom: Sizes.paddingSmall),
                        child: SizedBox(
                          width: Sizes.deviceWidth * 0.9,
                          child: CustomButton(
                            label: '  Musteradresse 1, 10115 Berlin',
                            onPressed: () {},
                            color: button_blue,
                            textColor: Colors.white,
                            width: double.infinity,
                            height: Sizes.deviceHeight * 0.06,
                            icon: Icons.gps_fixed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: background_grey,
                        padding: EdgeInsets.only(top: Sizes.paddingSmall),
                        child: SizedBox(
                          width: Sizes.deviceWidth * 0.9,
                          child: CustomButton(
                            label: '  Zieladresse 4, 10115 Berlin',
                            onPressed: () {},
                            color: button_blue,
                            textColor: Colors.white,
                            width: double.infinity,
                            height: Sizes.deviceHeight * 0.06,
                            icon: Icons.location_on,
                          ),
                        ),
                      ),
                      Container(
                        color: background_grey,
                        padding: EdgeInsets.only(top: Sizes.paddingSmall, bottom: Sizes.paddingSmall),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
                          child: CustomButton(
                            label: 'Routenführung in externer App starten',
                            onPressed: () {},
                            color: button_orange,
                            textColor: Colors.white,
                            width: Sizes.deviceWidth * 0.8,
                            height: Sizes.deviceHeight * 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerTile(int index, BuildContext context) {
    return Center(
      child: Container(
        width: Sizes.deviceWidth * 0.85,
        margin: EdgeInsets.symmetric(vertical: Sizes.paddingSmall),
        padding: EdgeInsets.all(Sizes.paddingRegular),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Sizes.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '14:00 Musteradresse $index, Stadt $index',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.textNormal,
              ),
            ),
            Divider(color: Colors.grey),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mitfahrer $index Profil geöffnet')),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Mitfahrer $index  ',
                          style: TextStyle(
                            fontSize: Sizes.textSubText,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.black38, size: Sizes.textSubText),
                        Text('4,4', style: TextStyle(fontSize: Sizes.textSubText)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Telefonanruf für Mitfahrer $index gestartet')),
                      );
                    },
                    child: Icon(Icons.phone, color: Colors.black, size: Sizes.textSubText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}