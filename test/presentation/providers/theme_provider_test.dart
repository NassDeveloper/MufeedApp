import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/theme_provider.dart';
import 'package:mufeed_app/presentation/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProviderContainer _createContainer(SharedPreferencesSource prefs) {
  return ProviderContainer(
    overrides: [
      sharedPreferencesSourceProvider.overrideWithValue(prefs),
    ],
  );
}

void main() {
  group('ThemeModeNotifier', () {
    late ProviderContainer container;
    late SharedPreferencesSource prefsSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);
    });

    tearDown(() => container.dispose());

    test('defaults to dark when no saved preference', () {
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('loads saved dark preference', () async {
      container.dispose();
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('loads saved light preference', () async {
      container.dispose();
      SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);

      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('loads saved system preference', () async {
      container.dispose();
      SharedPreferences.setMockInitialValues({'theme_mode': 'system'});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);

      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('falls back to dark for unknown value', () async {
      container.dispose();
      SharedPreferences.setMockInitialValues({'theme_mode': 'unknown'});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('setThemeMode updates state', () async {
      await container
          .read(themeModeProvider.notifier)
          .setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('setThemeMode persists to SharedPreferences', () async {
      await container
          .read(themeModeProvider.notifier)
          .setThemeMode(ThemeMode.light);
      expect(prefsSource.getThemeMode(), 'light');
    });

    test('setThemeMode to system persists correctly', () async {
      await container
          .read(themeModeProvider.notifier)
          .setThemeMode(ThemeMode.system);
      expect(container.read(themeModeProvider), ThemeMode.system);
      expect(prefsSource.getThemeMode(), 'system');
    });

    test('can switch between all theme modes', () async {
      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);

      await notifier.setThemeMode(ThemeMode.system);
      expect(container.read(themeModeProvider), ThemeMode.system);

      await notifier.setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });
  });

  group('AppTheme', () {
    test('light theme has light brightness', () {
      expect(
        // ignore: deprecated_member_use
        AppTheme.light.brightness,
        Brightness.light,
      );
      expect(
        AppTheme.light.colorScheme.brightness,
        Brightness.light,
      );
    });

    test('dark theme has dark brightness', () {
      expect(
        // ignore: deprecated_member_use
        AppTheme.dark.brightness,
        Brightness.dark,
      );
      expect(
        AppTheme.dark.colorScheme.brightness,
        Brightness.dark,
      );
    });
  });
}
