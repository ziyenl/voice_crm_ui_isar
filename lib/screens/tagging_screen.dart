// lib/screens/tagging_screen.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/types/types.dart';
import 'package:voice_crm_ui_upgrade/widgets/logo.dart'; // Import your Logo widget
import 'package:voice_crm_ui_upgrade/widgets/tag_badge.dart';
import 'package:voice_crm_ui_upgrade/widgets/tag_form.dart';
import 'package:voice_crm_ui_upgrade/constants/layout.dart';
import 'package:voice_crm_ui_upgrade/constants/colors.dart';
import 'package:voice_crm_ui_upgrade/data/mock_data.dart'; // Make sure this is updated for Tag type
import 'package:voice_crm_ui_upgrade/constants/app_shadows.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For Plus icon
import 'package:isar/isar.dart'; // <--- Add this import for Id type

class TaggingScreen extends StatefulWidget {
  const TaggingScreen({super.key});

  @override
  State<TaggingScreen> createState() => _TaggingScreenState();
}

class _TaggingScreenState extends State<TaggingScreen> {
  // Use a mutable list for state management
  List<Tag> _allTags = [];
  Tag? _editingTag; // Tag currently being edited, if any

  @override
  void initState() {
    super.initState();
    // Initialize tags with a copy of mock data
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
      _editingTag = null; // Clear any existing editing state
    });
    _openTagForm();
  }

  void _handleEditTag(Tag tag) {
    setState(() {
      _editingTag = tag;
    });
    _openTagForm();
  }

  // --- CHANGE THIS LINE ---
  // Change the type of tagId from String to int (Id)
  // Changed tagId type to int (Isar.Id is a typedef for int)
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
  //     _allTags.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); // Keep sorted
  //   });
  //   Navigator.of(context).pop(); // Close the bottom sheet
  // }

  void _handleSaveTag(Tag tag) {
    // 'tag' now contains the correct ID (or null for new)
    setState(() {
      // Here, 'tag.id' will be the existing ID if it was an edit,
      // or a default/0 if it was a new tag (before Isar assigns one).
      // Since we are not directly interacting with Isar here,
      // we assume the ID is meaningful for our mock data list.
      
      // Find the tag by its ID. Since Isar.autoIncrement defaults to 0 for new objects,
      // and Isar assigns real IDs on `put()`, we need to handle this divergence
      // for our *mock data list*.
      final int existingIndex = _allTags.indexWhere((t) => t.id == tag.id);
      if (existingIndex != -1) {
        // Update existing tag
        _allTags[existingIndex] = tag;
        _showSnackBar('Tag "${tag.name}" updated!');
      } else {
        // Creating new tag - For mock data, you might need to assign a temporary ID here
        // if your Tag class doesn't auto-generate for mock.
        // For real Isar, you wouldn't need to assign it here as Isar.put() handles it.
        // For now, let's ensure the mock data setup provides unique IDs for new tags.
        // If Tag.id is `Isar.autoIncrement`, the mock data handling of IDs becomes crucial.
        // If you are transitioning to Isar, mock data handling of IDs might diverge.

        // For the current mock data setup (not Isar), where you are manually
        // adding to a list, you might need to give it a temporary ID if it's new.
        // This creates a slight discrepancy between mock and real Isar behavior
        // for ID assignment.

        // Creating new tag for the mock list.
        // We need to assign a temporary unique ID for the mock list,
        // because Tag.create() doesn't set it and Isar won't auto-increment
        // until you actually save it to an Isar database.
        final int newMockId = DateTime.now().millisecondsSinceEpoch;

        // Create a new Tag instance with the mock ID.
        // We can't directly assign to `tag.id` because it's `final Id` for Isar's `Id id = Isar.autoIncrement;`
        // or a `late` field initialized by the constructor or `Tag()`.

        
        // Tag tagToAdd = tag;
        // if (tag.id == Isar.autoIncrement || tag.id == 0) {
        //   // Assuming 0 or Isar.autoIncrement means new
        //   tagToAdd = Tag(
        //     // Create a new instance with a temporary mock ID
        //     id: DateTime.now().millisecondsSinceEpoch, // A simple mock ID
        //     name: tag.name,
        //     color: tag.color,
        //     type: tag.type,
        //   );
        // }

        // So we create a new Tag object for our mock list.
        final Tag tagWithMockId = Tag.create(
          name: tag.name,
          color: tag.color,
          type: tag.type,
        )..id = newMockId; // Manually assign the mock ID to the field

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
          true, // Allows the sheet to take full height if needed by keyboard
      backgroundColor:
          Colors
              .transparent, // Make background transparent for modal-like effect
      builder: (context) {
        return GestureDetector(
          // Allow tapping outside to dismiss (similar to RN modal)
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            // --- MODIFIED CODE HERE ---
            // Removed 'color' property and moved it inside a BoxDecoration
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(
                0.5,
              ), // <--- Color now inside BoxDecoration
            ), // Modal overlay effect
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {}, // Prevent tapping content from closing modal
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9, // 90% width
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                  boxShadow: [
                    AppShadows.lg, // Use the defined large shadow
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content height
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
                              ).pop(), // Cancel closes modal
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
                spacing: Layout.spacingXs, // Horizontal spacing
                runSpacing: Layout.spacingXs, // Vertical spacing
                children:
                    tagList.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Tag tag = entry.value;
                      return Animate(
                        effects: [
                          FadeEffect(
                            delay: (index * 50).ms, // Staggered animation
                            duration: 300.ms,
                            curve: Curves.easeOutCubic,
                          ),
                          SlideEffect(
                            begin: const Offset(0, 0.5), // Slide up slightly
                            end: Offset.zero,
                            delay: (index * 50).ms,
                            duration: 300.ms,
                            curve: Curves.easeOutCubic,
                          ),
                        ],
                        child: TagBadge(
                          key: ValueKey(
                            tag.id,
                          ), // Important for list efficiency
                          label: tag.name,
                          color: tag.color,
                          onRemove: () => _handleDeleteTag(tag.id),
                          onPress: () => _handleEditTag(tag),
                          small: false, // Default size for these badges
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
      backgroundColor: AppColors.neutral50, // Match RN background
      body: SafeArea(
        // Equivalent to React Native SafeAreaView
        child: Column(
          children: [
            // Header (similar to RN's header View)
            Container(
              padding: const EdgeInsets.all(Layout.spacingMd),
              // color: AppColors.white, // Use AppColors.white
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.neutral200, width: 1),
                ),
              ),
              child: const Logo(size: LogoSize.large), // Your Logo widget
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Layout.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Add Button
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
                    // Description
                    Text(
                      'Create and manage tags to organize your voice notes. Tags can be applied to notes for easier filtering and searching.',
                      style: TextStyle(
                        fontFamily: 'Inter-Regular',
                        fontSize: 16,
                        color: AppColors.neutral600,
                        height: 1.4, // lineHeight equivalent
                      ),
                    ),
                    const SizedBox(height: Layout.spacingLg),

                    // Tag sections
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
