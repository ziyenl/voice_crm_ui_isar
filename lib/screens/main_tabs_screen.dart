// lib/screens/main_tabs_screen.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/screens/tagging_screen.dart';
import 'package:voice_crm_ui_upgrade/widgets/tab_bar_icon.dart'; // Your custom TabBarIcon
import 'package:voice_crm_ui_upgrade/constants/colors.dart'; // For custom colors
import 'package:voice_crm_ui_upgrade/screens/voice_notes_screen.dart'; // Your Voice Inbox screen
// Import your other screen files here
// import 'package:voice_crm_ui_upgrade/screens/tagging_screen.dart';
// import 'package:voice_crm_ui_upgrade/screens/settings_screen.dart';
import 'dart:io' show Platform; // For platform-specific height adjustments

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _currentIndex = 0; // Tracks the currently selected tab index

  // List of screens to display for each tab.
  // Each screen will be a separate widget (e.g., VoiceNotesScreen, TaggingScreen, SettingsScreen).
  final List<Widget> _screens = const [
    MyVoiceNotesScreen(),   // Corresponds to 'index' tab
    TaggingScreen(),        // Corresponds to 'tagging' tab
    SettingsScreen(),       // Corresponds to 'settings' tab
  ];

  @override
  Widget build(BuildContext context) {
    // Determine if the platform is iOS for specific height adjustments
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Calculate platform-specific tab bar height and bottom padding for the Container
    final double tabBarHeight = isIOS ? 88.0 : 60.0;
    final double tabBarPaddingBottom = isIOS ? 28.0 : 8.0;

    return Scaffold(
      // The `body` uses an `IndexedStack` to keep all tab screens alive
      // (maintain their state) but only display the currently selected one.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // The `bottomNavigationBar` is wrapped in a `SafeArea` and `Container` to apply custom styling
      // that isn't directly available on `BottomNavigationBar` itself (like `boxShadow`).
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.tabBarBorder, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: const Offset(0, -2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: AppColors.tabBarActive,
              unselectedItemColor: AppColors.tabBarInactive,
              items: [
                BottomNavigationBarItem(
                  icon: TabBarIcon(
                    icon: Icons.inbox,
                    focused: _currentIndex == 0,
                    label: 'Voice Inbox',
                  ),
                  label: 'Voice Inbox',
                ),
                BottomNavigationBarItem(
                  icon: TabBarIcon(
                    icon: Icons.tag,
                    focused: _currentIndex == 1,
                    label: 'Client Tagging',
                  ),
                  label: 'Client Tagging',
                ),
                BottomNavigationBarItem(
                  icon: TabBarIcon(
                    icon: Icons.settings,
                    focused: _currentIndex == 2,
                    label: 'Settings',
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Placeholder Screens ---
// You will replace these with your actual screen implementations.

// class TaggingScreen extends StatelessWidget {
//   const TaggingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Client Tagging')),
//       body: const Center(child: Text('Client Tagging Screen Content')),
//     );
//   }
// }

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen Content')),
    );
  }
}