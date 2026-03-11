import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/presentation/providers/locale_provider.dart';
import 'package:mufeed_app/presentation/providers/onboarding_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FixedLocaleNotifier extends LocaleNotifier {
  @override
  Locale build() => const Locale('fr');
}

void main() {
  group('OnboardingState', () {
    test('initial state has page 0 and null selections', () {
      const state = OnboardingState();
      expect(state.currentPage, 0);
      expect(state.learningMode, isNull);
      expect(state.selectedLevelId, isNull);
    });

    test('canProceed is true on welcome page', () {
      const state = OnboardingState();
      expect(state.canProceed, true);
    });

    test('canProceed is false on level page without selection', () {
      const state = OnboardingState(currentPage: 1);
      expect(state.canProceed, false);
    });

    test('canProceed is true on level page with selection', () {
      const state = OnboardingState(currentPage: 1, selectedLevelId: 1);
      expect(state.canProceed, true);
    });

    test('canProceed is true on mini-session page (page 2)', () {
      const state = OnboardingState(currentPage: 2);
      expect(state.canProceed, true);
    });

    test('canProceed is true on consent page (page 3)', () {
      const state = OnboardingState(currentPage: 3);
      expect(state.canProceed, true);
    });

    test('canProceed is false on unknown page', () {
      const state = OnboardingState(currentPage: 99);
      expect(state.canProceed, false);
    });
  });

  group('OnboardingNotifier', () {
    late ProviderContainer container;
    late SharedPreferencesSource prefsSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      container = ProviderContainer(
        overrides: [
          sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
          localeProvider.overrideWith(() => _FixedLocaleNotifier()),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is page 0', () {
      final state = container.read(onboardingProvider);
      expect(state.currentPage, 0);
    });

    test('setLearningMode updates state', () {
      container.read(onboardingProvider.notifier).setLearningMode('autodidact');
      expect(container.read(onboardingProvider).learningMode, 'autodidact');
    });

    test('setSelectedLevel updates state', () {
      container.read(onboardingProvider.notifier).setSelectedLevel(3);
      expect(container.read(onboardingProvider).selectedLevelId, 3);
    });

    test('nextPage increments page', () {
      container.read(onboardingProvider.notifier).nextPage();
      expect(container.read(onboardingProvider).currentPage, 1);
    });

    test('nextPage does not exceed max pages', () {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.nextPage(); // 1
      notifier.nextPage(); // 2
      notifier.nextPage(); // 3
      notifier.nextPage(); // still 3 (totalPages - 1)
      expect(container.read(onboardingProvider).currentPage, 3);
    });

    test('previousPage decrements page', () {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.nextPage();
      notifier.previousPage();
      expect(container.read(onboardingProvider).currentPage, 0);
    });

    test('previousPage does not go below 0', () {
      container.read(onboardingProvider.notifier).previousPage();
      expect(container.read(onboardingProvider).currentPage, 0);
    });

    test('setGdprConsent updates state', () {
      container.read(onboardingProvider.notifier).setGdprConsent(true);
      expect(container.read(onboardingProvider).gdprConsent, true);
    });

    test('setGdprConsent can set to false', () {
      container.read(onboardingProvider.notifier).setGdprConsent(false);
      expect(container.read(onboardingProvider).gdprConsent, false);
    });

    test('completeOnboarding saves preferences including locale', () async {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.setLearningMode('curriculum');
      notifier.setSelectedLevel(5);
      await notifier.completeOnboarding();

      expect(prefsSource.isOnboardingCompleted(), true);
      expect(prefsSource.getLearningMode(), 'curriculum');
      expect(prefsSource.getActiveLevelId(), 5);
      expect(prefsSource.getLocale(), 'fr');
    });

    test('completeOnboarding saves gdpr consent when set', () async {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.setLearningMode('curriculum');
      notifier.setSelectedLevel(1);
      notifier.setGdprConsent(true);
      await notifier.completeOnboarding();

      expect(prefsSource.getGdprConsent(), true);
    });

    test('completeOnboarding does not save gdpr consent when null', () async {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.setLearningMode('curriculum');
      notifier.setSelectedLevel(1);
      await notifier.completeOnboarding();

      expect(prefsSource.getGdprConsent(), isNull);
    });

    test('completeOnboarding does nothing without selections', () async {
      await container
          .read(onboardingProvider.notifier)
          .completeOnboarding();

      expect(prefsSource.isOnboardingCompleted(), false);
    });
  });
}
