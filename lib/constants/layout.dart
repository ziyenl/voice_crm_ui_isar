// constants/layout.dart

import 'package:flutter/material.dart';

/// Provides consistent spacing, border radius, and shadow values across the app.
class Layout {
  static const double _baseSpacing = 8.0;

  static Spacing spacing = Spacing();
  static BorderRadiusValues borderRadius = BorderRadiusValues();

  static const double screenWidth = 360.0; // Example, replace with actual screen width if needed
  static const double screenHeight = 640.0; // Example, replace with actual screen height if needed

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0; // Added for section marginBottom

  static const double borderRadiusMd = 8.0;
  static const double borderRadiusLg = 12.0; // From RN Modal style
  static const double borderRadiusFull = 999.0; // Effectively a pill shape
  
}

/// Defines various spacing increments based on a base unit.
class Spacing {
  final double xs = Layout._baseSpacing * 0.5; // 4.0
  final double sm = Layout._baseSpacing; // 8.0
  final double md = Layout._baseSpacing * 2; // 16.0
  final double lg = Layout._baseSpacing * 3; // 24.0
}

/// Defines common border radius values for UI elements.
class BorderRadiusValues {
  final BorderRadius md = BorderRadius.circular(8.0);
  final BorderRadius full = BorderRadius.circular(100.0); // For pill-shaped elements
}


