import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/data/services/analytics_service_impl.dart';
import 'package:mufeed_app/presentation/providers/analytics_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProviderContainer _createContainer(SharedPreferencesSource prefs) {
  return ProviderContainer(
    overrides: [
      sharedPreferencesSourceProvider.overrideWithValue(prefs),
      analyticsServiceProvider.overrideWithValue(AnalyticsServiceImpl()),
    ],
  );
}

void main() {
  group('GdprConsentNotifier', () {
    late ProviderContainer container;
    late SharedPreferencesSource prefsSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);
    });

    tearDown(() => container.dispose());

    test('defaults to null when no saved preference', () {
      expect(container.read(gdprConsentProvider), isNull);
    });

    test('loads saved true preference', () async {
      container.dispose();
      SharedPreferences.setMockInitialValues({'gdpr_consent': true});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);

      expect(container.read(gdprConsentProvider), true);
    });

    test('loads saved false preference', () async {
      container.dispose();
      SharedPreferences.setMockInitialValues({'gdpr_consent': false});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = _createContainer(prefsSource);

      expect(container.read(gdprConsentProvider), false);
    });

    test('setConsent updates state to true', () async {
      await container
          .read(gdprConsentProvider.notifier)
          .setConsent(true);
      expect(container.read(gdprConsentProvider), true);
    });

    test('setConsent updates state to false', () async {
      await container
          .read(gdprConsentProvider.notifier)
          .setConsent(false);
      expect(container.read(gdprConsentProvider), false);
    });

    test('setConsent persists to SharedPreferences', () async {
      await container
          .read(gdprConsentProvider.notifier)
          .setConsent(true);
      expect(prefsSource.getGdprConsent(), true);
    });

    test('can toggle consent', () async {
      final notifier = container.read(gdprConsentProvider.notifier);

      await notifier.setConsent(true);
      expect(container.read(gdprConsentProvider), true);

      await notifier.setConsent(false);
      expect(container.read(gdprConsentProvider), false);

      await notifier.setConsent(true);
      expect(container.read(gdprConsentProvider), true);
    });
  });
}
