// widgets/VoiceNoteCard.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:isar/isar.dart'; 
import '../types/types.dart';
import '../constants/layout.dart';
import '../constants/colors.dart';
import 'tag_row.dart'; 
import './VoiceNoteMenu.dart'; 
import 'package:intl/intl.dart'; 

class VoiceNoteCard extends StatefulWidget {
  final VoiceNote voiceNote;
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), 
      reverseDuration: const Duration(milliseconds: 250), 
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, 
      ),
    );
    
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

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date); 
  }

  void _handleCardPress() {
    if (widget.voiceNote.isTranscribed) {
      HapticFeedback.lightImpact(); 
      setState(() {
        _expanded = !_expanded;
      });
    
      if (_expanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handleMenuToggle() {
    HapticFeedback.lightImpact(); 
    showDialog(
      context: context,
      barrierColor: Colors.black54, 
      builder: (BuildContext context) {
        return VoiceNoteMenu(
          onClose: () => Navigator.of(context).pop(), 
          onAction: (action) {
            Navigator.of(context).pop(); 
            widget.onAction(action, widget.voiceNote.id); 
          },
          voiceNote: widget.voiceNote,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController, 
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
              BoxShadow(
                color: Colors.black.withOpacity(_shadowOpacityAnimation.value),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value, 
            child: Material(
              color: Colors.transparent,
              borderRadius: Layout.borderRadius.md,
              child: InkWell(
                borderRadius: Layout.borderRadius.md,
                onTap: _handleCardPress, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                TagRow(tags: widget.voiceNote.clientTags.toList(), small: true),
                                TagRow(tags: widget.voiceNote.contentTags.toList(), small: true),
                              ],
                            ),
                          ),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Layout.spacing.md,
                      ).copyWith(bottom: Layout.spacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    Icons.star, 
                                    size: 16,
                                    color: AppColors.warning500,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: Layout.spacing.xs),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time, 
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
                                    Icons.description, 
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
                                      overflow: TextOverflow.ellipsis, 
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
                                    mainAxisSize: MainAxisSize.min, 
                                    children: [
                                      Icon(
                                        Icons.cloud_upload, 
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
                    if (widget.voiceNote.isTranscribed)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: SizeTransition(
                          sizeFactor: CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutCubic,
                          ),
                          axisAlignment: -1.0, 
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeOutCubic,
                            ),
                            child: Visibility(
                              visible: _expanded,
                              maintainState: true, 
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
                                        height: 1.4, 
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
