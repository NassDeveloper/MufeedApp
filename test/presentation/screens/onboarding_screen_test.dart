import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/models/sentence_exercise_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/locale_provider.dart';
import 'package:mufeed_app/presentation/providers/mini_session_provider.dart';
import 'package:mufeed_app/presentation/providers/onboarding_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

WordModel _word(int id) => WordModel(
      id: id,
      lessonId: 1,
      contentType: 'word',
      arabic: 'كَلِمَة $id',
      translationFr: 'mot $id',
      sortOrder: id,
    );

UnitModel _unit(int id) => UnitModel(
      id: id,
      levelId: 1,
      number: id,
      nameFr: 'Unité $id',
      nameEn: 'Unit $id',
    );

LessonModel _lesson(int id) => LessonModel(
      id: id,
      unitId: 1,
      number: id,
      nameFr: 'Leçon $id',
      nameEn: 'Lesson $id',
    );

class FakeContentRepository implements ContentRepository {
  List<LevelModel> levels = [];

  @override
  Future<List<LevelModel>> getAllLevels() async => levels;

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async =>
      [_unit(1), _unit(2)];

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async =>
      [_lesson(1), _lesson(2)];

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async =>
      [_word(1), _word(2), _word(3), _word(4), _word(5)];

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async => [];

  @override
  Future<LessonModel?> getLessonById(int lessonId) async => null;
  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(int lessonId) async => [];
}

LevelModel _level(int id) => LevelModel(
      id: id,
      number: id,
      nameFr: 'Niveau $id',
      nameEn: 'Level $id',
      nameAr: 'المستوى $id',
      unitCount: 3,
    );

Widget _buildApp(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: OnboardingScreen(),
    ),
  );
}

void main() {
  group('OnboardingScreen', () {
    late ProviderContainer container;
    late FakeContentRepository repo;
    late SharedPreferencesSource prefsSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      prefsSource = SharedPreferencesSource(prefs);
      repo = FakeContentRepository();
      repo.levels = [_level(1), _level(2), _level(3)];
      container = ProviderContainer(
        overrides: [
          contentRepositoryProvider.overrideWithValue(repo),
          sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
          localeProvider.overrideWith(() => _FixedLocaleNotifier()),
          miniSessionWordsProvider.overrideWith(
            (_) async => [_word(1), _word(2), _word(3)],
          ),
        ],
      );
    });

    tearDown(() => container.dispose());

    testWidgets('displays welcome page initially', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Apprends l\'arabe avec méthode'), findsOneWidget);
      expect(find.text('Commencer'), findsOneWidget);
    });

    testWidgets('navigates to level page on start', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      expect(find.text('Choisissez votre niveau'), findsOneWidget);
      expect(find.text('Niveau 1'), findsOneWidget);
      expect(find.text('Niveau 2'), findsOneWidget);
      expect(find.text('Niveau 3'), findsOneWidget);
    });

    testWidgets('next button disabled without level selection', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Go to level page
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      // Next button should be disabled
      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Suivant'),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('selecting level enables next button', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Go to level page
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Niveau 1'));
      await tester.pumpAndSettle();

      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Suivant'),
      );
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('selecting level 2 enables next button', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Go to level page
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Niveau 2'));
      await tester.pumpAndSettle();

      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Suivant'),
      );
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('completing onboarding saves preferences including locale',
        (tester) async {
      // Use the notifier directly to complete onboarding since context.go
      // requires a GoRouter in context which this test does not provide.
      final notifier = container.read(onboardingProvider.notifier);
      notifier.setLearningMode('curriculum');
      notifier.setSelectedLevel(1);
      await notifier.completeOnboarding();

      expect(prefsSource.isOnboardingCompleted(), true);
      expect(prefsSource.getLearningMode(), 'curriculum');
      expect(prefsSource.getActiveLevelId(), 1);
      expect(prefsSource.getLocale(), 'fr');
    });

    testWidgets('shows page indicator and PageView', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('navigates to mini-session page after level selection',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Welcome → Level
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      // Level → Mini-session
      await tester.tap(find.text('Niveau 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Suivant'));
      await tester.pumpAndSettle();

      expect(find.text('Aperçu de votre contenu'), findsOneWidget);
    });

    testWidgets('navigates to consent page after mini-session',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Welcome → Level
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      // Level → Mini-session
      await tester.tap(find.text('Niveau 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Mini-session → Consent
      await tester.tap(find.widgetWithText(FilledButton, 'Suivant'));
      await tester.pumpAndSettle();

      expect(find.text('Données & confidentialité'), findsOneWidget);
      expect(find.text('Accepter'), findsOneWidget);
      expect(find.text('Refuser'), findsOneWidget);
    });

    testWidgets('back button not visible on welcome page', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Précédent'), findsNothing);
    });

    testWidgets('back button visible on level page', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      expect(find.text('Précédent'), findsOneWidget);
    });

    testWidgets('back button navigates to previous page', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Go to level page
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();
      expect(find.text('Choisissez votre niveau'), findsOneWidget);

      // Tap back
      await tester.tap(find.text('Précédent'));
      await tester.pumpAndSettle();

      expect(find.text('Apprends l\'arabe avec méthode'), findsOneWidget);
    });
  });
}

class _FixedLocaleNotifier extends LocaleNotifier {
  @override
  Locale build() => const Locale('fr');
}
