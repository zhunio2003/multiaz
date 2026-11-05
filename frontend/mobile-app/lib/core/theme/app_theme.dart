import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors_dark.dart';
import 'package:mobile_app/core/theme/app_colors_light.dart';
import 'package:mobile_app/core/theme/app_typography.dart';

class AppTheme {
  
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsDark.background,
    colorScheme: ColorScheme.dark(
      primary: AppColorsDark.primary,
      secondary: AppColorsDark.secondary,
      error: AppColorsDark.error,
      surface: AppColorsDark.surface
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
      color: AppColorsDark.surface,
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsLight.background,
    colorScheme: ColorScheme.light(
      primary: AppColorsLight.primary,
          onPrimary: AppColorsLight.onPrimary,
          secondary: AppColorsLight.secondary,
          error: AppColorsLight.error,
          surface: AppColorsLight.surface,
          onSurface: AppColorsLight.onSurface,
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
    ).apply(
      displayColor: AppColorsLight.onBackground,
      bodyColor: AppColorsLight.onBackground,
    ),
    cardTheme: const CardThemeData(
      color: AppColorsLight.surface,
      elevation: 1,
    ),
  );
}