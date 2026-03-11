import 'package:flutter/material.dart';

abstract final class AppColors {
  // === Dark Neomorphism Palette ===

  // Backgrounds — deep navy
  static const darkBackground = Color(0xFF0F0F1A);
  static const darkSurface = Color(0xFF13131E);
  static const darkCardSurface = Color(0xFF1A1A28);
  static const darkElevated = Color(0xFF1F1F32);

  // Primary — Gold (metallic)
  static const gold = Color(0xFFD4AF37);     // metallic gold
  static const goldLight = Color(0xFFF0CB6A); // bright gold accent
  static const goldContainer = Color(0xFF2A1C00); // deep warm dark

  // Secondary — Cyan (contrast)
  static const cyan = Color(0xFF06B6D4);
  static const cyanLight = Color(0xFF67E8F9);
  static const cyanContainer = Color(0xFF0C4A6E);

  // Accent — Violet (kept for tertiary/milestones)
  static const violet = Color(0xFF7C3AED);
  static const violetLight = Color(0xFFA78BFA);
  static const violetContainer = Color(0xFF2D1B69);

  // Legacy gold dark (kept for light theme)
  static const goldDark = Color(0xFF78350F);

  // Neumorphism shadows (calibrated for darkCardSurface #1A1A2E)
  static const neuShadowLight = Color(0xFF252542);
  static const neuShadowDark = Color(0xFF09090F);

  // Text
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);

  // === Light Mode Palette (unchanged) ===

  static const lightBackground = Color(0xFFFFF8E7);
  static const lightSurface = Color(0xFFFFF8E7);
  static const lightCardSurface = Color(0xFFFFFDF5);

  static const greenAccent = Color(0xFF2D6A4F);
  static const cream = Color(0xFFFFF8E7);
  static const creamMuted = Color(0xFFE8DCC8);
  static const greenMuted = Color(0xFF4A7C67);

  // Dark legacy aliases (kept for light theme ColorScheme compat)
  static const darkLegacyBackground = Color(0xFF1B4332);
  static const goldLegacyDark = Color(0xFF9E7A2E);

  // Evaluation colors (SRS / Quiz feedback)
  static const evaluationGreen = Color(0xFF4CAF50);
  static const evaluationGold = Color(0xFFFFB300);
  static const evaluationOrange = Color(0xFFFF7043);
  static const evaluationRed = Color(0xFFEF5350);

  // Aliases
  static const ratingEasy = evaluationGreen;
  static const ratingGood = evaluationGold;
  static const ratingHard = evaluationOrange;
  static const ratingAgain = evaluationRed;
}
