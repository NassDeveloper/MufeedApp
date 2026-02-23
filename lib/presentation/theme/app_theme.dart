import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary = Doré/ambre (accent principal)
    primary: AppColors.gold,
    onPrimary: AppColors.darkBackground,
    primaryContainer: AppColors.goldDark,
    onPrimaryContainer: AppColors.cream,

    // Secondary = Vert moyen
    secondary: AppColors.greenMuted,
    onSecondary: AppColors.cream,
    secondaryContainer: AppColors.darkCardSurface,
    onSecondaryContainer: AppColors.creamMuted,

    // Tertiary = Crème chaud
    tertiary: AppColors.creamMuted,
    onTertiary: AppColors.darkBackground,
    tertiaryContainer: AppColors.darkCardSurface,
    onTertiaryContainer: AppColors.cream,

    // Error
    error: AppColors.evaluationRed,
    onError: Colors.white,

    // Surface = Vert profond
    surface: AppColors.darkSurface,
    onSurface: AppColors.cream,
    onSurfaceVariant: AppColors.creamMuted,

    // Surface containers (cards, dialogs, etc.)
    surfaceContainerLowest: Color(0xFF132E23),
    surfaceContainerLow: Color(0xFF1B4332),
    surfaceContainer: Color(0xFF234E3B),
    surfaceContainerHigh: Color(0xFF2D5A45),
    surfaceContainerHighest: Color(0xFF376650),

    // Outline
    outline: AppColors.greenMuted,
    outlineVariant: Color(0xFF2D5A45),

    // Inverse
    inverseSurface: AppColors.cream,
    onInverseSurface: AppColors.darkBackground,
    inversePrimary: AppColors.goldDark,

    shadow: Colors.black,
    scrim: Colors.black,
  );

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary = Vert moyen (accent principal)
    primary: AppColors.greenAccent,
    onPrimary: AppColors.cream,
    primaryContainer: Color(0xFFC8E6D5),
    onPrimaryContainer: AppColors.darkBackground,

    // Secondary = Doré/ambre
    secondary: AppColors.gold,
    onSecondary: AppColors.darkBackground,
    secondaryContainer: Color(0xFFF5E6C0),
    onSecondaryContainer: AppColors.goldDark,

    // Tertiary = Vert profond
    tertiary: AppColors.darkBackground,
    onTertiary: AppColors.cream,
    tertiaryContainer: Color(0xFFD0E8DB),
    onTertiaryContainer: AppColors.darkBackground,

    // Error
    error: AppColors.evaluationRed,
    onError: Colors.white,

    // Surface = Crème chaud
    surface: AppColors.lightSurface,
    onSurface: AppColors.darkBackground,
    onSurfaceVariant: AppColors.greenMuted,

    // Surface containers (cards, dialogs, etc.)
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFFFDF5),
    surfaceContainer: Color(0xFFFFF8E7),
    surfaceContainerHigh: Color(0xFFF5EDDA),
    surfaceContainerHighest: Color(0xFFEDE5D0),

    // Outline
    outline: AppColors.greenMuted,
    outlineVariant: Color(0xFFD0D8D3),

    // Inverse
    inverseSurface: AppColors.darkBackground,
    onInverseSurface: AppColors.cream,
    inversePrimary: AppColors.gold,

    shadow: Colors.black,
    scrim: Colors.black,
  );

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardTheme: CardThemeData(
      color: AppColors.lightCardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.darkBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      indicatorColor: AppColors.greenAccent.withValues(alpha: 0.2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.greenAccent,
        foregroundColor: AppColors.cream,
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardTheme: CardThemeData(
      color: AppColors.darkCardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.cream,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      indicatorColor: AppColors.gold.withValues(alpha: 0.2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkBackground,
      ),
    ),
  );

  static String get arabicFontFamily => AppTypography.arabicFontFamily;
}
