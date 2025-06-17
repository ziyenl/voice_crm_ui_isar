// widgets/TagRow.dart

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/layout.dart';
import '../types/types.dart'; // Import your Tag type
import '../utils/color_utils.dart'; // You'll need a utility to convert hex string to Color

/// A widget to display a row of tags with customizable size.
class TagRow extends StatelessWidget {
  final List<Tag> tags; // Change from tagIds to full Tag objects
  final bool small;

  const TagRow({
    Key? key,
    required this.tags, // Updated parameter name
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink(); // Don't render anything if no tags
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Layout.spacing.xs),
      child: Wrap(
        spacing: Layout.spacing.xs, // Horizontal spacing between tags
        runSpacing: Layout.spacing.xs * 0.5, // Vertical spacing between rows of tags
         children: tags.map((tag) {
          // Convert the hex color string from the Tag object to a Flutter Color
          final Color badgeColor = hexToColor(tag.color);
          // Determine an appropriate contrast text color for the badge color
          final Color textColor = getContrastTextColor(tag.color);
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: small ? Layout.spacing.sm : Layout.spacing.md,
              vertical: small ? 2.0 : Layout.spacing.xs,
            ),
            decoration: BoxDecoration(
             // Use the tag's specific color here!
              color: badgeColor, // Dynamic color based on the tag
              borderRadius: Layout.borderRadius.full,
            ),
            child: Text(
               tag.name, // Use the label from the Tag object
              style: TextStyle(
                fontFamily: 'Inter-Regular',
                fontSize: small ? 10 : 12,
                 color: textColor, // Dynamic text color for contrast
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}