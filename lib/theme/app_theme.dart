import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  scaffoldBackgroundColor: AppColors.lightBackground,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: AppColors.lightText,
  ),

  colorScheme: const ColorScheme.light(
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightText,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.lightText,
    unselectedItemColor: AppColors.lightText,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  scaffoldBackgroundColor: AppColors.darkBackground,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: AppColors.darkText,
  ),

  colorScheme: const ColorScheme.dark(
    surface: AppColors.darkSurface,
    onSurface: Colors.black,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.darkText,
    unselectedItemColor: AppColors.darkText,
  ),
);
