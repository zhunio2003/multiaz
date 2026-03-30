import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_typography.dart';

class AppTheme {
  
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface
    ),

    textTheme: TextTheme(
      displayLarge: AppTypography.h1,
      displayMedium: AppTypography.h2,
      headlineLarge: AppTypography.h3,
      headlineMedium: AppTypography.h4,
      titleLarge: AppTypography.h5,
      titleMedium: AppTypography.h6,
      bodyLarge: AppTypography.body,
      bodySmall: AppTypography.caption,
      labelLarge: AppTypography.button      
    ), 
    
    cardTheme: const CardThemeData(
      color: AppColors.surface,
    ),
  );
}