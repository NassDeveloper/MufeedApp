import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/presentation/providers/locale_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProviderContainer _createContainer(SharedPreferencesSource prefs) {
  return ProviderContainer(
    overrides: [
      sharedPreferencesSourceProvider.overrideWithValue(prefs),
    ],
  );
}

Future<(ProviderContainer, SharedPreferencesSource)>
    _containerWithSavedLocale(String locale) async {
  SharedPreferences.setMockInitialValues({'locale': locale});
  final prefs = await SharedPreferences.getInstance();
  final source = SharedPreferencesSource(prefs);
  return (_createContainer(source), source);
}

void main() {
  group('LocaleNotifier', () {
    late ProviderContainer container;
    late SharedPreferencesSource prefsSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);
    });

    tearDown(() => container.dispose());

    test('returns a supported locale on fresh start', () {
      final locale = container.read(localeProvider);
      expect(
        LocaleNotifier.supportedLocales,
        contains(locale.languageCode),
      );
    });

    test('uses saved en locale from SharedPreferences', () async {
      container.dispose();
      final (c, _) = await _containerWithSavedLocale('en');
      container = c;

      expect(container.read(localeProvider), const Locale('en'));
    });

    test('uses saved fr locale from SharedPreferences', () async {
      container.dispose();
      final (c, _) = await _containerWithSavedLocale('fr');
      container = c;

      expect(container.read(localeProvider), const Locale('fr'));
    });

    test('ignores unsupported saved locale and falls back', () async {
      container.dispose();
      final (c, _) = await _containerWithSavedLocale('de');
      container = c;

      final locale = container.read(localeProvider);
      // Unsupported saved locale is ignored; falls back to platform or fr
      expect(
        LocaleNotifier.supportedLocales,
        contains(locale.languageCode),
      );
    });

    test('setLocale updates state', () async {
      await container
          .read(localeProvider.notifier)
          .setLocale(const Locale('en'));
      expect(container.read(localeProvider), const Locale('en'));
    });

    test('setLocale persists to SharedPreferences', () async {
      await container
          .read(localeProvider.notifier)
          .setLocale(const Locale('en'));
      expect(prefsSource.getLocale(), 'en');
    });

    test('setLocale can switch back to fr', () async {
      await container
          .read(localeProvider.notifier)
          .setLocale(const Locale('en'));
      await container
          .read(localeProvider.notifier)
          .setLocale(const Locale('fr'));
      expect(container.read(localeProvider), const Locale('fr'));
      expect(prefsSource.getLocale(), 'fr');
    });

    test('setLocale ignores unsupported locale', () async {
      await container
          .read(localeProvider.notifier)
          .setLocale(const Locale('zh'));
      // State should remain unchanged (initial platform-detected value)
      expect(
        LocaleNotifier.supportedLocales,
        contains(container.read(localeProvider).languageCode),
      );
      // Nothing persisted
      expect(prefsSource.getLocale(), isNull);
    });
  });
}
