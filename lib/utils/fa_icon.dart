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

  @override
  Widget build(BuildContext context) {
    if (icon.contains('fad')) {
      return DuoTonIcon(
        FontAwesomeIcons.getIconString[icon.toString()],
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
