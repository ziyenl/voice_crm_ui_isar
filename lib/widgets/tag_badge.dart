// lib/widgets/tag_badge.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/constants/layout.dart';
import 'package:voice_crm_ui_upgrade/utils/color_utils.dart'; // For hexToColor and getContrastTextColor
import 'package:voice_crm_ui_upgrade/constants/app_shadows.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For X icon

/// A customizable badge widget to display a single tag.
class TagBadge extends StatelessWidget {
  final String label;
  final String color; // Hex color string, e.g., '#RRGGBB'
  final VoidCallback? onRemove;
  final bool small;
  final bool isSelected;
  final VoidCallback? onPress;

  const TagBadge({
    super.key,
    required this.label,
    required this.color,
    this.onRemove,
    this.small = false,
    this.isSelected = false,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = hexToColor(color);
    final Color textColor = getContrastTextColor(color);
    final bool isRemovable = onRemove != null;
    final bool isClickable = onPress != null;

    Widget tagContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: small ? 12 : 14,
            fontFamily: 'Inter-Medium',
            color: textColor,
          ),
        ),
        if (isRemovable)
          Padding(
            padding: EdgeInsets.only(left: Layout.spacingXs),
            child: GestureDetector(
              onTap: onRemove,
              child: FaIcon(
                FontAwesomeIcons.xmark, // 'X' icon from Font Awesome
                size: small ? 12 : 16,
                color: textColor,
              ),
            ),
          ),
      ],
    );

    // Apply animations using flutter_animate if it's clickable
    if (isClickable) {
         // --- WORKAROUND FOR 'OFFSET?' ERROR ---
      // This is a workaround if your Flutter environment or specific flutter_animate installation
      // is incorrectly demanding an Offset for ScaleEffect's begin/end parameters.
      // Normally, these parameters expect a double for the scale factor.
      final double beginScaleFactor = isSelected ? 1.0 : 1.05;
      final double endScaleFactor = isSelected ? 1.05 : 1.0;

      tagContent = Animate(
        effects: [
          ScaleEffect(
            duration: 150.ms,
            curve: Curves.easeOut,
            // Using Offset(factor, factor) to satisfy the compiler if it expects Offset.
            // This assumes uniform scaling behavior when an Offset is provided.
            begin: Offset(beginScaleFactor, beginScaleFactor),
            end: Offset(endScaleFactor, endScaleFactor),
          ),
          FadeEffect(
            duration: 150.ms,
            curve: Curves.easeOut,
            begin: isSelected ? 0.8 : 1.0,
            end: isSelected ? 1.0 : 0.8,
          ),
        ],
        target: isSelected ? 1.0 : 0.0, // Control animation based on isSelected
        child: tagContent,
      );
    }

    return GestureDetector(
      onTap: isClickable ? onPress : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? Layout.spacingSm : Layout.spacingMd,
          vertical: small ? 2 : Layout.spacingXs,
        ),
        margin: EdgeInsets.only(right: Layout.spacingXs, bottom: Layout.spacingXs),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(Layout.borderRadiusFull),
          boxShadow: isClickable && !isSelected // Only show shadow if clickable and not currently selected
              ? [AppShadows.sm]
              : [],
        ),
        child: tagContent,
      ),
    );
  }
}