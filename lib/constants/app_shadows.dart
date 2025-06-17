// lib/constants/app_shadows.dart

import 'package:flutter/material.dart';

/// Defines common shadow styles for UI elements.
class AppShadows {
  static const BoxShadow sm = BoxShadow(
    color: Colors.black12, // Using a more common opaque black for shadows
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  static const BoxShadow md = BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: 0,
  );

  static const BoxShadow lg = BoxShadow(
    color: Colors.black38,
    offset: Offset(0, 8),
    blurRadius: 15,
    spreadRadius: 0,
  );
}