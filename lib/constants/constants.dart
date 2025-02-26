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

  static var deviceWidth;

  static void initialize(BuildContext context) {
    MediaQueryData m = MediaQuery.of(context);
    width = m.size.width;
    height = m.size.height;
    widthPercent = width / 100;
    heightPercent = height / 100;
    bottomNavigationHeight = widthPercent * 14; // Beispiel: kann nach Bedarf angepasst werden
  }
}