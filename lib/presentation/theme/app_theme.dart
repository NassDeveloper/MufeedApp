import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary = Gold/Amber
    primary: AppColors.gold,
    onPrimary: AppColors.darkBackground,
    primaryContainer: AppColors.goldContainer,
    onPrimaryContainer: AppColors.goldLight,

    // Secondary = Cyan
    secondary: AppColors.cyan,
    onSecondary: AppColors.darkBackground,
    secondaryContainer: AppColors.cyanContainer,
    onSecondaryContainer: AppColors.cyanLight,

    // Tertiary = Violet (milestones, streaks)
    tertiary: AppColors.violet,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.violetContainer,
    onTertiaryContainer: AppColors.violetLight,

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
    surfaceContainerHighest: Color(0xFF25252E),

    // Outline
    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF1E293B),

    // Inverse
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.darkBackground,
    inversePrimary: AppColors.goldLight,

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
      centerTitle: false,
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
          color: AppColors.gold.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      indicatorColor: AppColors.gold.withValues(alpha: 0.20),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.gold);
        }
        return const IconThemeData(color: AppColors.textSecondary);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.gold,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        );
      }),
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
