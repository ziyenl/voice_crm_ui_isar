// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome to control status bar
import 'package:voice_crm_ui_upgrade/screens/main_tabs_screen.dart';
import 'package:voice_crm_ui_upgrade/services/database_service.dart'; // Import your new service

 
// You can still expose the Isar instance globally for convenience,
// or use a state management solution to provide it.
late DatabaseService databaseService; // Declare a global or accessible instance


//final DatabaseService databaseService = DatabaseService();

Future<void> main() async {
  // Ensure Flutter binding is initialized before performing any operations
  // that require the binding, like setting system overlays or pre-loading assets.
  WidgetsFlutterBinding.ensureInitialized();  // Required for path_provider and Isar

  // Initialize your singleton DatabaseService
  databaseService = DatabaseService();
  await databaseService.init(); // Initialize the database service

  // Set the system UI overlay style, similar to React Native's StatusBar.
  // This configures how the status bar (top bar with time, battery) looks.
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent, // Make status bar background transparent
    statusBarIconBrightness: Brightness.dark, // Use dark icons (for light content underneath)
    statusBarBrightness: Brightness.light, // For iOS: light text/icons on dark backgrounds
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Notes App',
      // Define a custom theme for your app.
      theme: ThemeData(
        fontFamily: 'Inter', // Set 'Inter' as the default font across the app
        primarySwatch: Colors.blue, // Example primary color
        scaffoldBackgroundColor: Colors.white, // Default background for all scaffolds
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Color of title and icons in the app bar
          elevation: 0, // No shadow for app bar by default (match headerShown: false if app bar is manually added)
          titleTextStyle: TextStyle(
            fontFamily: 'Inter-Medium',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        // Apply theme settings for the BottomNavigationBar to avoid repetition
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent, // Crucial for custom Container background
          selectedItemColor: Color(0xFF5B9DF9),
          unselectedItemColor: Color(0xFF666666),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Remove default elevation
        ),
        useMaterial3: true, // Opt-in to Material 3 design for a modern look
      ),
      home: const MainTabsScreen(),  // Set your Voice Notes screen as the home
      debugShowCheckedModeBanner: false,
    );
  }
}