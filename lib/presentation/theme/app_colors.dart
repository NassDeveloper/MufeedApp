import 'package:flutter/material.dart';

abstract final class AppColors {
  // Seed color for Material 3 ColorScheme
  static const seedColor = Color(0xFF1B4332);

  // === Dark Mode Palette (from UX Specification) ===

  // Backgrounds
  static const darkBackground = Color(0xFF1B4332); // Vert profond
  static const darkSurface = Color(0xFF1B4332);
  static const darkCardSurface = Color(0xFF2D5A45); // Vert légèrement plus clair

  // Accent – Doré/ambre
  static const gold = Color(0xFFD4A843);
  static const goldDark = Color(0xFF9E7A2E); // Pour containers dorés

  // Texte
  static const cream = Color(0xFFFFF8E7); // Blanc/crème
  static const creamMuted = Color(0xFFE8DCC8); // Crème atténué
  static const greenMuted = Color(0xFF4A7C67); // Vert atténué (outlines)

  // === Light Mode Palette (from UX Specification) ===

  // Backgrounds
  static const lightBackground = Color(0xFFFFF8E7); // Crème chaud
  static const lightSurface = Color(0xFFFFF8E7);
  static const lightCardSurface = Color(0xFFFFFDF5); // Blanc cassé

  // Accent – Vert moyen
  static const greenAccent = Color(0xFF2D6A4F);

  // Evaluation colors (SRS / Quiz feedback)
  static const evaluationGreen = Color(0xFF4CAF50);
  static const evaluationGold = Color(0xFFFFB300);
  static const evaluationOrange = Color(0xFFFF7043);
  static const evaluationRed = Color(0xFFEF5350);

  // Aliases kept for backward compatibility
  static const ratingEasy = evaluationGreen;
  static const ratingGood = evaluationGold;
  static const ratingHard = evaluationOrange;
  static const ratingAgain = evaluationRed;
}
