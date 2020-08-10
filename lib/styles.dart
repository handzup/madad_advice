import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ThemeColors {
  static const Color primaryColor = Color(0xFF315f87);
  static const Color redindicator = Color(0xFFFF4C40);
  static const Color dividerColor = Color(0xFF445f83);
}

abstract class ThemeStyles {
  static const TextStyle whiteCardText = TextStyle(
      fontSize: 15.0,
      color: Colors.white,
      fontFamily: 'RobotoCondensed',
      letterSpacing: 1.4,
      fontWeight: FontWeight.w700);
  static const TextStyle headerText = TextStyle(
      fontSize: 17.0,
      color: Colors.black,
      fontFamily: 'RobotoCondensed',
      letterSpacing: 1.4,
      fontWeight: FontWeight.w700);
  static const TextStyle mainText = TextStyle(
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: 'RobotoCondensed',
    letterSpacing: 1.4,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle grayText = TextStyle(
      fontSize: 16.0,
      color: Colors.black45,
      fontFamily: 'RobotoCondensed',
      letterSpacing: 1.4,
      fontWeight: FontWeight.w400);
  static const TextStyle costTextBlue = TextStyle(
      fontSize: 20.0,
      color: Color(0xFF1254CA),
      fontFamily: 'RobotoCondensed',
      letterSpacing: 1.4,
      fontWeight: FontWeight.w800);
  static const TextStyle costTextBlack = TextStyle(
      fontSize: 20.0,
      color: Colors.black,
      fontFamily: 'RobotoCondensed',
      letterSpacing: 1.4,
      fontWeight: FontWeight.w800);
  static const TextStyle progresDaygray = TextStyle(
      fontSize: 14.0,
      color: Colors.black54,
      fontFamily: 'RobotoCondensed',
      fontWeight: FontWeight.w200);
}
