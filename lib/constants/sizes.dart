import 'package:flutter/material.dart';

class Sizes {
  static late double deviceWidth;
  static late double deviceHeight;

  static late double paddingSmall;
  static late double paddingRegular;
  static late double paddingBig;

  static late double textSubtitle;
  static late double textTitle;
  static late double textSubheading;
  static late double textHeading;

  static late double bottomBarHeight;

  static late double borderRadius;

  static void initialize(BuildContext context) {
    MediaQueryData m = MediaQuery.of(context);

    deviceWidth = m.size.width;
    deviceHeight = m.size.height;

    paddingSmall = deviceWidth * 0.02;
    paddingRegular = deviceWidth * 0.04;
    paddingBig = deviceWidth * 0.06;

    textSubtitle = deviceWidth * 0.031;
    textTitle = deviceWidth * 0.041;
    textSubheading = deviceWidth * 0.051;
    textHeading = deviceWidth * 0.062;

    borderRadius = deviceWidth * 0.025;
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

 */


