// widgets/VoiceNoteMenu.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import '../types/types.dart';
import '../constants/layout.dart';
import '../constants/colors.dart';

/// A modal menu widget for performing actions on a voice note.
class VoiceNoteMenu extends StatelessWidget {
  final VoidCallback onClose;
  final Function(VoiceNoteAction action) onAction;
  final VoiceNote voiceNote;

  const VoiceNoteMenu({
    Key? key,
    required this.onClose,
    required this.onAction,
    required this.voiceNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the list of menu actions with their properties
    final List<Map<String, dynamic>> menuActions = [
      {
        'icon': Icons.description, // Equivalent to FileText
        'label': 'Transcribe',
        'action': VoiceNoteAction.transcribe,
        'color': AppColors.primary700,
        'disabled': voiceNote.isTranscribed,
      },
      {
        'icon': Icons.cloud_upload, // Equivalent to Upload
        'label': 'Send to Cloud',
        'action': VoiceNoteAction.upload,
        'color': AppColors.accent400,
        'disabled': voiceNote.isUploaded,
      },
      {
        'icon': Icons.tag, // Equivalent to Tag
        'label': 'Add Tags',
        'action': VoiceNoteAction.tag,
        'color': AppColors.warning500,
        'disabled': false,
      },
      {
        'icon': Icons.star, // Equivalent to Star
        'label': voiceNote.isFavorite ? 'Remove Favorite' : 'Add Favorite',
        'action': voiceNote.isFavorite ? VoiceNoteAction.unfavorite : VoiceNoteAction.favorite,
        'color': AppColors.warning500,
        'fill': voiceNote.isFavorite, // Used to determine if the star icon should be filled
      },
      {
        'icon': Icons.delete_forever, // Equivalent to Trash2
        'label': 'Delete',
        'action': VoiceNoteAction.delete,
        'color': AppColors.error500,
        'danger': true, // Indicates a destructive action
      },
    ];

    return Dialog(
      backgroundColor: Colors.transparent, // Make the dialog background transparent
      elevation: 0, // Remove default dialog elevation
      insetPadding: EdgeInsets.symmetric(horizontal: Layout.spacing.lg), // Padding from screen edges
      child: Material(
        color: Colors.white,
        borderRadius: Layout.borderRadius.md,
        elevation: 8, // Mimic the shadow.lg from Layout.js
        shadowColor: Colors.black.withOpacity(0.12), // Shadow color
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content tightly
          children: menuActions.map((item) {
            final bool isDisabled = item['disabled'] as bool? ?? false;
            final bool isDanger = item['danger'] as bool? ?? false;
            final bool hasFill = item['fill'] as bool? ?? false;

            // Determine icon and text colors based on item state
            final Color iconColor = isDisabled
                ? AppColors.neutral400
                : item['color'] as Color;
            final Color textColor = isDisabled
                ? AppColors.neutral400
                : (isDanger ? AppColors.error500 : AppColors.neutral800);

            return InkWell(
              onTap: isDisabled
                  ? null // Disable tap if item is disabled
                  : () {
                      HapticFeedback.lightImpact(); // Add haptic feedback
                      onAction(item['action'] as VoiceNoteAction);
                    },
              child: Container(
                padding: EdgeInsets.all(Layout.spacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: menuActions.indexOf(item) == menuActions.length - 1
                          ? Colors.transparent // No border for the last item
                          : AppColors.neutral200,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 20,
                      color: iconColor,
                    ),
                    SizedBox(width: Layout.spacing.md),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontFamily: 'Inter-Medium',
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}