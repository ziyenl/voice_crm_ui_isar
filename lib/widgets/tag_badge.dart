// lib/widgets/tag_badge.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/constants/layout.dart';
import 'package:voice_crm_ui_upgrade/utils/color_utils.dart'; 
import 'package:voice_crm_ui_upgrade/constants/app_shadows.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

class TagBadge extends StatelessWidget {
  final String label;
  final String color; 
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
                FontAwesomeIcons.xmark,
                size: small ? 12 : 16,
                color: textColor,
              ),
            ),
          ),
      ],
    );

    if (isClickable) {
      final double beginScaleFactor = isSelected ? 1.0 : 1.05;
      final double endScaleFactor = isSelected ? 1.05 : 1.0;

      tagContent = Animate(
        effects: [
          ScaleEffect(
            duration: 150.ms,
            curve: Curves.easeOut,
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
        target: isSelected ? 1.0 : 0.0, 
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
          boxShadow: isClickable && !isSelected
              ? [AppShadows.sm]
              : [],
        ),
        child: tagContent,
      ),
    );
  }
}
