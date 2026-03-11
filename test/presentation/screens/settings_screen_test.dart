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
import 'package:mufeed_app/domain/models/sentence_exercise_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mufeed_app/domain/models/daily_activity_model.dart';
import 'package:mufeed_app/domain/models/upcoming_reviews_model.dart';

class FakeProgressRepository implements ProgressRepository {
  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async => [];
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      [];
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLessons(List<int> lessonIds) async => [];
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
  Future<Map<String, Map<String, int>>> getProgressCountsByStateAndType() async => {};
  @override
  Future<int> getTotalWordCount() async => 0;
  @override
  Future<int> getTotalVerbCount() async => 0;
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

  @override
  Future<List<DailyActivityModel>> getReviewActivity({int days = 14}) async => [];
  @override
  Future<UpcomingReviewsModel> getUpcomingReviews() async =>
      const UpcomingReviewsModel(dueToday: 0, dueTomorrow: 0, dueThisWeek: 0);

  @override
  Future<List<ReviewableItemModel>> getNewWordsForLevel(int levelId, int limit) =>
      Future.value([]);

  @override
  Future<({int lessonId, int totalItems, int masteredCount})>
      getLessonProgressSummary(int lessonId) =>
      Future.value((lessonId: lessonId, totalItems: 0, masteredCount: 0));
  @override
  Future<int> getNewWordsIntroducedTodayCount() => Future.value(0);

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
    testWidgets('shows title and learning section', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Apprentissage'), findsOneWidget);
      expect(find.text('Nouveaux mots par jour'), findsOneWidget);
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

    testWidgets('shows new words per day segmented button', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.byType(SegmentedButton<int>), findsOneWidget);
      // Default value is 5
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('tapping new words per day updates preference', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      // Tap the 10 segment
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      final savedValue = SharedPreferencesSource(prefs).getNewWordsPerDay();
      expect(savedValue, 10);
    });
  });
}
