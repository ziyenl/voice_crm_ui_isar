// lib/screens/tagging_screen.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/types/types.dart';
import 'package:voice_crm_ui_upgrade/widgets/logo.dart'; 
import 'package:voice_crm_ui_upgrade/widgets/tag_badge.dart';
import 'package:voice_crm_ui_upgrade/widgets/tag_form.dart';
import 'package:voice_crm_ui_upgrade/constants/layout.dart';
import 'package:voice_crm_ui_upgrade/constants/colors.dart';
import 'package:voice_crm_ui_upgrade/data/mock_data.dart'; 
import 'package:voice_crm_ui_upgrade/constants/app_shadows.dart';
import 'package:flutter_animate/flutter_animate.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 
import 'package:isar/isar.dart'; 

class TaggingScreen extends StatefulWidget {
  const TaggingScreen({super.key});

  @override
  State<TaggingScreen> createState() => _TaggingScreenState();
}

class _TaggingScreenState extends State<TaggingScreen> {
  List<Tag> _allTags = [];
  Tag? _editingTag; 

  @override
  void initState() {
    super.initState();
    _allTags = List.from(mockTags);
    _allTags.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _handleAddTag() {
    setState(() {
      _editingTag = null; 
    });
    _openTagForm();
  }

  void _handleEditTag(Tag tag) {
    setState(() {
      _editingTag = tag;
    });
    _openTagForm();
  }

  void _handleDeleteTag(int tagId) {
    setState(() {
      _allTags.removeWhere((tag) => tag.id == tagId);
      _showSnackBar('Tag deleted!');
    });
  }

  // void _handleSaveTag(Tag tag) {
  //   setState(() {
  //     final int existingIndex = _allTags.indexWhere((t) => t.id == tag.id);
  //     if (existingIndex != -1) {
  //       // Update existing tag
  //       _allTags[existingIndex] = tag;
  //       _showSnackBar('Tag "${tag.name}" updated!');
  //     } else {
  //       // Create new tag
  //       _allTags.add(tag);
  //       _showSnackBar('Tag "${tag.name}" created!');
  //     }
  //     _allTags.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); 
  //   });
  //   Navigator.of(context).pop(); 
  // }

  void _handleSaveTag(Tag tag) {
    setState(() {
      final int existingIndex = _allTags.indexWhere((t) => t.id == tag.id);
      if (existingIndex != -1) {
        _allTags[existingIndex] = tag;
        _showSnackBar('Tag "${tag.name}" updated!');
      } else {
        final int newMockId = DateTime.now().millisecondsSinceEpoch;


        // So we create a new Tag object for our mock list.
        final Tag tagWithMockId = Tag.create(
          name: tag.name,
          color: tag.color,
          type: tag.type,
        )..id = newMockId; 

        _allTags.add(tagWithMockId);
        _showSnackBar('Tag "${tagWithMockId.name}" created!');
      }
      _allTags.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    });
    Navigator.of(context).pop();
  }

  void _openTagForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, 
      backgroundColor:
          Colors
              .transparent, 
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(
                0.5,
              ), 
            ), 
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {}, 
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9, 
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                  boxShadow: [
                    AppShadows.lg, 
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Layout.spacingMd),
                      child: Text(
                        _editingTag != null ? 'Edit Tag' : 'Create New Tag',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'Inter-SemiBold',
                          color: AppColors.neutral800,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.neutral200,
                    ),
                    TagForm(
                      onSave: _handleSaveTag,
                      onCancel:
                          () =>
                              Navigator.of(
                                context,
                              ).pop(), 
                      initialTag: _editingTag,
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

  Widget _buildTagSection(String title, List<Tag> tagList) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Layout.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: 18,
              color: AppColors.neutral700,
            ),
          ),
          const SizedBox(height: Layout.spacingMd),
          tagList.isEmpty
              ? Text(
                'No tags found',
                style: TextStyle(
                  fontFamily: 'Inter-Regular',
                  fontSize: 16,
                  color: AppColors.neutral500,
                ),
              )
              : Wrap(
                spacing: Layout.spacingXs, 
                runSpacing: Layout.spacingXs, 
                children:
                    tagList.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Tag tag = entry.value;
                      return Animate(
                        effects: [
                          FadeEffect(
                            delay: (index * 50).ms, 
                            duration: 300.ms,
                            curve: Curves.easeOutCubic,
                          ),
                          SlideEffect(
                            begin: const Offset(0, 0.5), 
                            end: Offset.zero,
                            delay: (index * 50).ms,
                            duration: 300.ms,
                            curve: Curves.easeOutCubic,
                          ),
                        ],
                        child: TagBadge(
                          key: ValueKey(
                            tag.id,
                          ), 
                          label: tag.name,
                          color: tag.color,
                          onRemove: () => _handleDeleteTag(tag.id),
                          onPress: () => _handleEditTag(tag),
                          small: false, 
                        ),
                      );
                    }).toList(),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter tags based on type
    final List<Tag> clientTags =
        _allTags.where((tag) => tag.type == 'client').toList();
    final List<Tag> contentTags =
        _allTags.where((tag) => tag.type == 'content').toList();

    return Scaffold(
      backgroundColor: AppColors.neutral50, 
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(Layout.spacingMd),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.neutral200, width: 1),
                ),
              ),
              child: const Logo(size: LogoSize.large), 
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Layout.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Manage Tags',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontFamily: 'Inter-SemiBold',
                            color: AppColors.neutral800,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _handleAddTag,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            padding: EdgeInsets.symmetric(
                              vertical: Layout.spacingSm,
                              horizontal: Layout.spacingMd,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Layout.borderRadiusMd,
                              ),
                            ),
                            elevation: 0,
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.plus,
                            size: 20,
                            color: AppColors.white,
                          ),
                          label: Text(
                            'New Tag',
                            style: TextStyle(
                              fontFamily: 'Inter-Medium',
                              fontSize: 15,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Layout.spacingSm),
                    Text(
                      'Create and manage tags to organize your voice notes. Tags can be applied to notes for easier filtering and searching.',
                      style: TextStyle(
                        fontFamily: 'Inter-Regular',
                        fontSize: 16,
                        color: AppColors.neutral600,
                        height: 1.4, 
                      ),
                    ),
                    const SizedBox(height: Layout.spacingLg),

                    _buildTagSection('Client Tags', clientTags),
                    _buildTagSection('Content Tags', contentTags),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
