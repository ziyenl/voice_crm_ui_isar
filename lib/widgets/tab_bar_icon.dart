// lib/widgets/tab_bar_icon.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/constants/colors.dart'; 

class TabBarIcon extends StatefulWidget {
  final IconData icon; 
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(_animationController);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_animationController);

    _updateAnimationState();
  }

  @override
  void didUpdateWidget(covariant TabBarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focused != oldWidget.focused) {
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    if (widget.focused) {
      _animationController.forward(); 
    } else {
      _animationController.reverse(); 
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                  color: widget.focused ? AppColors.tabBarActive : AppColors.tabBarInactive,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4), 
        // Tab label text
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: widget.focused ? 'Inter-Medium' : 'Inter-Regular',
            color: widget.focused ? AppColors.tabBarActive : AppColors.tabBarInactive,
          ),
        ),
      ],
    );
  }
}
