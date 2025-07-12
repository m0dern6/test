import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightSurface,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    surface: AppColors.lightSurface,
    background: AppColors.lightBackground,
    primary: AppColors.textPrimary,
    secondary: AppColors.textSecondary,
    tertiary: AppColors.primaryBlue,
    error: AppColors.error,
  ),
  cardTheme: CardThemeData(
    color: AppColors.lightCard,
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
    displayLarge: TextStyle(color: AppColors.textPrimary),
    displayMedium: TextStyle(color: AppColors.textPrimary),
    displaySmall: TextStyle(color: AppColors.textPrimary),
    headlineLarge: TextStyle(color: AppColors.textPrimary),
    headlineMedium: TextStyle(color: AppColors.textPrimary),
    headlineSmall: TextStyle(color: AppColors.textPrimary),
    titleLarge: TextStyle(color: AppColors.textPrimary),
    titleMedium: TextStyle(color: AppColors.textPrimary),
    titleSmall: TextStyle(color: AppColors.textPrimary),
    bodyLarge: TextStyle(color: AppColors.textSecondary),
    bodyMedium: TextStyle(color: AppColors.textSecondary),
    bodySmall: TextStyle(color: AppColors.textSecondary),
    labelLarge: TextStyle(color: AppColors.textSecondary),
    labelMedium: TextStyle(color: AppColors.textSecondary),
    labelSmall: TextStyle(color: AppColors.textSecondary),
  ),
);
