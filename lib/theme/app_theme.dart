import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ================= LIGHT THEME =================
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: AppColors.lightBackground,

  colorScheme: const ColorScheme.light(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,

    primary: AppColors.accentPurple,
    onPrimary: Colors.white,

    onSurface: AppColors.lightText,
  ),

  // ---------- APP BAR ----------
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.lightText),
    titleTextStyle: TextStyle(
      color: AppColors.lightText,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  // ---------- BOTTOM NAV ----------
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightBackground,
    selectedItemColor: AppColors.accentPurple,
    unselectedItemColor: AppColors.lightSubText,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),

  // ---------- BUTTONS ----------
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
);

/// ================= DARK THEME =================
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: AppColors.darkBackground,

  colorScheme: const ColorScheme.dark(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,

    primary: AppColors.accentPurple,
    onPrimary: Colors.white,

    onSurface: AppColors.darkText,
  ),

  // ---------- APP BAR ----------
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.darkText),
    titleTextStyle: TextStyle(
      color: AppColors.darkText,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  // ---------- BOTTOM NAV ----------
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBackground,
    selectedItemColor: AppColors.accentPurple,
    unselectedItemColor: AppColors.darkSubText,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),

  // ---------- BUTTONS ----------
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
);
