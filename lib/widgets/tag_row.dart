// widgets/TagRow.dart

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/layout.dart';
import '../types/types.dart'; 
import '../utils/color_utils.dart'; 


class TagRow extends StatelessWidget {
  final List<Tag> tags; 
  final bool small;

  const TagRow({
    Key? key,
    required this.tags, 
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink(); 
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Layout.spacing.xs),
      child: Wrap(
        spacing: Layout.spacing.xs, 
        runSpacing: Layout.spacing.xs * 0.5, 
         children: tags.map((tag) {
          final Color badgeColor = hexToColor(tag.color);
          final Color textColor = getContrastTextColor(tag.color);
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: small ? Layout.spacing.sm : Layout.spacing.md,
              vertical: small ? 2.0 : Layout.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: badgeColor, 
              borderRadius: Layout.borderRadius.full,
            ),
            child: Text(
               tag.name, 
              style: TextStyle(
                fontFamily: 'Inter-Regular',
                fontSize: small ? 10 : 12,
                 color: textColor, 
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
