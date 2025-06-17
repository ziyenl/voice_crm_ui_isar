// lib/widgets/tab_bar_icon.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/constants/colors.dart'; // Make sure this path is correct

/// A custom widget for a tab bar icon with animation and label.
class TabBarIcon extends StatefulWidget {
  final IconData icon; // Use IconData for Material Icons
  final bool focused;
  final String label;

  const TabBarIcon({
    Key? key,
    required this.icon,
    required this.focused,
    required this.label,
  }) : super(key: key);

  @override
  State<TabBarIcon> createState() => _TabBarIconState();
}

class _TabBarIconState extends State<TabBarIcon> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController with a duration matching React Native's withTiming
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Define opacity animation: 0.6 when unfocused, 1.0 when focused
    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(_animationController);

    // Define scale animation: 1.0 when unfocused, 1.05 when focused
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_animationController);

    // Immediately set the correct animation state based on initial 'focused' prop
    _updateAnimationState();
  }

  @override
  void didUpdateWidget(covariant TabBarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate when the 'focused' state changes
    if (widget.focused != oldWidget.focused) {
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    if (widget.focused) {
      _animationController.forward(); // Animate to focused state
    } else {
      _animationController.reverse(); // Animate to unfocused state
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Make column content-sized
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Use AnimatedBuilder to rebuild the icon based on animation values
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  widget.icon,
                  size: 24,
                  // Color changes based on focused state
                  color: widget.focused ? AppColors.tabBarActive : AppColors.tabBarInactive,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4), // Equivalent to marginBottom: 4
        // Tab label text
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            // Apply different font weights based on focused state
            fontFamily: widget.focused ? 'Inter-Medium' : 'Inter-Regular',
            color: widget.focused ? AppColors.tabBarActive : AppColors.tabBarInactive,
          ),
        ),
      ],
    );
  }
}