// lib/widgets/logo.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For Mic icon
import 'package:voice_crm_ui_upgrade/constants/colors.dart';

enum LogoSize { small, large }

class Logo extends StatelessWidget {
  final LogoSize size;

  const Logo({super.key, this.size = LogoSize.large});

  @override
  Widget build(BuildContext context) {
    final bool isLarge = size == LogoSize.large;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isLarge ? 44 : 32,
          height: isLarge ? 44 : 32,
          margin: EdgeInsets.only(right: isLarge ? 12 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary500,
          ),
          alignment: Alignment.center,
          child: FaIcon(
            FontAwesomeIcons.microphone,
            size: isLarge ? 24 : 18,
            color: AppColors.white,
          ),
        ),
        Text(
          'My Little Voice Notes',
          style: TextStyle(
            fontFamily: 'Inter-SemiBold',
            color: AppColors.neutral800,
            fontSize: isLarge ? 24 : 18,
          ),
        ),
      ],
    );
  }
}