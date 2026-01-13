import 'package:flutter/material.dart';

///  LIGHT THEME
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: Colors.white,

  colorScheme: const ColorScheme.light(
    surface: Colors.white,

    primary: Colors.black,
    onPrimary: Colors.white,

    onSurface: Colors.black,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.black,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  ),
);

///  DARK THEME
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: const Color(0xFF0B0C0F),

  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF0B0C0F),

    primary: Colors.white,
    onPrimary: Colors.black,

    onSurface: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0B0C0F),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  ),
);
