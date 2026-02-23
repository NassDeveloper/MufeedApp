import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const arabicFontFamily = 'ScheherazadeNew';
  static const arabicMinFontSize = 24.0;

  // Arabic text styles
  static const TextStyle arabicHeadline = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle arabicBody = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: arabicMinFontSize,
  );

  static const TextStyle flashcardArabic = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle arabicSmall = TextStyle(
    fontFamily: arabicFontFamily,
    fontSize: arabicMinFontSize,
  );
}
