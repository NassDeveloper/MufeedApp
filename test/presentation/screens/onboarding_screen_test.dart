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
import 'package:mufeed_app/presentation/providers/onboarding_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeContentRepository implements ContentRepository {
  List<LevelModel> levels = [];

  @override
  Future<List<LevelModel>> getAllLevels() async => levels;

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async => [];

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => [];

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

    testWidgets('navigates to mode page on start', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      expect(find.text('Comment apprenez-vous ?'), findsOneWidget);
      expect(
          find.text('J\'étudie auprès d\'un institut'), findsOneWidget);
      expect(find.text('Autodidacte'), findsOneWidget);
    });

    testWidgets('next button disabled without mode selection', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Go to mode page
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      // Next button should be disabled
      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Suivant'),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('selecting mode enables next button', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Autodidacte'));
      await tester.pumpAndSettle();

      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Suivant'),
      );
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('navigates to level page after mode', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Autodidacte'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      expect(find.text('Choisissez votre niveau'), findsOneWidget);
      expect(find.text('Niveau 1'), findsOneWidget);
      expect(find.text('Niveau 2'), findsOneWidget);
      expect(find.text('Niveau 3'), findsOneWidget);
    });

    testWidgets('next button disabled without level selection',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      await tester
          .tap(find.text('J\'étudie auprès d\'un institut'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Both mode page and level page have "Suivant"; get the last one (level page).
      final nextButtons = tester
          .widgetList<FilledButton>(
            find.widgetWithText(FilledButton, 'Suivant'),
          )
          .toList();
      expect(nextButtons.last.onPressed, isNull);
    });

    testWidgets('selecting level enables next button', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      await tester
          .tap(find.text('J\'étudie auprès d\'un institut'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Niveau 2'));
      await tester.pumpAndSettle();

      // Both mode page and level page have "Suivant"; get the last one (level page).
      final nextButtons = tester
          .widgetList<FilledButton>(
            find.widgetWithText(FilledButton, 'Suivant'),
          )
          .toList();
      expect(nextButtons.last.onPressed, isNotNull);
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

    testWidgets('navigates to consent page after level selection',
        (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // Welcome → Mode
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      // Mode → Level
      await tester.tap(find.text('Autodidacte'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Level → Consent
      await tester.tap(find.text('Niveau 1'));
      await tester.pumpAndSettle();
      // Tap the last "Suivant" button (level page)
      await tester.tap(find.widgetWithText(FilledButton, 'Suivant').last);
      await tester.pumpAndSettle();

      expect(
        find.text('Données & confidentialité'),
        findsOneWidget,
      );
      expect(find.text('Accepter'), findsOneWidget);
      expect(find.text('Refuser'), findsOneWidget);
    });
  });
}

class _FixedLocaleNotifier extends LocaleNotifier {
  @override
  Locale build() => const Locale('fr');
}
