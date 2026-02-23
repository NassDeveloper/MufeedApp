import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProgressRepository implements ProgressRepository {
  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async => [];
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      [];
  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];
  @override
  Future<UserProgressModel?> getProgressForItem(
          int itemId, String contentType) async =>
      null;
  @override
  Future<void> saveProgress(UserProgressModel progress) async {}
  @override
  Future<int> createSession(SessionModel session) async => 1;
  @override
  Future<Map<String, int>> getProgressCountsByState() async => {};
  @override
  Future<int> getTotalItemCount() async => 0;
  @override
  Future<int> getSessionCount() async => 0;
  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async =>
      [];
  @override
  Future<int> getTotalItemCountForLesson(int lessonId) async => 0;

  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;
}

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
}

LevelModel _level(int id) => LevelModel(
      id: id,
      number: id,
      nameFr: 'Niveau $id',
      nameEn: 'Level $id',
      nameAr: 'المستوى $id',
      unitCount: 3,
    );

Widget _buildApp({
  required SharedPreferencesSource prefsSource,
  FakeContentRepository? contentRepo,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
      progressRepositoryProvider
          .overrideWithValue(FakeProgressRepository()),
      contentRepositoryProvider
          .overrideWithValue(contentRepo ?? FakeContentRepository()),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: SettingsScreen(),
    ),
  );
}

void main() {
  group('SettingsScreen', () {
    testWidgets('shows title and mode section', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text("Mode d'apprentissage"), findsOneWidget);
      expect(find.text('Cursus (sélection libre)'), findsOneWidget);
      expect(find.text('Autodidacte (progression guidée)'), findsOneWidget);
    });

    testWidgets('shows level selector with levels', (tester) async {
      final contentRepo = FakeContentRepository();
      contentRepo.levels = [_level(1), _level(2), _level(3)];

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 2,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        contentRepo: contentRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Niveau actif'), findsOneWidget);
      expect(find.text('Niveau 1'), findsOneWidget);
      expect(find.text('Niveau 2'), findsOneWidget);
      expect(find.text('Niveau 3'), findsOneWidget);
    });

    testWidgets('shows check icon on selected level', (tester) async {
      final contentRepo = FakeContentRepository();
      contentRepo.levels = [_level(1), _level(2)];

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        contentRepo: contentRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });

    testWidgets('curriculum mode card is selected by default', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      // The ModeCard for curriculum should show check_circle
      expect(find.byIcon(Icons.check_circle), findsWidgets);
      expect(find.byIcon(Icons.school), findsOneWidget);
      expect(find.byIcon(Icons.self_improvement), findsOneWidget);
    });

    testWidgets('tapping autodidact card switches mode', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      // Tap the autodidact card
      await tester.tap(find.text('Autodidacte (progression guidée)'));
      await tester.pumpAndSettle();

      // Verify the SharedPreferences were updated
      final savedMode =
          SharedPreferencesSource(prefs).getLearningMode();
      expect(savedMode, 'autodidact');
    });
  });
}
