import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('dark theme uses dark brightness', () {
      expect(AppTheme.dark.brightness, Brightness.dark);
    });

    test('dark theme uses Material 3', () {
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('dark theme has correct seed color scheme', () {
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
    });

    test('dark theme is a singleton (static final)', () {
      final theme1 = AppTheme.dark;
      final theme2 = AppTheme.dark;
      expect(identical(theme1, theme2), isTrue);
    });

    test('arabicFontFamily returns ScheherazadeNew', () {
      expect(AppTheme.arabicFontFamily, 'ScheherazadeNew');
    });
  });
}
