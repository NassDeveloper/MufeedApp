import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary = Violet
    primary: AppColors.violet,
    onPrimary: Colors.white,
    primaryContainer: AppColors.violetContainer,
    onPrimaryContainer: AppColors.violetLight,

    // Secondary = Cyan
    secondary: AppColors.cyan,
    onSecondary: AppColors.darkBackground,
    secondaryContainer: AppColors.cyanContainer,
    onSecondaryContainer: AppColors.cyanLight,

    // Tertiary = Gold/Amber (série, milestones)
    tertiary: AppColors.gold,
    onTertiary: AppColors.darkBackground,
    tertiaryContainer: AppColors.goldDark,
    onTertiaryContainer: AppColors.gold,

    // Error
    error: AppColors.evaluationRed,
    onError: Colors.white,

    // Surface = deep navy
    surface: AppColors.darkSurface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,

    // Surface containers
    surfaceContainerLowest: Color(0xFF0A0A18),
    surfaceContainerLow: AppColors.darkBackground,
    surfaceContainer: AppColors.darkCardSurface,
    surfaceContainerHigh: AppColors.darkElevated,
    surfaceContainerHighest: Color(0xFF252542),

    // Outline
    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF1E293B),

    // Inverse
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.darkBackground,
    inversePrimary: AppColors.violetLight,

    shadow: Colors.black,
    scrim: Colors.black,
  );

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary = Vert moyen
    primary: AppColors.greenAccent,
    onPrimary: AppColors.cream,
    primaryContainer: Color(0xFFC8E6D5),
    onPrimaryContainer: AppColors.darkLegacyBackground,

    // Secondary = Doré/ambre
    secondary: AppColors.gold,
    onSecondary: AppColors.darkLegacyBackground,
    secondaryContainer: Color(0xFFF5E6C0),
    onSecondaryContainer: AppColors.goldLegacyDark,

    // Tertiary = Vert profond
    tertiary: AppColors.darkLegacyBackground,
    onTertiary: AppColors.cream,
    tertiaryContainer: Color(0xFFD0E8DB),
    onTertiaryContainer: AppColors.darkLegacyBackground,

    // Error
    error: AppColors.evaluationRed,
    onError: Colors.white,

    // Surface = Crème chaud
    surface: AppColors.lightSurface,
    onSurface: AppColors.darkLegacyBackground,
    onSurfaceVariant: AppColors.greenMuted,

    // Surface containers
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFFFDF5),
    surfaceContainer: Color(0xFFFFF8E7),
    surfaceContainerHigh: Color(0xFFF5EDDA),
    surfaceContainerHighest: Color(0xFFEDE5D0),

    // Outline
    outline: AppColors.greenMuted,
    outlineVariant: Color(0xFFD0D8D3),

    // Inverse
    inverseSurface: AppColors.darkLegacyBackground,
    onInverseSurface: AppColors.cream,
    inversePrimary: AppColors.goldLegacyDark,

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
      foregroundColor: AppColors.darkLegacyBackground,
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
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.violet.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      indicatorColor: AppColors.violet.withValues(alpha: 0.25),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.violet,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static String get arabicFontFamily => AppTypography.arabicFontFamily;
}
