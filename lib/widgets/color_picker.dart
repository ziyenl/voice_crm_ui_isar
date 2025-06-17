// lib/widgets/color_picker.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/constants/layout.dart';
import 'package:voice_crm_ui_upgrade/constants/colors.dart';
import 'package:voice_crm_ui_upgrade/utils/color_utils.dart'; // For hexToColor and getContrastTextColor

/// A widget for selecting a color from a predefined list.
class ColorPicker extends StatelessWidget {
  final List<String> colors; // List of hex color strings (e.g., '#RRGGBB')
  final String selectedColor; // The currently selected hex color string
  final ValueChanged<String> onSelectColor; // Callback when a color is selected

  const ColorPicker({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Layout.spacingSm, // Horizontal spacing between color dots
      runSpacing: Layout.spacingSm, // Vertical spacing between rows
      children: colors.map((colorHex) {
        final bool isSelected = colorHex == selectedColor;
        final Color displayColor = hexToColor(colorHex);

        return GestureDetector(
          onTap: () => onSelectColor(colorHex), // Handle tap to select color
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: displayColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.neutral800 : Colors.transparent, // Highlight selected
                width: isSelected ? 2.5 : 0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: isSelected
                ? Icon(
                    Icons.check, // Material icon for checkmark
                    color: getContrastTextColor(colorHex), // Ensures contrast for the checkmark
                    size: 20,
                  )
                : null, // No checkmark if not selected
          ),
        );
      }).toList(),
    );
  }
}