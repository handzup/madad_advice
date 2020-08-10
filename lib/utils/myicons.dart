import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DuoTonIcon extends FaDuotoneIcon {
  final double size;

  final Color secondaryColor;

  final Color primaryColor;
  DuoTonIcon(
    IconDataDuotone icon, {
    Key key,
    this.size,
    this.primaryColor,
    this.secondaryColor,
  }) : super(icon);

  @override
  Widget build(BuildContext context) {
    return FaDuotoneIcon(
      icon,
      size: size,
      primaryColor:
          primaryColor == null ? Colors.blue.withOpacity(.4) : primaryColor,
      secondaryColor: secondaryColor == null ? Colors.blue : secondaryColor,
    );
  }
}
