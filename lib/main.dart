import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CampusEventApp());
}

class CampusEventApp extends StatelessWidget {
  const CampusEventApp({super.key});

  // ESTU Kurumsal Kırmızı Tonu
  static const Color estuRed = Color(0xFFA3082C);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESTÜ Event Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'CustomCampusFont',
        colorScheme: ColorScheme.fromSeed(
          seedColor: estuRed,
          primary: estuRed,
          secondary: const Color(0xFFC41E3A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: estuRed,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: estuRed,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
