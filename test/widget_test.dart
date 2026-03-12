import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mufeed_app/app.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/streak_model.dart';
import 'package:mufeed_app/domain/repositories/streak_repository.dart';
import 'package:mufeed_app/presentation/providers/locale_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/streak_provider.dart';
import 'package:mufeed_app/presentation/router/app_router.dart';

class _FakeStreakRepository implements StreakRepository {
  @override
  Future<StreakModel?> getStreak() async => null;
  @override
  Future<DateTime?> getLastActivityDate() async => null;
  @override
  Future<void> updateLastActivityDate(DateTime date) async {}
  @override
  Future<void> updateStreak(StreakModel streak) async {}
}

/// Fixed locale notifier that always returns the given locale,
/// without reading SharedPreferences or PlatformDispatcher.
class _FixedLocaleNotifier extends LocaleNotifier {
  _FixedLocaleNotifier(this._locale);

  final Locale _locale;

  @override
  Locale build() => _locale;
}

void main() {
  testWidgets('App starts and shows navigation when onboarding completed',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final prefsSource = SharedPreferencesSource(prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
          localeProvider.overrideWith(() => _FixedLocaleNotifier(const Locale('fr'))),
          streakRepositoryProvider.overrideWithValue(_FakeStreakRepository()),
        ],
        child: MufeedApp(
          router: createAppRouter(
            isOnboardingCompleted: prefsSource.isOnboardingCompleted,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify navigation bar is visible with 3 tabs (fr locale)
    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Exercices'), findsWidgets);
    expect(find.text('Statistiques'), findsWidgets);
  });

  testWidgets('App shows onboarding when not completed',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final prefsSource = SharedPreferencesSource(prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
          localeProvider.overrideWith(() => _FixedLocaleNotifier(const Locale('fr'))),
          streakRepositoryProvider.overrideWithValue(_FakeStreakRepository()),
        ],
        child: MufeedApp(
          router: createAppRouter(
            isOnboardingCompleted: prefsSource.isOnboardingCompleted,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Should show onboarding welcome screen
    expect(find.text('Commencer'), findsOneWidget);
  });
}
