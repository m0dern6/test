import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textLight),
    titleTextStyle: TextStyle(
      color: AppColors.textLight,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    surface: AppColors.darkSurface,
    background: AppColors.darkBackground,
    primary: AppColors.textLight,
    secondary: Colors.grey,
    tertiary: AppColors.primaryBlue,
    error: AppColors.error,
  ),
  cardTheme: CardThemeData(
    color: AppColors.darkCard,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.textLight),
    displayMedium: TextStyle(color: AppColors.textLight),
    displaySmall: TextStyle(color: AppColors.textLight),
    headlineLarge: TextStyle(color: AppColors.textLight),
    headlineMedium: TextStyle(color: AppColors.textLight),
    headlineSmall: TextStyle(color: AppColors.textLight),
    titleLarge: TextStyle(color: AppColors.textLight),
    titleMedium: TextStyle(color: AppColors.textLight),
    titleSmall: TextStyle(color: AppColors.textLight),
    bodyLarge: TextStyle(color: Colors.grey),
    bodyMedium: TextStyle(color: Colors.grey),
    bodySmall: TextStyle(color: Colors.grey),
    labelLarge: TextStyle(color: Colors.grey),
    labelMedium: TextStyle(color: Colors.grey),
    labelSmall: TextStyle(color: Colors.grey),
  ),
);
