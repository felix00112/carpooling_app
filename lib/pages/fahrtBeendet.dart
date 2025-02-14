import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import 'package:carpooling_app/constants/sizes.dart';
import '../constants/navigationBar.dart'; // Import der NavigationBar

class FahrtBeendet extends StatefulWidget {
  const FahrtBeendet({super.key});

  @override
  _FahrtBeendetState createState() => _FahrtBeendetState();
}

class _FahrtBeendetState extends State<FahrtBeendet> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Sizes.paddingSmall), //allgemeiner Rand zwischen Inhalt und handyrand
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Sizes.topBarHeight,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_completing_gsf8.svg',
                  width: 700,
                  height: 700,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // platz über überschrift
            Text(
              "Fahrt Beendet!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: dark_blue,
              ),
            ),

            SizedBox(height: Sizes.paddingRegular), // platz unter überschrift


          ],
        ),
      ),
    );
  }
}