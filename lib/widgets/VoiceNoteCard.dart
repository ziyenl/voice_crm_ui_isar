// widgets/VoiceNoteCard.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:isar/isar.dart'; // <--- Add this import for Id type (which is an alias for int) is recognized.
import '../types/types.dart';
import '../constants/layout.dart';
import '../constants/colors.dart';
import 'tag_row.dart'; // Assuming TagRow is in the same directory
import './VoiceNoteMenu.dart'; // Assuming VoiceNoteMenu is in the same directory
import 'package:intl/intl.dart'; // Required for date formatting

/// A card widget to display a single voice note, with expand/collapse and menu options.
class VoiceNoteCard extends StatefulWidget {
  final VoiceNote voiceNote;
  // --- CHANGE 1: Change parameter type from String to int ---
  final Function(VoiceNoteAction action, int noteId) onAction;

  const VoiceNoteCard({
    Key? key,
    required this.voiceNote,
    required this.onAction,
  }) : super(key: key);

  @override
  State<VoiceNoteCard> createState() => _VoiceNoteCardState();
}

class _VoiceNoteCardState extends State<VoiceNoteCard> with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController for card scale and shadow effects
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // Duration for card scale animation
      reverseDuration: const Duration(milliseconds: 250), // Duration for reverse animation
    );

    // Define the scale animation from 1.0 to 1.02
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Mimic a spring-like ease-out curve
      ),
    );

    // Define the shadow opacity animation
    _shadowOpacityAnimation = Tween<double>(begin: 0.08, end: 0.15).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  /// Formats the duration from seconds into "MM:SS" format.
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Formats a DateTime object into a localized date string (e.g., "Jun 6, 2025").
  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date); // Uses intl package for formatting
  }

  /// Handles the tap event on the voice note card, expanding or collapsing it.
  void _handleCardPress() {
    if (widget.voiceNote.isTranscribed) {
      HapticFeedback.lightImpact(); // Provide haptic feedback on tap
      setState(() {
        _expanded = !_expanded;
      });
      // Control the animation based on the expanded state
      if (_expanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  /// Toggles the visibility of the VoiceNoteMenu modal.
  void _handleMenuToggle() {
    HapticFeedback.lightImpact(); // Provide haptic feedback
    showDialog(
      context: context,
      barrierColor: Colors.black54, // Overlay background color for the modal
      builder: (BuildContext context) {
        return VoiceNoteMenu(
          onClose: () => Navigator.of(context).pop(), // Closes the dialog
          onAction: (action) {
            Navigator.of(context).pop(); // Close dialog first
            widget.onAction(action, widget.voiceNote.id); // Then perform the action
          },
          voiceNote: widget.voiceNote,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController, // Rebuilds when animation values change
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(
            bottom: Layout.spacing.sm,
            left: Layout.spacing.md,
            right: Layout.spacing.md,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Layout.borderRadius.md,
            boxShadow: [
              // Apply dynamic shadow based on animation value
              BoxShadow(
                color: Colors.black.withOpacity(_shadowOpacityAnimation.value),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value, // Apply dynamic scale based on animation value
            child: Material(
              color: Colors.transparent, // Required for InkWell's splash effect
              borderRadius: Layout.borderRadius.md,
              child: InkWell(
                borderRadius: Layout.borderRadius.md,
                onTap: _handleCardPress, // Handle card tap for expansion
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Header: Tags and Menu button
                    Padding(
                      padding: EdgeInsets.only(
                        left: Layout.spacing.md,
                        right: Layout.spacing.md,
                        top: Layout.spacing.sm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- CHANGE 3: Convert IsarLinks<Tag> to List<Tag> using .toList() ---
                                TagRow(tags: widget.voiceNote.clientTags.toList(), small: true),
                                TagRow(tags: widget.voiceNote.contentTags.toList(), small: true),
                              ],
                            ),
                          ),
                          // Menu button
                          GestureDetector(
                            onTap: _handleMenuToggle,
                            child: Padding(
                              padding: EdgeInsets.all(Layout.spacing.xs),
                              child: Icon(
                                Icons.more_vert, // Material Icon equivalent to MoreVertical
                                size: 20,
                                color: AppColors.neutral700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Card Body: Title, Metadata, Status Badges
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Layout.spacing.md,
                      ).copyWith(bottom: Layout.spacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Favorite Star
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.voiceNote.title,
                                  style: TextStyle(
                                    fontFamily: 'Inter-Medium',
                                    fontSize: 18,
                                    color: AppColors.neutral800,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Truncate long titles
                                ),
                              ),
                              if (widget.voiceNote.isFavorite)
                                Padding(
                                  padding: EdgeInsets.only(left: Layout.spacing.xs),
                                  child: Icon(
                                    Icons.star, // Material Icon equivalent to Star
                                    size: 16,
                                    color: AppColors.warning500,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: Layout.spacing.xs),
                          // Metadata (Duration, File Path, Date)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time, // Material Icon equivalent to Clock
                                    size: 14,
                                    color: AppColors.neutral500,
                                  ),
                                  SizedBox(width: Layout.spacing.xs),
                                  Text(
                                    _formatDuration(widget.voiceNote.duration),
                                    style: TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 14,
                                      color: AppColors.neutral600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Layout.spacing.xs),
                              Row(
                                children: [
                                  Icon(
                                    Icons.description, // Material Icon equivalent to File
                                    size: 14,
                                    color: AppColors.neutral500,
                                  ),
                                  SizedBox(width: Layout.spacing.xs),
                                  Expanded(
                                    child: Text(
                                      widget.voiceNote.filePath,
                                      style: TextStyle(
                                        fontFamily: 'Inter-Regular',
                                        fontSize: 14,
                                        color: AppColors.neutral600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis, // Truncate long file paths
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Layout.spacing.xs),
                              Text(
                                _formatDate(widget.voiceNote.dateRecorded),
                                style: TextStyle(
                                  fontFamily: 'Inter-Regular',
                                  fontSize: 14,
                                  color: AppColors.neutral500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Layout.spacing.xs),
                          // Status Badges (Transcribed, Uploaded)
                          Wrap(
                            spacing: Layout.spacing.xs,
                            runSpacing: Layout.spacing.xs,
                            children: [
                              if (widget.voiceNote.isTranscribed)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral100,
                                    borderRadius: Layout.borderRadius.full,
                                  ),
                                  child: Text(
                                    'Transcribed',
                                    style: TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 12,
                                      color: AppColors.neutral700,
                                    ),
                                  ),
                                ),
                              if (widget.voiceNote.isUploaded)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary50,
                                    borderRadius: Layout.borderRadius.full,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Keep row tight to its children
                                    children: [
                                      Icon(
                                        Icons.cloud_upload, // Material Icon equivalent to Upload
                                        size: 12,
                                        color: AppColors.primary700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Uploaded',
                                        style: TextStyle(
                                          fontFamily: 'Inter-Regular',
                                          fontSize: 12,
                                          color: AppColors.primary700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Transcription Section (Animated)
                    if (widget.voiceNote.isTranscribed)
                      // AnimatedSize animates the height change
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: SizeTransition(
                          sizeFactor: CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutCubic,
                          ),
                          axisAlignment: -1.0, // Ensures content expands downwards
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeOutCubic,
                            ),
                            child: Visibility(
                              // Only build the transcription content if expanded
                              visible: _expanded,
                              maintainState: true, // Keep state even when invisible
                              child: Container(
                                padding: EdgeInsets.all(Layout.spacing.md),
                                decoration: BoxDecoration(
                                  color: AppColors.neutral50,
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.neutral200,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Transcription',
                                      style: TextStyle(
                                        fontFamily: 'Inter-Medium',
                                        fontSize: 16,
                                        color: AppColors.neutral800,
                                      ),
                                    ),
                                    SizedBox(height: Layout.spacing.sm),
                                    Text(
                                      widget.voiceNote.transcription ?? 'No transcription available.',
                                      style: TextStyle(
                                        fontFamily: 'Inter-Regular',
                                        fontSize: 15,
                                        height: 1.4, // Mimics lineHeight: 22 / 15
                                        color: AppColors.neutral700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}