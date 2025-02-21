import 'package:flutter/material.dart';

class Sizes {
  static late double deviceWidth;
  static late double deviceHeight;

  static late double paddingSmall;
  static late double paddingRegular;
  static late double paddingBig;

  static late double textSubtitle;
  static late double textTitle; //normaler text
  static late double textSubheading;
  static late double textHeading;

  static late double bottomBarHeight;
  static late double topBarHeight; //subheader/bilder

  static late double ContentWidth;
  static late double ButtonHeight;

  static late double borderRadius;
  static late double borderRadiusButton;

  static void initialize(BuildContext context) {
    MediaQueryData m = MediaQuery.of(context);

    deviceWidth = m.size.width;
    deviceHeight = m.size.height;

    paddingSmall = deviceWidth * 0.02;
    paddingRegular = deviceWidth * 0.04;
    paddingBig = deviceWidth * 0.06;

    bottomBarHeight = deviceHeight * 0.06;
    topBarHeight = deviceHeight * 0.25;

    ContentWidth = deviceWidth * 0.925;
    ButtonHeight = deviceHeight * 0.12;

    textSubtitle = deviceWidth * 0.031;
    textTitle = deviceWidth * 0.041;
    textSubheading = deviceWidth * 0.051;
    textHeading = deviceWidth * 0.062;

    borderRadius = deviceWidth * 0.025;
    borderRadiusButton = deviceWidth * 0.005;
  }
}

/* in main.dart:
import

zum Verwenden der Sizes:
Widget build(BuildContext context){
  Sizes.initialize(content);

Beispiel:  in Text(
              style: TextStyle(
              fontSize:Sizes.textTitle



import 'package:flutter/material.dart';

class Sizes {
  static double width = 1, height = 1;
  static double widthPercent = 1, heightPercent = 1;
  static double bottomNavigationHeight = 1;

  static const double paddingSmall = 5;
  static const double paddingRegular = 10;
  static const double paddingMediumLarge = 15;
  static const double paddingBig = 20;

  static const double textSizeSmall = 12; // Untertext
  static const double textSizeRegular = 16; // Text
  static const double textSizeMedium = 20; // Unterüberschrift
  static const double textSizeBig = 24; // Überschrift

  static const double borderRadius10 = 10;

  void initialize(BuildContext context) {
    MediaQueryData m = MediaQuery.of(context);
    width = m.size.width;
    height = m.size.height;
    widthPercent = width / 100;
    heightPercent = height / 100;
    bottomNavigationHeight = widthPercent * 14; // Beispiel: kann nach Bedarf angepasst werden
  }
}


*/