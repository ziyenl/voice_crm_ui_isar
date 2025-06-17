// lib/widgets/tag_form.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/types/types.dart';
import 'package:voice_crm_ui_upgrade/constants/layout.dart';
import 'package:voice_crm_ui_upgrade/constants/colors.dart';
import 'package:voice_crm_ui_upgrade/widgets/color_picker.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:isar/isar.dart'; // Import Isar to use Id type

/// A form widget for creating or editing a [Tag].
class TagForm extends StatefulWidget {
  final ValueChanged<Tag> onSave; // Callback when the tag is saved
  final VoidCallback onCancel; // Callback when the form is cancelled
  final Tag? initialTag; // Optional initial tag for editing mode

  const TagForm({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.initialTag,
  });

  @override
  State<TagForm> createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
  late TextEditingController _nameController;
  late String _selectedColor; // Stores hex string
  late String _selectedType; // 'client' or 'content'

  // Default colors as hex strings
  final List<String> _defaultColors = const [
    '#5B9DF9', // Primary blue
    '#A18CD1', // Accent purple
    '#F97316', // Orange
    '#10B981', // Green
    '#EF4444', // Red
    '#F59E0B', // Yellow
    '#6366F1', // Indigo
    '#EC4899', // Pink
    '#0EA5E9', // Sky blue
    '#14B8A6', // Teal
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTag?.name ?? '');
    _selectedColor = widget.initialTag?.color ?? _defaultColors[0];
    _selectedType = widget.initialTag?.type ?? 'content'; // Default to 'content'
  }

  @override
  void dispose() {
    _nameController.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  /// Handles the save action, validating the tag name before calling the `onSave` callback.
  void _handleSave() {
    HapticFeedback.lightImpact(); // Provide haptic feedback
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      // Consider showing a SnackBar or an input error message here
      print('Tag name cannot be empty!');
      return;
    }

    // Generate a temporary ID if creating a new tag, otherwise use the existing one.
    // In a real app, the ID would usually be assigned by the backend or a database.
    // The ID for Tag should now be an int.
    // If widget.initialTag?.id is null (new tag), generate a unique int ID.
    // We cast widget.initialTag?.id to int if it's not null, as its type is Object, but we know it's Id (int).

    // OMITTED AFTER ISAR
    // final int id = widget.initialTag?.id as int? ?? DateTime.now().millisecondsSinceEpoch;
    
    // final Tag newOrUpdatedTag = Tag(
    //   id: id, // Now 'id' is an int, matching Tag's constructor
    //   name: name,
    //   color: _selectedColor,
    //   type: _selectedType,
    // );
    // widget.onSave(newOrUpdatedTag);
     Tag newOrUpdatedTag;

    if (widget.initialTag != null) {
      // Editing an existing tag
      // Create a copy or modify the existing tag object with new values.
      // The ID remains the same as the original tag.
      // --- If editing an existing tag, use copyWith to update its properties ---
      newOrUpdatedTag = widget.initialTag!.copyWith( // Assuming you have a copyWith method
        name: name,
        color: _selectedColor,
        type: _selectedType,
      );
       // The `id` is automatically preserved by the copyWith method you defined in Tag.

      // If you don't have copyWith, you'd create a new Tag and assign the old ID:
      // newOrUpdatedTag = Tag(
      //   name: name,
      //   color: _selectedColor,
      //   type: _selectedType,
      // );
      // newOrUpdatedTag.id = widget.initialTag!.id; // Assign the existing ID
    } else {
      // Creating a new tag
      // Isar will assign an ID automatically when this tag is put into the database.
      // --- If creating a new tag, use the Tag.create constructor ---
      // Do NOT pass an 'id' here. Isar will auto-increment it when it's saved to the database.
      newOrUpdatedTag = Tag.create(
        name: name,
        color: _selectedColor,
        type: _selectedType,
      );
      // Do NOT set an ID here; let Isar handle Isar.autoIncrement
    }

    widget.onSave(newOrUpdatedTag);
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the save button should be enabled
    final bool isSaveButtonEnabled = _nameController.text.trim().isNotEmpty;

    return SingleChildScrollView( // Use SingleChildScrollView to prevent overflow when keyboard is open
      padding: const EdgeInsets.all(Layout.spacingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Occupy minimum vertical space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This title is for the modal itself, not the form.
          // It's rendered in TaggingScreen's _openTagForm now.
          // Text(
          //   widget.initialTag != null ? 'Edit Tag' : 'Create New Tag',
          //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
          //     fontFamily: 'Inter-SemiBold',
          //     color: AppColors.neutral800,
          //   ),
          // ),
          // Divider(height: Layout.spacingMd + 8, thickness: 1, color: AppColors.neutral200),

          // Tag Name Input
          Text('Tag Name', style: TextStyle(
            fontFamily: 'Inter-Medium',
            fontSize: 16,
            color: AppColors.neutral700,
          )),
          const SizedBox(height: Layout.spacingSm),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter tag name',
              hintStyle: TextStyle(color: AppColors.neutral400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
                borderSide: BorderSide(color: AppColors.neutral300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
                borderSide: BorderSide(color: AppColors.neutral300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
                borderSide: BorderSide(color: AppColors.primary500, width: 2),
              ),
              contentPadding: const EdgeInsets.all(Layout.spacingMd),
            ),
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter-Regular',
              color: AppColors.neutral800,
            ),
            onChanged: (text) {
              setState(() {
                // Rebuilds the widget to update the `isSaveButtonEnabled` status
              });
            },
            autofocus: true,
          ),
          const SizedBox(height: Layout.spacingLg),

          // Tag Color Picker
          Text('Tag Color', style: TextStyle(
            fontFamily: 'Inter-Medium',
            fontSize: 16,
            color: AppColors.neutral700,
          )),
          ColorPicker(
            colors: _defaultColors,
            selectedColor: _selectedColor,
            onSelectColor: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
          ),
          const SizedBox(height: Layout.spacingLg),

          // Tag Type Switch
          Text('Tag Type', style: TextStyle(
            fontFamily: 'Inter-Medium',
            fontSize: 16,
            color: AppColors.neutral700,
          )),
          const SizedBox(height: Layout.spacingSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Content',
                style: TextStyle(
                  fontFamily: _selectedType == 'content' ? 'Inter-Medium' : 'Inter-Regular',
                  fontSize: 16,
                  color: _selectedType == 'content' ? AppColors.neutral800 : AppColors.neutral600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Layout.spacingMd),
                child: Switch(
                  value: _selectedType == 'client',
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value ? 'client' : 'content';
                    });
                  },
                  activeColor: AppColors.accent400,
                  inactiveTrackColor: AppColors.primary300,
                  thumbColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              Text(
                'Client',
                style: TextStyle(
                  fontFamily: _selectedType == 'client' ? 'Inter-Medium' : 'Inter-Regular',
                  fontSize: 16,
                  color: _selectedType == 'client' ? AppColors.neutral800 : AppColors.neutral600,
                ),
              ),
            ],
          ),
          const SizedBox(height: Layout.spacingLg),

          // Action Buttons (Cancel & Save)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neutral100,
                    padding: const EdgeInsets.all(Layout.spacingMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 16,
                      color: AppColors.neutral700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Layout.spacingSm),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().isEmpty ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _nameController.text.trim().isEmpty
                        ? AppColors.neutral300
                        : AppColors.primary500,
                    padding: const EdgeInsets.all(Layout.spacingMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    widget.initialTag != null ? 'Update Tag' : 'Create Tag',
                    style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}