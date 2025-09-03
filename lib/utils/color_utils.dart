// lib/utils/color_utils.dart

import 'package:flutter/material.dart';

Color hexToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor; 
  }
  return Color(int.parse(hexColor, radix: 16));
}

Color getContrastTextColor(String hexColorString) {
  final Color backgroundColor = hexToColor(hexColorString);

  double getLuminanceComponent(double c) {
    c /= 255.0;
    return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) * ((c + 0.055) / 1.055);
  }

  final double r = getLuminanceComponent(backgroundColor.r.toDouble());
  final double g = getLuminanceComponent(backgroundColor.g.toDouble());
  final double b = getLuminanceComponent(backgroundColor.b.toDouble());

  final double luminance = (0.2126 * r + 0.7152 * g + 0.0722 * b);

  return luminance > 0.5 ? Colors.black : Colors.white;
}
