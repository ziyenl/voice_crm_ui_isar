// lib/utils/color_utils.dart

import 'package:flutter/material.dart';

/// Converts a hex color string (e.g., "#RRGGBB" or "RRGGBB") to a Flutter [Color] object.
Color hexToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor; // Add full opacity (FF) if not provided (AARRGGBB)
  }
  return Color(int.parse(hexColor, radix: 16));
}

/// Calculates a contrasting text color ([Colors.black] or [Colors.white])
/// for a given background color hex string to ensure readability (WCAG compliance).
Color getContrastTextColor(String hexColorString) {
  final Color backgroundColor = hexToColor(hexColorString);

  // Calculate luminance based on sRGB values for WCAG contrast
  double getLuminanceComponent(double c) {
    c /= 255.0;
    return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) * ((c + 0.055) / 1.055);
  }

  final double r = getLuminanceComponent(backgroundColor.r.toDouble());
  final double g = getLuminanceComponent(backgroundColor.g.toDouble());
  final double b = getLuminanceComponent(backgroundColor.b.toDouble());

  // Relative luminance formula
  final double luminance = (0.2126 * r + 0.7152 * g + 0.0722 * b);

  // Return white for dark colors, black for light colors based on a threshold
  return luminance > 0.5 ? Colors.black : Colors.white;
}