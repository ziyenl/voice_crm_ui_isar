// lib/widgets/tag_form.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/types/types.dart';
import 'package:voice_crm_ui_upgrade/constants/layout.dart';
import 'package:voice_crm_ui_upgrade/constants/colors.dart';
import 'package:voice_crm_ui_upgrade/widgets/color_picker.dart';
import 'package:flutter/services.dart'; 
import 'package:isar/isar.dart'; 

/// A form widget for creating or editing a [Tag].
class TagForm extends StatefulWidget {
  final ValueChanged<Tag> onSave; 
  final VoidCallback onCancel;
  final Tag? initialTag; 

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
  late String _selectedColor; 
  late String _selectedType; 
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
    _selectedType = widget.initialTag?.type ?? 'content'; 
  }

  @override
  void dispose() {
    _nameController.dispose(); 
    super.dispose();
  }

  /// Handles the save action, validating the tag name before calling the `onSave` callback.
  void _handleSave() {
    HapticFeedback.lightImpact(); 
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      // Consider showing a SnackBar or an input error message here
      print('Tag name cannot be empty!');
      return;
    }
     Tag newOrUpdatedTag;

    if (widget.initialTag != null) {
      newOrUpdatedTag = widget.initialTag!.copyWith( 
        name: name,
        color: _selectedColor,
        type: _selectedType,
      );
    } else {
      newOrUpdatedTag = Tag.create(
        name: name,
        color: _selectedColor,
        type: _selectedType,
      );
    }

    widget.onSave(newOrUpdatedTag);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSaveButtonEnabled = _nameController.text.trim().isNotEmpty;

    return SingleChildScrollView( 
      padding: const EdgeInsets.all(Layout.spacingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              });
            },
            autofocus: true,
          ),
          const SizedBox(height: Layout.spacingLg),

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
