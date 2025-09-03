// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:voice_crm_ui_upgrade/screens/main_tabs_screen.dart';
import 'package:voice_crm_ui_upgrade/services/database_service.dart'; 

 
late DatabaseService databaseService; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  

  databaseService = DatabaseService();
  await databaseService.init(); 

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent, 
    statusBarIconBrightness: Brightness.dark, 
    statusBarBrightness: Brightness.light, 
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Notes App',
      theme: ThemeData(
        fontFamily: 'Inter', 
        primarySwatch: Colors.blue, 
        scaffoldBackgroundColor: Colors.white, 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0, 
          titleTextStyle: TextStyle(
            fontFamily: 'Inter-Medium',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent, 
          selectedItemColor: Color(0xFF5B9DF9),
          unselectedItemColor: Color(0xFF666666),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0, 
        ),
        useMaterial3: true, 
      ),
      home: const MainTabsScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}
