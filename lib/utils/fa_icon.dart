import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'myicons.dart';

class FaIcons extends StatelessWidget {
  final double size;

  final Color secondaryColor;

  final Color primaryColor;

  final icon;
  final Color color;
  const FaIcons(this.icon,
      {Key key, this.size, this.secondaryColor, this.primaryColor, this.color})
      : super(key: key);
  String removeSecondString(String s) {
    var cc = s.split(' ').length - 1;
    if (cc == 1) {
      return s;
    }
    int k = s.indexOf(" ", s.indexOf(" ") + 1);
    String res = s.substring(0, k);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (icon.contains('fad')) {
      return DuoTonIcon(
        FontAwesomeIcons.getIconString[removeSecondString(icon.toString())],
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      );
    }
    return Icon(
      FontAwesomeIcons.getIconString[icon.toString()],
      color: color,
      size: size,
    );
  }
}
